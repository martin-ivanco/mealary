//
//  FoundationExtensions.swift
//  Mealary
//
//  Created by Martin Ivančo on 22/08/2020.
//  Copyright © 2020 Martin Ivančo. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

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

extension View {
    func hiddenConditionally(isHidden: Bool) -> some View {
        isHidden ? AnyView(EmptyView()) : AnyView(self)
    }
}

struct NumberField : View {
    let label: String
    @State private var enteredValue : String = ""
    @State private var valid : Bool = true
    @Binding var value : Double?
    
    init(_ label: String, value: Binding<Double?>) {
        self.label = label
        _value = value
    }

    var body: some View {
        TextField(label, text: $enteredValue)
            .onReceive(Just(enteredValue)) { typedValue in
                if let newValue = Double(typedValue) {
                    self.value = newValue
                    self.valid = true
                } else {
                    self.value = nil
                    self.valid = false
                }
            }
            .onAppear() {
                if let v = self.value {
                    self.enteredValue = "\(v)"
                }
            }
            .foregroundColor(valid ? Color.primary : Color.red)
    }
}
