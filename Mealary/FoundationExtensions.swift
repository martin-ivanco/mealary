//
//  FoundationExtensions.swift
//  Mealary
//
//  Created by Martin Ivančo on 22/08/2020.
//  Copyright © 2020 Martin Ivančo. All rights reserved.
//

import Foundation

extension NSPredicate {
    static var all = NSPredicate(format: "TRUEPREDICATE")
    static var none = NSPredicate(format: "FALSEPREDICATE")
}

extension Date {
    var startOfDay: Date {
        get {
            return Calendar.current.startOfDay(for: self)
        }
    }
}
