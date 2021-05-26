//
//  CirclesView.swift
//  JoackyWriter
//
//  Created by Ilya Kulbakin on 18/04/2017.
//  Copyright © 2017 Jenex Software. All rights reserved.
//

import UIKit

class CirclesView: UIView {
    
    let circlesCount: Int
    
    init(frame: CGRect, circlesCount: Int) {
        self.circlesCount = circlesCount
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        circlesCount = 0
        return nil
    }
    
    override func draw(_ rect: CGRect) {
        var centers = [CGPoint]()
        switch circlesCount {
        case 1: centers.append(CGPoint.init(x: frame.size.width / 1.5, y: frame.size.height / 2.0))
        case 2:
            centers.append(CGPoint.init(x: frame.size.width / 2.0 - 0.12 * frame.size.width, y: frame.size.height / 2.0))
            centers.append(CGPoint.init(x: frame.size.width / 2.0 + 0.12 * frame.size.width, y: frame.size.height / 2.0))
        case 3:
            centers.append(CGPoint.init(x: frame.size.width / 2.0 + frame.size.width / 4.0 + 0.03 * frame.size.width, y: frame.size.height / 2.0))
            centers.append(CGPoint.init(x: frame.size.width / 2.0 + 0.03 * frame.size.width, y: frame.size.height / 2.0))
            centers.append(CGPoint.init(x: frame.size.width / 4.0 + 0.03 * frame.size.width, y: frame.size.height / 2.0))
        case 4:
            centers.append(CGPoint.init(x: 0.2 * frame.size.width, y: frame.size.height / 2.0))
            centers.append(CGPoint.init(x: 0.4 * frame.size.width, y: frame.size.height / 2.0))
            centers.append(CGPoint.init(x: 0.6 * frame.size.width, y: frame.size.height / 2.0))
            centers.append(CGPoint.init(x: 0.8 * frame.size.width, y: frame.size.height / 2.0))
        case 5:
            centers.append(CGPoint.init(x: frame.size.width / 2.0 + frame.size.width / 4.0, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: frame.size.width / 2.0, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: frame.size.width / 4.0, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: frame.size.width / 2.0 + 0.12 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: frame.size.width / 2.0 - 0.12 * frame.size.width, y: frame.size.height / 1.5))
        case 6:
            centers.append(CGPoint.init(x: frame.size.width / 2.0 + frame.size.width / 4.0 + 0.03 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: frame.size.width / 2.0 + 0.03 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: frame.size.width / 4.0 + 0.03 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: frame.size.width / 2.0 + frame.size.width / 4.0 + 0.03 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: frame.size.width / 2.0 + 0.03 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: frame.size.width / 4.0 + 0.03 * frame.size.width, y: frame.size.height / 1.5))
        case 7:
            centers.append(CGPoint.init(x: 0.2 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.4 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.6 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.8 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: frame.size.width / 2.0, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: frame.size.width / 2.0 + 0.2 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: frame.size.width / 2.0 - 0.2 * frame.size.width, y: frame.size.height / 1.5))
        case 8:
            centers.append(CGPoint.init(x: 0.2 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.4 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.6 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.8 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.2 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.4 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.6 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.8 * frame.size.width, y: frame.size.height / 1.5))
        case 9:
            centers.append(CGPoint.init(x: 0.2 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.35 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.65 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.8 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 2 * (0.11 * frame.size.width), y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - (0.075 * frame.size.width), y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 2 * (0.11 * frame.size.width), y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + (0.075 * frame.size.width), y: frame.size.height / 1.5))
        case 10:
            centers.append(CGPoint.init(x: 0.2 * frame.size.width + 0.03 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.35 * frame.size.width + 0.03 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.03 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.65 * frame.size.width + 0.03 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.8 * frame.size.width + 0.03 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.2 * frame.size.width + 0.03 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.35 * frame.size.width + 0.03 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.03 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.65 * frame.size.width + 0.03 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.8 * frame.size.width + 0.03 * frame.size.width, y: frame.size.height / 1.5))
        case 11:
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.05 * frame.size.width + 0.08 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.15 * frame.size.width + 0.08 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.25 * frame.size.width + 0.08 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.05 * frame.size.width + 0.08 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.15 * frame.size.width + 0.08 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.25 * frame.size.width + 0.08 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.08 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.1 * frame.size.width + 0.08 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.2 * frame.size.width + 0.08 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.1 * frame.size.width + 0.08 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.2 * frame.size.width + 0.08 * frame.size.width, y: frame.size.height / 1.5))
        case 12:
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.35 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.2 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.05 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.1 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.25 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.4 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.35 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.2 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.05 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.1 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.25 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.4 * frame.size.width, y: frame.size.height / 1.5))
        case 13:
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.25 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.15 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.05 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.05 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.15 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.25 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.35 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.2 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.1 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.0 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.1 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.2 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.3 * frame.size.width, y: frame.size.height / 1.5))
        case 14:
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.3 * frame.size.width + 0.025 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.2 * frame.size.width + 0.025 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.1 * frame.size.width + 0.025 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.0 * frame.size.width + 0.025 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.1 * frame.size.width + 0.025 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.2 * frame.size.width + 0.025 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.3 * frame.size.width + 0.025 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.3 * frame.size.width + 0.025 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.2 * frame.size.width + 0.025 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.1 * frame.size.width + 0.025 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.0 * frame.size.width + 0.025 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.1 * frame.size.width + 0.025 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.2 * frame.size.width + 0.025 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.3 * frame.size.width + 0.025 * frame.size.width, y: frame.size.height / 1.5))
        case 15:
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.3 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.2 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.1 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.0 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.1 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.2 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.3 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.4 * frame.size.width, y: frame.size.height / 4.0))
            
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.25 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.15 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.05 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.05 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.15 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.25 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.35 * frame.size.width, y: frame.size.height / 1.5))
        case 16:
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.3 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.2 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.1 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.0 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.1 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.2 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.3 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.4 * frame.size.width, y: frame.size.height / 4.0))
            
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.3 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.2 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.1 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.0 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.1 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.2 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.3 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.4 * frame.size.width, y: frame.size.height / 1.5))
        case 17:
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.35 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.26 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.17 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.08 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.01 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.1 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.19 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.28 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.37 * frame.size.width, y: frame.size.height / 4.0))
            
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.31 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.22 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.13 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.04 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.05 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.14 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.23 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.32 * frame.size.width, y: frame.size.height / 1.5))
        case 18:
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.3 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.21 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.12 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.03 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.06 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.15 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.24 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.33 * frame.size.width, y: frame.size.height / 4.0))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.42 * frame.size.width, y: frame.size.height / 4.0))
            
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.3 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.21 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.12 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width - 0.03 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.06 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.15 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.24 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.33 * frame.size.width, y: frame.size.height / 1.5))
            centers.append(CGPoint.init(x: 0.5 * frame.size.width + 0.42 * frame.size.width, y: frame.size.height / 1.5))
        default: break
        }
        for center in centers {
            let circlePath = UIBezierPath(arcCenter: center,
                                          radius: Utils.isPad ? 15.0 : 10.0,
                                          startAngle: CGFloat(0),
                                          endAngle: CGFloat(Double.pi * 2),
                                          clockwise: true)
            UIColor.darkBlue.setFill()
            circlePath.fill()
        }
    }
}
