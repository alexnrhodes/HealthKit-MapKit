//
//  ARGradientView.swift
//  HealthKit-MapKit
//
//  Created by Alex Rhodes on 5/11/20.
//  Copyright © 2020 Alex Rhodes. All rights reserved.
//

import UIKit

class ARGradientView: UIView {
    
    
    override func draw(_ rect: CGRect) {
        
        if let context = UIGraphicsGetCurrentContext() {
                  
                  
            let corner1 = CGPoint.zero
            let corner2 = CGPoint(x: rect.size.width, y: 0)
            let corner3 = CGPoint(x: rect.size.width, y: rect.size.height)
            let corner4 = CGPoint(x: 0, y: rect.size.height)
            
            context.move(to: corner1)
            context.addLine(to: corner2)
            context.addLine(to: corner3)
            context.addLine(to: corner4)
            context.addLine(to: corner1)

            let context = UIGraphicsGetCurrentContext()!
            let colors = [UIColor.graidentGray1.cgColor,UIColor.graidentGray2.cgColor]
            
            // 3
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            
            // 4
            let colorLocations: [CGFloat] = [0.0, 1.0]
            
            // 5
            let gradient = CGGradient(colorsSpace: colorSpace,
                                      colors: colors as CFArray,
                                      locations: colorLocations)!
            
            // 6
            let startPoint = corner1
            let endPoint = corner2
            context.drawLinearGradient(gradient,
                                       start: startPoint,
                                       end: endPoint,
                                       options: [])
            

            context.move(to: corner3)
            context.addLine(to: corner4)
            
            context.setStrokeColor(UIColor.strokeGray.cgColor)
            context.setLineWidth(1)
            context.strokePath()
            
            
        }
    }
}
