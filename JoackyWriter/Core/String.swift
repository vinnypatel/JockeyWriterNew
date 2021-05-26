//
//  String.swift
//  JoackyWriter
//
//  Created by Ilya Kulbakin on 01/03/2017.
//  Copyright © 2017 Jenex Software. All rights reserved.
//

import UIKit

extension String {
    
    func size(withFont font: UIFont) -> CGSize {
        let constraintRect = CGSize(width: 1000, height: 1000)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.size
    }
    
    func height(withFixedWidth fixedWidth:CGFloat, font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: fixedWidth, height: .greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    func width(withFixedHeight fixedHeight:CGFloat, font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: fixedHeight)
        
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.width)
    }
}

extension NSAttributedString {
    
    func height(withFixedWidth fixedWidth:CGFloat) -> CGFloat {
        
        let constraintRect = CGSize(width: fixedWidth, height: .greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            context: nil)
        return ceil(boundingBox.height)
    }
    
    func width(withFixedHeight fixedHeight:CGFloat) -> CGFloat {
        
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: fixedHeight)
        
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            context: nil)
        return ceil(boundingBox.width)
    }
}

extension String {
    var length: Int {
        return self.count
    }
}
public protocol Unwrappable {
    func unwrap() -> Any?
}

extension Optional: Unwrappable {
    public func unwrap() -> Any? {
        switch self {
        case .none:
            return nil
        case .some(let unwrappable as Unwrappable):
            return unwrappable.unwrap()
        case .some (let some):
            return some
        }
    }
}

public extension String {
    init(stringInterpolationSegment expr: Unwrappable) {
        self = String(describing: expr.unwrap() ?? "")
    }
}
