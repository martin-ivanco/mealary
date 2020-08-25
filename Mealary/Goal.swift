//
//  Goal.swift
//  Mealary
//
//  Created by Martin Ivančo on 25/08/2020.
//  Copyright © 2020 Martin Ivančo. All rights reserved.
//

import CoreData

extension Goal {
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Goal> {
        let request = NSFetchRequest<Goal>(entityName: "Goal")
        request.predicate = predicate
        return request
    }
    
    static func value(for nutrient: Nutrient, context: NSManagedObjectContext) -> Double {
        let request = fetchRequest(NSPredicate(format: "type_ = \(Int16(nutrient.id))"))
        let goals = (try? context.fetch(request)) ?? []
        if let goal = goals.first {
            return goal.value
        } else {
            switch nutrient {
            case .calories:
                return 2000
            case .carbs:
                return 300
            case .proteins:
                return 60
            case .fats:
                return 60
            }
        }
    }
    
    static func string(for nutrient: Nutrient, context: NSManagedObjectContext) -> String {
        switch nutrient {
        case .calories:
            return "\(Int(round(value(for: nutrient, context: context)))) cal"
        default:
            return "\(Int(round(value(for: nutrient, context: context)))) g"
        }
    }
    
    static func set(for nutrient: Nutrient, value: Double, context: NSManagedObjectContext) {
        let request = fetchRequest(NSPredicate(format: "type_ = \(Int16(nutrient.id))"))
        let goals = (try? context.fetch(request)) ?? []
        if let goal = goals.first {
            goal.value = value
        } else {
            let goal = Goal(context: context)
            goal.type = nutrient
            goal.value = value
        }
    }
    
    var type: Nutrient {
        get { Nutrient.byId(Int(type_))! }
        set { type_ = Int16(newValue.id) }
    }
}
