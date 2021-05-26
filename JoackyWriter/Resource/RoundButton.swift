//
//  RoundButton.swift
//  Calculator(ios)
//
//  Created by Johnny Perdomo on 5/5/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {

    @IBInspectable var cornerRadius: Bool = false {
        didSet {
            self.layer.cornerRadius = frame.height / 2
        }
    }
    
    
}
