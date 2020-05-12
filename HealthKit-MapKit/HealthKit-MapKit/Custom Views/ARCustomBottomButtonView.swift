//
//  ARCustomBottomButtonView.swift
//  HealthKit-MapKit
//
//  Created by Alex Rhodes on 5/11/20.
//  Copyright © 2020 Alex Rhodes. All rights reserved.
//

import UIKit

@IBDesignable class ARCustomBottomButtomView: UIView {
    
    var buttonImage: UIImage?
    
    @IBInspectable var startColor: UIColor = UIColor.graidentGray1
    @IBInspectable var endColor: UIColor = UIColor.graidentGray2
    @IBInspectable var strokeColor: UIColor = UIColor.strokeGray
    
    
    
    override func draw(_ rect: CGRect) {
        
        if let context = UIGraphicsGetCurrentContext() {
            
            
            let corner1 = CGPoint(x: 0, y: rect.size.height)
            let corner2 = CGPoint(x: 0, y: rect.size.height * 0.5)
            let corner3 = CGPoint(x: rect.size.width * 0.375, y: rect.size.height * 0.4)
            let controlCurve = CGPoint(x: rect.size.width * 0.5, y: 0)
            let corner5 = CGPoint(x: rect.size.width * 0.625, y: rect.size.height * 0.4)
            let corner6 = CGPoint(x: rect.size.width, y: rect.size.height * 0.5)
            let corner7 = CGPoint(x: rect.size.width, y: rect.size.height)
            
            context.move(to: corner1)
            context.addLine(to: corner2)
            context.addLine(to: corner3)
            context.addQuadCurve(to: corner5, control: controlCurve)
            context.addLine(to: corner5)
            context.addLine(to: corner6)
            context.addLine(to: corner7)
            context.addLine(to: corner1)
            
            context.clip()
            
//            let context = UIGraphicsGetCurrentContext()!
            let colors = [startColor.cgColor, endColor.cgColor]
            
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
            let endPoint = corner7
            context.drawLinearGradient(gradient,
                                       start: startPoint,
                                       end: endPoint,
                                       options: [])
            
            
            context.setFillColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
            context.fillPath()
            
            context.move(to: corner2)
            context.addLine(to: corner3)
            context.addQuadCurve(to: corner5, control: controlCurve)
            context.addLine(to: corner5)
            context.addLine(to: corner6)
            
            context.setStrokeColor(strokeColor.cgColor)
            context.setLineWidth(2)
            context.strokePath()
            
            
            let buttonEllipse = CGRect(x: rect.size.width * 0.375, y: rect.size.height * 0.25, width: rect.size.width * 0.25, height: rect.size.height * 0.73)

            context.addEllipse(in: buttonEllipse)

            let colorSpaceEllipse = CGColorSpaceCreateDeviceRGB()
            
            // 2
            let colorLocationsEllipse: [CGFloat] = [0.0, 1.0]
            
            // 3
            let colorsEllipse: CFArray = [#colorLiteral(red: 0, green: 1, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.3890221715, blue: 0.08304802328, alpha: 1)] as CFArray
            
            // 4
            let gradientEllipse = CGGradient(colorsSpace: colorSpaceEllipse, colors: colorsEllipse, locations: colorLocationsEllipse)!
            context.clip()
            
            let startPointEllipse = CGPoint(x: 0, y: 0)
            let endPointEllipse = CGPoint(x: 0, y: buttonEllipse.height)
            context.drawLinearGradient(gradientEllipse,
                                                  start: startPointEllipse,
                                                  end: endPointEllipse,
                                                  options: [])
            context.setFillColor(#colorLiteral(red: 0, green: 0.3891800344, blue: 0.0907118395, alpha: 1))
            context.fillPath()
            
        }
    }
    
    fileprivate func initWith(buttonImage: UIImage) {
        self.buttonImage = buttonImage
    }
    
}
