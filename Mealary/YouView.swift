//
//  YouView.swift
//  Mealary
//
//  Created by Martin Ivančo on 25/08/2020.
//  Copyright © 2020 Martin Ivančo. All rights reserved.
//

import SwiftUI
import SwiftUICharts
import CoreData

struct YouView: View {
    @Environment(\.managedObjectContext) var context
    @State private var showLogView = false
    @State private var showGoalsView = false
    
    var body: some View {
        NavigationView {
            GeometryReader(content: {geometry in
                VStack {
                    HStack {
                        Text("Weight").font(.title).bold()
                        Spacer()
                        Button("Log") {
                            self.showLogView = true
                        }
                    }
                        .padding([.leading, .trailing])
                        .sheet(isPresented: self.$showLogView) {
                            LogView(isPresented: self.$showLogView)
                                .environment(\.managedObjectContext, self.context)
                        }
                    LineChart()
                        .data(Day.weights(context: self.context))
                        .chartStyle(ChartStyle(backgroundColor: .white, foregroundColor: [ColorGradient(.purple, .blue)]))
                        .padding()
                        .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.3, alignment: .center)
                    HStack {
                        Text("Daily goals").font(.title).bold()
                        Spacer()
                        Button("Edit") {
                            self.showGoalsView = true
                        }
                    }
                        .padding([.leading, .trailing, .bottom])
                        .sheet(isPresented: self.$showGoalsView) {
                            GoalsView(isPresented: self.$showGoalsView)
                                .environment(\.managedObjectContext, self.context)
                        }
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Calories:").font(.headline)
                            Text("Carbs:").font(.headline)
                            Text("Proteins:").font(.headline)
                            Text("Fats:").font(.headline)
                        }
                        VStack(alignment: .leading) {
                            Text(Goal.string(for: .calories, context: self.context))
                            Text(Goal.string(for: .carbs, context: self.context))
                            Text(Goal.string(for: .proteins, context: self.context))
                            Text(Goal.string(for: .fats, context: self.context))
                        }
                        Spacer()
                    }.padding([.leading, .trailing])
                    Spacer()
                }
                .navigationBarTitle("You")
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct GoalsView: View {
    @Environment(\.managedObjectContext) var context
    @Binding var isPresented: Bool
    
    @State private var calories : Double? = nil
    @State private var carbs : Double? = nil
    @State private var proteins : Double? = nil
    @State private var fats : Double? = nil
    @State private var fieldError = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("CALORIES")) {
                    NumberField("", value: self.$calories)
                    .onAppear() {
                        self.calories = Goal.value(for: .calories, context: self.context)
                    }
                }
                Section(header: Text("CARBS")) {
                    NumberField("", value: self.$carbs)
                    .onAppear() {
                        self.carbs = Goal.value(for: .carbs, context: self.context)
                    }
                }
                Section(header: Text("PROTEINS")) {
                    NumberField("", value: self.$proteins)
                    .onAppear() {
                        self.proteins = Goal.value(for: .proteins, context: self.context)
                    }
                }
                Section(header: Text("FATS")) {
                    NumberField("", value: self.$fats)
                    .onAppear() {
                        self.fats = Goal.value(for: .fats, context: self.context)
                    }
                }
            }
            .navigationBarTitle("Edit goals")
            .navigationBarItems(
                leading: Button("Cancel") {
                    self.isPresented = false
                },
                trailing: Button("Update") {
                    if let cal = self.calories, let car = self.carbs, let pro = self.proteins, let fat = self.fats {
                        Goal.set(for: .calories, value: cal, context: self.context)
                        Goal.set(for: .carbs, value: car, context: self.context)
                        Goal.set(for: .proteins, value: pro, context: self.context)
                        Goal.set(for: .fats, value: fat, context: self.context)
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
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct LogView: View {
    @Environment(\.managedObjectContext) var context
    @Binding var isPresented: Bool
    
    @State private var weight : Double? = nil
    @State private var fieldError = false
    
    var body: some View {
        NavigationView {
            Form {
                NumberField("Weight in kg", value: self.$weight)
            }
            .navigationBarTitle("Log weight")
            .navigationBarItems(
                leading: Button("Cancel") {
                    self.isPresented = false
                },
                trailing: Button("Update") {
                    if let weight = self.weight {
                        Day.logWeight(weight, context: self.context)
                        self.isPresented = false
                    } else {
                        self.fieldError = true
                    }
                }
            )
            .alert(isPresented: $fieldError) {
                Alert(title: Text("Field Error!"), message: Text("Please provide a valid weight."), dismissButton: .default(Text("OK")))
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct YouView_Previews: PreviewProvider {
    static var previews: some View {
        YouView()
    }
}
