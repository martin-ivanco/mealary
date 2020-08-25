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
    
    var id: Int {
        switch self {
        case .calories:
            return 0
        case .carbs:
            return 1
        case .proteins:
            return 2
        case .fats:
            return 3
        }
    }
    
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
    
    static func byId(_ id: Int) -> Nutrient? {
        switch id {
        case 0:
            return .calories
        case 1:
            return .carbs
        case 2:
            return .proteins
        case 3:
            return .fats
        default:
            return nil
        }
    }
}
