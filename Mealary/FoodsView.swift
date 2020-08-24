//
//  FoodsView.swift
//  Mealary
//
//  Created by Martin Ivančo on 23/08/2020.
//  Copyright © 2020 Martin Ivančo. All rights reserved.
//

import SwiftUI

struct FoodsView: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: Food.fetchRequest(.all)) var foods: FetchedResults<Food>
    @State private var showNewFoodCreator = false
    @State private var showFoodEditor = false
    @State private var foodToEdit: Food?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(foods) { food in
                    HStack {
                        Text(food.name)
                        Spacer()
                        Image(systemName: "chevron.right").imageScale(.small).foregroundColor(.gray)
                    }
                        .onTapGesture {
                            self.foodToEdit = food
                            self.showFoodEditor = true
                        }
                }
            }
            .sheet(isPresented: $showFoodEditor) {
                FoodView(self.foodToEdit!, isPresented: self.$showFoodEditor)
                .environment(\.managedObjectContext, self.context)
            }
            .navigationBarTitle("Foods")
            .navigationBarItems(
                trailing: Button(
                    action: {
                        self.showNewFoodCreator = true
                    },
                    label: {
                        Image(systemName: "plus").imageScale(.large)
                    }
                )
                .sheet(isPresented: $showNewFoodCreator) {
                    FoodView(nil, isPresented: self.$showNewFoodCreator)
                    .environment(\.managedObjectContext, self.context)
                }
            )
        }
    }
}

struct FoodView: View {
    var food: Food?
    @Environment(\.managedObjectContext) var context
    @Binding var isPresented: Bool
    
    @State private var name: String = ""
    @State private var calories : Double? = nil
    @State private var carbs : Double? = nil
    @State private var proteins : Double? = nil
    @State private var fats : Double? = nil
    @State private var fieldError = false
    @State private var deleteWarning = false
    
    init(_ food: Food?, isPresented: Binding<Bool>) {
        self.food = food
        _isPresented = isPresented
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name).onAppear() {
                    if let f = self.food {
                        self.name = f.name
                    }
                }
                Section(header: Text("Nutrition values per 100 grams")) {
                    NumberField("Calories", value: $calories)
                        .onAppear() {
                            if let f = self.food {
                                self.calories = f.calories
                            }
                        }
                    NumberField("Carbs", value: $carbs)
                        .onAppear() {
                            if let f = self.food {
                                self.carbs = f.carbs
                            }
                        }
                    NumberField("Proteins", value: $proteins)
                        .onAppear() {
                            if let f = self.food {
                                self.proteins = f.proteins
                            }
                        }
                    NumberField("Fats", value: $fats)
                        .onAppear() {
                            if let f = self.food {
                                self.fats = f.fats
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
                .hiddenConditionally(isHidden: food == nil)
            }
            .navigationBarTitle(food != nil ? "Edit food" : "Create a food")
            .navigationBarItems(
                leading: Button("Cancel") {
                    self.isPresented = false
                },
                trailing: Button(food != nil ? "Update" : "Create") {
                    if !self.name.isEmpty, let cal = self.calories, let car = self.carbs, let pro = self.proteins, let fat = self.fats {
                        if let food = self.food {
                            food.name = self.name
                            food.calories = cal
                            food.carbs = car
                            food.proteins = pro
                            food.fats = fat
                        } else {
                            let food = Food(context: self.context)
                            food.name = self.name
                            food.calories = cal
                            food.carbs = car
                            food.proteins = pro
                            food.fats = fat
                        }
                        try! self.context.save()
                        self.isPresented = false
                    } else {
                        self.fieldError = true
                    }
                }
            )
            .alert(isPresented: $fieldError) {
                Alert(title: Text("Field Error!"), message: Text("Please fill out all fields with valid values."), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: $deleteWarning) {
                Alert(title: Text("Delete Food"), message: Text("Are you sure you want to delete this food?"), primaryButton: .destructive(Text("Delete"), action: {
                    self.context.delete(self.food!)
                    try! self.context.save()
                    self.isPresented = false
                }), secondaryButton: .cancel())
            }
        }
    }
}

struct FoodsView_Previews: PreviewProvider {
    static var previews: some View {
        FoodsView()
    }
}
