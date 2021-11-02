//
//  Pie.swift
//  Memoization
//
//  Created by Frank Su on 2021-11-02.
//

import SwiftUI

// Pie is to draw a cirlce that counts down in counterclock wise direction
// need to find center, then radius, then draw counterclockwise from there
struct Pie: Shape {
    var startAngle: Angle
    var endAngle: Angle
    // need var for struct here or else default value would always be false
    var clockWise: Bool = false
    
    func path(in rect: CGRect) -> Path {
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        // draw from start where the line is directly above center
        let start = CGPoint(
            x: center.x + radius * CGFloat(cos(startAngle.radians)),
            y: center.y + radius * CGFloat(sin(startAngle.radians))
        )
        
        var p = Path()
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(center: center,
                 radius: radius,
                 startAngle: startAngle,
                 endAngle: endAngle,
                 // not clockwise since iOS counts 0,0 from top left corner instead of bottom left like x,y axis so everything is 'flipped' per say
                 clockwise: !clockWise
        )
        return p
    }
    
    
}
