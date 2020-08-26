//
//  CircleProgressBar.swift
//  Memorize
//
//  Created by Martin Ivančo on 08/07/2020.
//  Copyright © 2020 Martin Ivančo. All rights reserved.
//

import SwiftUI

struct CircleProgressBar: Shape {
    var value: Double
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(
            x: center.x,
            y: center.y - radius
        )
        
        var p = Path()
        p.move(to: start)
        p.addArc(center: center, radius: radius, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: -90 + Double(radius) * 360), clockwise: false)
        return p
    }
}
