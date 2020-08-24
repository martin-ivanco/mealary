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
    
    @State private var day: Day? = nil
    @State private var date = Date()
    @State private var showDatePicker = false
    
    var body: some View {
        NavigationView {
            DayView(day: day ?? Day.withDate(date, context: self.context))
            .navigationBarItems(trailing: Button(
                action: {
                    self.showDatePicker = true
                }, label: {
                    Image(systemName: "calendar").imageScale(.large)
                })
            .sheet(isPresented: $showDatePicker) {
                NavigationView {
                    DatePicker("Select a date", selection: self.$date, displayedComponents: .date)
                        .labelsHidden()
                        .navigationBarTitle("Choose date")
                        .navigationBarItems(
                            leading: Button("Cancel") {
                                if self.day == nil {
                                    self.day = Day.withDate(Date(), context: self.context)
                                }
                                self.date = self.day!.date
                                self.showDatePicker = false
                            },
                            trailing: Button("Choose") {
                                self.day = Day.withDate(self.date, context: self.context)
                                self.showDatePicker = false
                            }
                        )
                }
            })
        }
    }
}

struct DayView: View {
    let day: Day
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
                    HStack {
                        Text(mealType.name)
                        Spacer()
                        Image(systemName: "chevron.right").imageScale(.small).foregroundColor(.gray)
                    }
                    .onTapGesture {
                        self.mealToEdit = mealType
                        self.showMealEditor = true
                    }
                }
            }
            .sheet(isPresented: self.$showMealEditor) {
                MealView(meal: self.day.meal(self.mealToEdit!))
                    .environment(\.managedObjectContext, self.day.managedObjectContext!)
            }
        }
        .navigationBarTitle("\(day.date)")
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
                    Text(nutrient.unit).foregroundColor(.gray)
                }
            }.foregroundColor(nutrient.color)
            Text("\(nutrient.name)").font(.headline).foregroundColor(.gray)
        }
    }
}

struct DiaryView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryView()
    }
}
