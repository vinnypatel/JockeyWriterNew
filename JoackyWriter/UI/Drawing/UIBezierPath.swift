//
//  UIBezierPath.swift
//  JoackyWriter
//
//  Created by Ilya Kulbakin on 01/02/2017.
//  Copyright © 2017 Jenex Software. All rights reserved.
//

import UIKit

extension UIBezierPath {
    
    static func pathForLetter(_ letter: Character, isRegular: Bool, inView view: UIView) -> UIBezierPath {
        var path = UIBezierPath()
        var font = CTFontCreateWithName(("RockoFLF" as CFString?)!, Utils.letterFontSize, nil)
        if letter == "a" {
            font = CTFontCreateWithName(("PrimerPrint-Bold" as CFString?)!, Utils.letterFontSize * 1.4, nil)
        }
        else if letter == "I" {
            font = CTFontCreateWithName(("PrimerPrint-Bold" as CFString?)!, Utils.letterFontSize * 1.16, nil)
        }
        var unichars = [UniChar]("\(letter)".utf16)
        var glyphs = [CGGlyph](repeating: 0, count: unichars.count)
        
        let gotGlyphs = CTFontGetGlyphsForCharacters(font, &unichars, &glyphs, unichars.count)
        if gotGlyphs {
            let cgpath = CTFontCreatePathForGlyph(font, glyphs[0], nil)
            path = UIBezierPath(cgPath: cgpath!)
        }
        
        let rotate = CGAffineTransform.init(scaleX: 1, y: -1)
        
        var xOffset: CGFloat = -4
        var yOffset: CGFloat = -30
        
        switch letter {
        case "C", "G", "S", "U":
            yOffset -= 3
        case "I":
            xOffset -= 18
        case "J":
            yOffset -= 5
        case "O":
            yOffset -= 2
        case "Q":
            yOffset -= 13
        case "a":
            yOffset += 25
            xOffset -= 15
        case "c", "e", "m", "n", "o", "r", "s", "u", "v", "w", "x", "z":
            yOffset += 30
        case "j":
            yOffset -= 32
            xOffset += 14
        case "l":
            xOffset -= 10
        case "t", "1":
            yOffset += 10
        case "0":
            yOffset += 6
        case "2", "4":
            yOffset += 8
        case "5":
            yOffset += 4
        case "-":
            yOffset += 110
        case "+":
            yOffset += 70
        case "=":
            yOffset += 95
        default:
            break
        }
        if isRegular == true {
            xOffset = xOffset * 1.8
            yOffset = yOffset * 1.8
        }
        
        let translate = CGAffineTransform.init(translationX: xOffset,
                                               y: path.bounds.size.height + yOffset)
        path.apply(rotate)
        path.apply(translate)
        
        let pathRect = path.bounds
        let xOrigin = (view.bounds.size.width - pathRect.size.width) / 2
        let yOrigin = (view.bounds.size.height - pathRect.size.height) / 2
        
        let positioning = CGAffineTransform.init(translationX: xOrigin, y: yOrigin)
        path.apply(positioning)
        
        return path
    }
    
    static func circle(center: CGPoint, radius: CGFloat) -> UIBezierPath {
        return UIBezierPath.init(arcCenter: center,
                                 radius: radius,
                                 startAngle: 0,
                                 endAngle: CGFloat(2.0) * .pi,
                                 clockwise: true)
    }
    
    static func square(center: CGPoint, sideSize: CGFloat) -> UIBezierPath {
        let startPoint = CGPoint.init(x: center.x - sideSize / 2, y: center.y - sideSize / 2)
        let square = UIBezierPath()
        square.move(to: startPoint)
        square.addLine(to: CGPoint.init(x: startPoint.x + sideSize, y: startPoint.y))
        square.addLine(to: CGPoint.init(x: startPoint.x + sideSize, y: startPoint.y + sideSize))
        square.addLine(to: CGPoint.init(x: startPoint.x, y: startPoint.y + sideSize))
        square.addLine(to: startPoint)
        square.close()
        return square
    }
}
