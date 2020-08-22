//
//  Food.swift
//  Mealary
//
//  Created by Martin Ivančo on 22/08/2020.
//  Copyright © 2020 Martin Ivančo. All rights reserved.
//

import CoreData

extension Food: Identifiable {
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Food> {
        let request = NSFetchRequest<Food>(entityName: "Food")
        request.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        request.predicate = predicate
        return request
    }
    
    var name: String {
        get { name_! }
        set { name_ = newValue }
    }
    
    func nutritionValue(for nutrient: Nutrient) -> Double {
        switch nutrient {
        case .calories:
            return calories
        case .carbs:
            return carbs
        case .proteins:
            return proteins
        case .fats:
            return fats
        }
    }
}
