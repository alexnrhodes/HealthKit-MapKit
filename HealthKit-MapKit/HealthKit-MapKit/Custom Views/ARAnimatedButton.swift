//
//  ARAnimatedButton.swift
//  HealthKit-MapKit
//
//  Created by Alex Rhodes on 5/11/20.
//  Copyright © 2020 Alex Rhodes. All rights reserved.
//

import Foundation
import UIKit


class ARAnimatedButton: UIButton {
    
    fileprivate var wAnchor: NSLayoutConstraint?
    fileprivate var hAnchor: NSLayoutConstraint?
    
    fileprivate var widthConstant: CGFloat?
    fileprivate var heightConstant: CGFloat?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        phaseTwo(title: "Button")
    }
    
    init(title: String, width: CGFloat) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        wAnchor =  widthAnchor.constraint(equalToConstant: width)
        guard let wAnchor = wAnchor else {return}
        wAnchor.isActive = true
        widthConstant = wAnchor.constant
        
        hAnchor = heightAnchor.constraint(equalToConstant: 50)
        guard let hAnchor = hAnchor else {return}
        hAnchor.isActive = true
        heightConstant = hAnchor.constant
        
        phaseTwo(title: title)
    }
    
    fileprivate func phaseTwo(title: String) {
         guard let widthConstant = widthConstant, let heightConstant = heightConstant else { return }
        layer.cornerRadius = 12
        backgroundColor = .black
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: widthConstant/30, height: heightConstant/5)
        layer.shadowColor = UIColor.black.cgColor
        setTitle("Button", for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        addTarget(self, action: #selector(down), for: .touchDown)
        addTarget(self, action: #selector(up), for: .touchUpInside)
        
    }
    
    @objc fileprivate func down() {
        
        wAnchor?.isActive = false
        hAnchor?.isActive = false
        
        guard let widthConstant = widthConstant, let heightConstant = heightConstant else { return }
        wAnchor?.constant = widthConstant - widthConstant/15
        hAnchor?.constant  = heightConstant - heightConstant/15
        
        wAnchor?.isActive = true
        hAnchor?.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        })
    }
    
    @objc fileprivate func up() {
        
        wAnchor?.isActive = false
        hAnchor?.isActive = false
        
        guard let widthConstant = widthConstant, let heightConstant = heightConstant else { return }

        wAnchor?.constant = widthConstant
        hAnchor?.constant  = heightConstant
        
        wAnchor?.isActive = true
        hAnchor?.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.superview?.layoutIfNeeded()
//            self.transform = .identity
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
}
