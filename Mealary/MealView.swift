//
//  MealView.swift
//  Mealary
//
//  Created by Martin Ivančo on 24/08/2020.
//  Copyright © 2020 Martin Ivančo. All rights reserved.
//

import SwiftUI
import CoreData

struct MealView: View {
    @State var meal: Meal
    @State private var editMode = EditMode.inactive
    @State private var showItemEditor = false
    @State private var itemToEdit: Item? = nil
    @State private var itemFood: Food? = nil
    @State private var itemWeight: Double? = nil
    @FetchRequest(fetchRequest: Food.fetchRequest(.all)) var foods: FetchedResults<Food>
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("MEAL ITEMS")) {
                    List {
                        ForEach(Array(meal.items)) { item in
                            HStack{
                                Image(systemName: "pencil.circle.fill")
                                    .foregroundColor(.blue)
                                    .hiddenConditionally(isHidden: self.editMode == .inactive)
                                Text(item.food.name)
                                Spacer()
                                Text("\(Int(round(item.weight))) g").foregroundColor(.gray)
                            }
                            .onTapGesture {
                                if self.editMode == .active {
                                    self.itemToEdit = item
                                    self.itemFood = nil
                                    self.showItemEditor = true
                                }
                            }
                        }
                    }
                }
                Section(header: Text("AVAILABLE FOODS")) {
                    List {
                        ForEach(foods) { food in
                            HStack {
                                Image(systemName: "plus.circle.fill").foregroundColor(.green)
                                Text(food.name)
                            }
                            .onTapGesture {
                                self.itemToEdit = nil
                                self.itemFood = food
                                self.showItemEditor = true
                            }
                        }
                    }
                }
                .hiddenConditionally(isHidden: editMode == .inactive)
            }
            .navigationBarTitle(meal.type.name)
            .navigationBarItems(trailing: EditButton())
            .environment(\.editMode, $editMode)
            .sheet(isPresented: $showItemEditor) {
                ItemView(item: self.itemToEdit, meal: self.meal, food: self.itemFood, isPresented: self.$showItemEditor)
            }
        }
    }
}

struct ItemView: View {
    let item: Item?
    let meal: Meal?
    let food: Food?
    let context: NSManagedObjectContext
    @Binding var isPresented: Bool
    
    @State private var weight : Double? = nil
    @State private var fieldError = false
    @State private var deleteWarning = false
    
    init(item: Item?, meal: Meal?, food: Food?, isPresented: Binding<Bool>) {
        self.item = item
        self.meal = meal
        self.food = food ?? item!.food
        if item == nil {
            self.context = meal!.managedObjectContext!
        } else {
            self.context = item!.managedObjectContext!
        }
        _isPresented = isPresented
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(food!.name)) {
                    NumberField("Weight", value: $weight)
                    .onAppear() {
                        if let i = self.item {
                            self.weight = i.weight
                        }
                    }
                }
                Button(
                    action: {
                        self.deleteWarning = true
                    },
                    label: {
                        Text("Delete food").foregroundColor(Color.red)
                    }
                )
                .hiddenConditionally(isHidden: item == nil)
            }
            .navigationBarTitle(item != nil ? "Edit meal item" : "Add meal item")
            .navigationBarItems(
                leading: Button("Cancel") {
                    self.isPresented = false
                },
                trailing: Button(item != nil ? "Update" : "Add") {
                    if let weight = self.weight {
                        if let item = self.item {
                            item.weight = weight
                        } else {
                            let item = Item(context: self.context)
                            item.food = self.food!
                            item.weight = weight
                            self.meal!.addToItems_(item)
                        }
                        try! self.context.save()
                        self.isPresented = false
                    } else {
                        self.fieldError = true
                    }
                }
            )
            .alert(isPresented: $fieldError) {
                Alert(title: Text("Field Error!"), message: Text("Please provide a valid weight."), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: $deleteWarning) {
                Alert(title: Text("Delete Item"), message: Text("Are you sure you want to delete this item?"), primaryButton: .destructive(Text("Delete"), action: {
                    self.context.delete(self.item!)
                    try! self.context.save()
                    self.isPresented = false
                }), secondaryButton: .cancel())
            }
        }
    }
}
