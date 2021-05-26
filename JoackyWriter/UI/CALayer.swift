//
//  CALayer.swift
//  JoackyWriter
//
//  Created by Ilya Kulbakin on 15/04/2017.
//  Copyright © 2017 Jenex Software. All rights reserved.
//

import UIKit

extension CALayer {
    
    func addGlowAnimtion(glowColor: UIColor) {
        self.shadowRadius = Utils.isPad ? 5.0 : 2.5
        self.shadowOffset = CGSize.init(width: 0.0, height: 0.0)
        self.shadowOpacity = 1.0
        self.shadowColor = glowColor.cgColor
        
        let glowAnimation = CABasicAnimation(keyPath: "shadowOpacity")
        glowAnimation.fromValue = 1.0
        glowAnimation.toValue = 0.5
        glowAnimation.duration = 0.5
        glowAnimation.autoreverses = true
        glowAnimation.repeatCount = Float.greatestFiniteMagnitude
        
        self.add(glowAnimation, forKey: "shadowOpacity")
    }
    
    func addBlinkAnimtion() {
        let glowAnimation = CABasicAnimation(keyPath: "opacity")
        glowAnimation.fromValue = 1.0
        glowAnimation.toValue = 0.5
        glowAnimation.duration = 0.5
        glowAnimation.autoreverses = true
        glowAnimation.repeatCount = Float.greatestFiniteMagnitude
        
        self.add(glowAnimation, forKey: "shadowOpacity")
    }
}
