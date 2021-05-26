//
//  InsetLabel.swift
//  JoackyWriter
//
//  Created by Ilya Kulbakin on 02/03/2017.
//  Copyright © 2017 Jenex Software. All rights reserved.
//

import UIKit

class InsetLabel: UILabel {
    
    var offset: CGFloat = 1.0
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: UIEdgeInsets(top: 0,
                                                                    left: offset,
                                                                    bottom: 0,
                                                                    right: offset)))
    }
    
    override public var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize.init(width: size.width + offset * 2.0, height: size.height)
    }
}
