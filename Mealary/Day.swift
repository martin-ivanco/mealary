//
//  Day.swift
//  Mealary
//
//  Created by Martin Ivančo on 22/08/2020.
//  Copyright © 2020 Martin Ivančo. All rights reserved.
//

import CoreData

extension Day {
    static func withDate(_ date: Date, context: NSManagedObjectContext) -> Day {
        // look up date in Core Data
        let request = fetchRequest(NSPredicate(format: "date_ = %@", date.startOfDay as NSDate))
        let days = (try? context.fetch(request)) ?? []
        if let day = days.first {
            // if found, return corresponding day
            return day
        } else {
            // if not, create one
            let day = Day(context: context)
            day.date = date.startOfDay
            return day
        }
    }
    
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Day> {
        let request = NSFetchRequest<Day>(entityName: "Day")
        request.sortDescriptors = [NSSortDescriptor(key: "date_", ascending: true)]
        request.predicate = predicate
        return request
    }
    
    var date: Date {
        get { date_! }
        set { date_ = newValue }
    }
    
    var meals: Set<Meal> {
        get { (meals_ as? Set<Meal>) ?? [] }
        set { meals_ = newValue as NSSet }
    }
    
    func nutritionValue(for nutrient: Nutrient) -> Double {
        var sum: Double = 0
        for meal in self.meals {
            sum += meal.nutritionValue(for: nutrient)
        }
        return sum
    }
    
    func meal(_ type: MealType) -> Meal {
        // check if meal of requested type already exists for this day
        var existing: Meal?
        for meal in meals {
            if meal.type == type {
                existing = meal
                break
            }
        }
        if let meal = existing {
            // if yes, return it
            return meal
        } else {
            // if not, create it
            let meal = Meal(context: managedObjectContext!)
            meal.type = type
            meal.day = self
            return meal
        }
    }
}
