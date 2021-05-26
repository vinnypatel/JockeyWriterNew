//
//  DrawingView.swift
//  JoackyWriter
//
//  Created by Ilya Kulbakin on 01/02/2017.
//  Copyright © 2017 Jenex Software. All rights reserved.
//

import UIKit

protocol DrawingViewDelegate {
    
    func drawingViewDidCompleteDraw(drawingView: DrawingView)
}

class DrawingView: UIView, CAAnimationDelegate {
    
    private var isCompleted = false
    private var shape: Shape?
    private var partIndex = 0
    private var areaIndex = 0
    private var letterPath: UIBezierPath?
    private var drawingAreas: [UIBezierPath] = []
    private var dotLayers: [CALayer] = []
    private var currentPath: UIBezierPath?
    private var paths = [UIBezierPath]()
    private var fingerTapPath: UIBezierPath?
    
    private var animationPointIndex = 0
    private var animationTimer: Timer?
    
    private var _letter: Character = Character.init("A")
    var letter: Character {
        set {
            _letter = newValue
            setupLetter()
        }
        get {
            return _letter
        }
    }
    
    var isActive: Bool = false {
        didSet {
            if isActive == true {
                setupPart()
            }
        }
    }
    
    var delegate: DrawingViewDelegate?
    
    static func width(for letter: Character) -> CGFloat {
        let font = UIFont.init(name: "RockoFLF", size: Utils.letterFontSize)!
        let width = String.init(letter).size(withFont: font).width
        let offset: CGFloat = Utils.isPad ? 60.0 : 30.0
        switch letter {
        case "j", "I":
            return width + (Utils.isPad ? 60 : 35) + offset
        default:
            return width + offset
        }
    }
    
    func setActive() {
        setupPart()
    }
    
    // MARK: - Animations
    
    func playAnimation() {
        animationPointIndex = 0
        animationTimer = Timer.scheduledTimer(timeInterval: 0.2,
                                              target: self,
                                              selector: #selector(self.animate),
                                              userInfo: nil,
                                              repeats: true)
        animationTimer?.fire()
    }
    
    @objc func animate() {
        
        if Account.writerOption != 1 {
//        if Account.isHippoTraceOn == false {
            return
        }
        if let part = shape?.parts[partIndex] {
            let layer = dotLayers[animationPointIndex]
            
            if layer.superlayer != nil {
                let point = part.trace[animationPointIndex]
                let image = UIImage(named: "HippoIcon")!
                layer.frame = CGRect.init(x: point.x - image.size.width / 2,
                                          y: point.y - image.size.height / 2,
                                          width: image.size.width,
                                          height: image.size.height)
                
                let animation = CABasicAnimation(keyPath: "bounds")
                animation.fromValue = CGRect.init(origin: point, size: CGSize.zero)
                animation.toValue = CGRect.init(x: 0,
                                                y: 0,
                                                width: image.size.width,
                                                height: image.size.height)
                layer.add(animation, forKey: "bounds")
            }
            
            animationPointIndex = animationPointIndex + 1
            if animationPointIndex == part.trace.count {
                animationTimer?.invalidate()
            }
        }
    }
    
    func disappearLayer(_ layer: CALayer, atPoint point: CGPoint) {
        let animation = CABasicAnimation(keyPath: "bounds")
        animation.fromValue = CGRect.init(x: 0,
                                          y: 0,
                                          width: layer.frame.size.width,
                                          height: layer.frame.size.height)
        animation.toValue = CGRect.init(origin: point, size: CGSize.zero)
        layer.frame = CGRect.init(origin: point, size: CGSize.zero)
        animation.setValue(layer, forKey: "animationLayer")
        animation.delegate = self
        layer.add(animation, forKey: "bounds")
    }

    // MARK: - Drawing
    
    private func setupLetter() {
        letterPath = UIBezierPath.pathForLetter(letter, isRegular: Utils.isPad, inView: self)
        paths = []
        currentPath = nil
        isCompleted = false
        shape = Shape(letter)
        partIndex = 0
        areaIndex = 0
        self.setNeedsDisplay()
    }
    
    private func setupPart() {
        animationTimer?.invalidate()
        drawingAreas = []
        dotLayers = []
        if let part = shape?.parts[partIndex] {
            for (index, point) in part.trace.enumerated() {
                drawingAreas.append(UIBezierPath.circle(center: point,
                                                        radius: Utils.isPad ? 207 : 115))
                let layer = CALayer()
                let image = UIImage(named: "HippoIcon")!
                layer.contents = image.cgImage
                layer.frame = CGRect.init(x: point.x - image.size.width / 2,
                                          y: point.y - image.size.height / 2,
                                          width: 0,
                                          height: 0)
                dotLayers.append(layer)
                self.layer.addSublayer(layer)
                
                if index == 0 {
                    layer.addGlowAnimtion(glowColor: UIColor.red)
                    layer.addBlinkAnimtion()
                }
            }
        }
        playAnimation()
    }
    
    private func resetPart() {
        if Account.writerOption != 1 {
//        if Account.isHippoTraceOn == false {
            return
        }
        animationTimer?.invalidate()
        for layer in dotLayers {
            layer.removeFromSuperlayer()
        }
        dotLayers = []
        if let part = shape?.parts[partIndex] {
            for (index, point) in part.trace.enumerated() {
                let layer = CALayer()
                let image = UIImage(named: "HippoIcon")!
                layer.contents = image.cgImage
                layer.frame = CGRect.init(x: point.x - image.size.width / 2,
                                          y: point.y - image.size.height / 2,
                                          width: image.size.width,
                                          height: image.size.height)
                dotLayers.append(layer)
                self.layer.addSublayer(layer)
                
                if index == 0 {
                    layer.addGlowAnimtion(glowColor: UIColor.red)
                    layer.addBlinkAnimtion()
                }
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        if letter == "=" || letter == "+" || letter == "-" {
            UIColor.darkBlue.setFill()
        }
        else {
            UIColor.white.setFill()
        }
        UIColor.darkBlue.setStroke()
        letterPath?.lineWidth = Utils.isPad ? 3.0 : 1.5
        letterPath?.fill()
        letterPath?.stroke()
        
        UIColor.darkBlue.set()
        for path in paths {
            path.stroke()
        }
        currentPath?.stroke()
        fingerTapPath?.stroke()
    }
    
    // MARK: - Auxillaries
    
    func checkIntersections(atPoint point: CGPoint) {
        guard shape != nil &&
            partIndex < shape!.parts.count &&
            areaIndex < shape!.parts[partIndex].trace.count else {
                return
        }
        
        let currentPoint = shape!.parts[partIndex].trace[areaIndex]
        var isCrossed = false
        if currentPath?.isEmpty == false {
            if areaIndex == 0 &&
                UIBezierPath.circle(center: currentPoint, radius: Utils.isPad ? 27 : 15).contains(point) {
                isCrossed = true
            }
            else if areaIndex != 0 {
                let previousPoint = shape!.parts[partIndex].trace[areaIndex - 1]
                let dx = currentPoint.x - previousPoint.x
                let dy = currentPoint.y - previousPoint.y
                let fault: CGFloat = Utils.isPad ? 16.0 : 9.0
                
                if (dx < 0 && point.x - fault < currentPoint.x ||
                    dx >= 0 && point.x + fault >= currentPoint.x) &&
                    (dy < 0 && point.y - fault < currentPoint.y ||
                        dy >= 0 && point.y + fault >= currentPoint.y) {
                    isCrossed = true
                }
            }
            
            if isCrossed == true {
                if Account.writerOption == 1 {
//                if Account.isHippoTraceOn == true {
                    Sounds.default.playTraceSound()
                }
                disappearLayer(dotLayers[areaIndex], atPoint: point)
                areaIndex = areaIndex + 1
            }
        }
        
        if areaIndex == shape!.parts[partIndex].trace.count {
            paths.append(currentPath!)
            partIndex += 1
            if partIndex == shape!.parts.count {
                Sounds.default.playPartCompletedSound()
                animationTimer?.invalidate()
                areaIndex += 1
                isCompleted = true
                delegate?.drawingViewDidCompleteDraw(drawingView: self)
            }
            else if partIndex < shape!.parts.count {
                Sounds.default.playPartCompletedSound()
                areaIndex = 0
                currentPath = UIBezierPath()
                setupPart()
                self.setNeedsDisplay()
            }
        }
    }
    
    func drawingEnabled(atPoint point: CGPoint) -> Bool {
        
        if (Account.writerOption != 1
//        if (Account.isHippoTraceOn == false
            || Utils.isPad == false
            || letterPath?.contains(point) == true),
            areaIndex < drawingAreas.count
        {
            let area = drawingAreas[areaIndex]
            if area.contains(point) && self.layer.contains(point) {
                return true
            }
        }
        return false
    }
    
    // MARK: - Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        areaIndex = 0
        if let touch = touches.first {
            if isCompleted == true || isActive == false ||
                drawingEnabled(atPoint: touch.location(in: self)) == false  {
                return 
            }
            
            currentPath = UIBezierPath()
            currentPath?.lineWidth = Utils.isPad == true ? 20.0 : 12.0
            currentPath?.lineCapStyle = .round
            currentPath?.lineJoinStyle = .round
            currentPath?.move(to: touch.location(in: self))
            var location = touch.location(in: self)
            location.y += 1.0
            currentPath?.addLine(to: location)
            fingerTapPath = UIBezierPath.circle(center: location, radius: 22.0)
            fingerTapPath?.lineWidth = 4.0
            self.setNeedsDisplay()
            
            checkIntersections(atPoint: location)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if isCompleted == true || isActive == false {
                return
            }
            
            if drawingEnabled(atPoint: touch.location(in: self)) == false {
                if areaIndex != 0 {
                    areaIndex = 0
                    fingerTapPath = nil
                    resetPart()
                }
                currentPath = UIBezierPath()
                self.setNeedsDisplay()
                return
            }
            
            if currentPath?.isEmpty == false {
                let location = touch.location(in: self)
                currentPath?.addLine(to: location)
                fingerTapPath = UIBezierPath.circle(center: location, radius: 22.0)
                fingerTapPath?.lineWidth = 4.0
                
                self.setNeedsDisplay()
            }
            
            checkIntersections(atPoint: touch.location(in: self))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let shape = self.shape {
            if partIndex < shape.parts.count &&
                areaIndex != shape.parts[partIndex].trace.count {
                if areaIndex != 0 {
                    areaIndex = 0
                    resetPart()
                }
                currentPath = UIBezierPath()
            }
            fingerTapPath = nil
            self.setNeedsDisplay()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let shape = self.shape {
            if partIndex < shape.parts.count &&
                areaIndex != shape.parts[partIndex].trace.count {
                areaIndex = 0
                currentPath = UIBezierPath()
                resetPart()
            }
            fingerTapPath = nil
            self.setNeedsDisplay()
        }
    }
    
    // MARK: - CAAnimationDeleate
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let layer = anim.value(forKey: "animationLayer") as? CALayer {
            layer.removeFromSuperlayer()
        }
    }
}
