//
//  Item.swift
//  Mealary
//
//  Created by Martin Ivančo on 24/08/2020.
//  Copyright © 2020 Martin Ivančo. All rights reserved.
//

import CoreData

extension Item: Identifiable {
    var meal: Meal {
        get { meal_! }
        set { meal_ = newValue }
    }
    
    var food: Food {
        get { food_! }
        set { food_ = newValue }
    }
    
    func nutritionValue(for nutrient: Nutrient) -> Double {
        return food.nutritionValue(for: nutrient) * weight / 100.0
    }
}
