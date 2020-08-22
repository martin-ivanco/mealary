//
//  Meal.swift
//  Mealary
//
//  Created by Martin Ivančo on 22/08/2020.
//  Copyright © 2020 Martin Ivančo. All rights reserved.
//

import CoreData

extension Meal {
    var type: MealType {
        get { MealType.byId(Int(type_))! }
        set { type_ = Int16(newValue.id) }
    }
    
    var day: Day {
        get { day_! }
        set { day_ = newValue }
    }
    
    var foods: Set<Food> {
        get { (foods_ as? Set<Food>) ?? [] }
        set { foods_ = newValue as NSSet }
    }
    
    func nutritionValue(for nutrient: Nutrient) -> Double {
        var sum: Double = 0
        for food in self.foods {
            sum += food.nutritionValue(for: nutrient)
        }
        return sum
    }
}

enum MealType: Identifiable {
    case breakfast, morningSnack, lunch, afternoonSnack, dinner, nightSnack
    
    static let orderedTypes: [MealType] = [.breakfast, .morningSnack, .lunch, .afternoonSnack, .dinner, .nightSnack]
    
    var id: Int {
        switch self {
        case .breakfast:
            return 0
        case .morningSnack:
            return 1
        case .lunch:
            return 2
        case .afternoonSnack:
            return 3
        case .dinner:
            return 4
        case .nightSnack:
            return 5
        }
    }
    
    var name: String {
        switch self {
        case .breakfast:
            return "Breakfast"
        case .morningSnack:
            return "Morning Snack"
        case .lunch:
            return "Lunch"
        case .afternoonSnack:
            return "Afternoon Snack"
        case .dinner:
            return "Dinner"
        case .nightSnack:
            return "Night Snack"
        }
    }
    
    static func byId(_ id: Int) -> MealType? {
        switch id {
        case 0:
            return .breakfast
        case 1:
            return .morningSnack
        case 2:
            return .lunch
        case 3:
            return .afternoonSnack
        case 4:
            return .dinner
        case 5:
            return .nightSnack
        default:
            return nil
        }
    }
}
