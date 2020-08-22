//
//  DiaryView.swift
//  Mealary
//
//  Created by Martin Ivančo on 22/08/2020.
//  Copyright © 2020 Martin Ivančo. All rights reserved.
//

import SwiftUI

struct DiaryView: View {
    @Environment(\.managedObjectContext) var context
    
    @State private var date = Date()
    
    var body: some View {
        NavigationView {
            DayView(day: Day.withDate(date, context: context))
                .navigationBarTitle("\(date)")
                .navigationBarItems(trailing: datePicker)
        }
    }
    
    @State private var showDatePicker = false
    
    var datePicker: some View {
        Button(
            action: {
                self.showDatePicker = true
            }, label: {
                Image(systemName: "calendar")
            })
        .sheet(isPresented: $showDatePicker) {
            DatePicker("Select a date", selection: self.$date, displayedComponents: .date).labelsHidden()
        }
    }
}

struct DayView: View {
    @State var day: Day
    
    @State private var showMealEditor = false
    @State private var mealToEdit: MealType? = nil
    
    var body: some View {
        VStack {
            NutrientView(nutrient: .calories, value: day.nutritionValue(for: .calories))
            HStack {
                NutrientView(nutrient: .carbs, value: day.nutritionValue(for: .carbs))
                NutrientView(nutrient: .proteins, value: day.nutritionValue(for: .proteins))
                NutrientView(nutrient: .fats, value: day.nutritionValue(for: .fats))
            }
            List {
                ForEach(MealType.orderedTypes) { mealType in
                    Text(mealType.name)
                    .onTapGesture {
                        self.mealToEdit = mealType
                        self.showMealEditor = true
                    }
                }
            }
            .sheet(isPresented: self.$showMealEditor) {
                MealEditor(meal: self.day.meal(self.mealToEdit!))
                    .environment(\.managedObjectContext, self.day.managedObjectContext!)
            }
        }
    }
}

struct NutrientView: View {
    let nutrient: Nutrient
    let value: Double
    
    var body: some View {
        GeometryReader(content: {geometry in
            self.body(for: geometry.size)
        })
    }
    
    private func body(for size: CGSize) -> some View {
        let radius = min(0.7 * size.width, 0.7 * size.height)
        return VStack {
            ZStack {
                Circle().stroke(lineWidth: 0.1 * radius).fill(nutrient.color).frame(width: radius, height: radius)
                VStack {
                    Text("\(Int(round(value)))").font(.title)
                    Text(nutrient.unit).foregroundColor(Color.gray)
                }
            }.foregroundColor(nutrient.color)
            Text("\(nutrient.name)").font(.headline).foregroundColor(Color.gray)
        }
    }
}

struct MealEditor: View {
    @State var meal: Meal
    @FetchRequest(fetchRequest: Food.fetchRequest(.all)) var foods: FetchedResults<Food>
    
    var body: some View {
        VStack {
            Text(meal.type.name).font(.title)
            List {
                ForEach(Array(meal.foods)) { food in
                    Text(food.name)
                }
            }
            Divider()
            List {
                ForEach(foods) { food in
                    Text(food.name)
                }
            }
        }
        
    }
}

struct DiaryView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryView()
    }
}
