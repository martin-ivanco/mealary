//
//  Nutrient.swift
//  Mealary
//
//  Created by Martin Ivančo on 20/08/2020.
//  Copyright © 2020 Martin Ivančo. All rights reserved.
//

import SwiftUI

enum Nutrient {
    case calories, carbs, proteins, fats
    
    var name: String {
        switch self {
        case .calories:
            return "Calories"
        case .carbs:
            return "Carbs"
        case .proteins:
            return "Proteins"
        case .fats:
            return "Fats"
        }
    }
    
    var color: Color {
        switch self {
        case .calories:
            return Color.green
        default:
            return Color.blue
        }
    }
    
    var unit: String {
        switch self {
        case .calories:
            return "kcal"
        default:
            return "g"
        }
    }
}
