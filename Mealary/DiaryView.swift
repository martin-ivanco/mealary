//
//  DiaryView.swift
//  Mealary
//
//  Created by Martin Ivančo on 22/08/2020.
//  Copyright © 2020 Martin Ivančo. All rights reserved.
//

import SwiftUI
import CoreData

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
            NutrientView(
                nutrient: .calories,
                value: day.nutritionValue(for: .calories),
                goal: Goal.value(for: .calories, context: self.day.managedObjectContext!)
            )
            HStack {
                NutrientView(
                    nutrient: .carbs,
                    value: day.nutritionValue(for: .carbs),
                    goal: Goal.value(for: .carbs, context: self.day.managedObjectContext!)
                )
                NutrientView(
                    nutrient: .proteins,
                    value: day.nutritionValue(for: .proteins),
                    goal: Goal.value(for: .proteins, context: self.day.managedObjectContext!)
                )
                NutrientView(
                    nutrient: .fats,
                    value: day.nutritionValue(for: .fats),
                    goal: Goal.value(for: .fats, context: self.day.managedObjectContext!)
                )
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
    let goal: Double
    
    var body: some View {
        GeometryReader(content: {geometry in
            self.body(for: geometry.size)
        })
    }
    
    private func body(for size: CGSize) -> some View {
        let radius = min(0.7 * size.width, 0.7 * size.height)
        return VStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 0.1 * radius)
                    .opacity(value / goal <= 1 ? 0.3 : 1)
                    .frame(width: radius, height: radius)
                Circle()
                    .trim(from: 0, to: CGFloat((value / goal).truncatingRemainder(dividingBy: 1)))
                    .stroke(style: StrokeStyle(lineWidth: 0.1 * radius, lineCap: .round, lineJoin: .round))
                    .foregroundColor(value / goal <= 1 ? nutrient.color : Color.red)
                    .frame(width: radius, height: radius)
                    .rotationEffect(Angle(degrees: 270))
                    .animation(.linear)
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
