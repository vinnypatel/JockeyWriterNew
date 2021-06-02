//
//  Calculator.swift
//  Calculator
//
//  Created by Mohammad Shayan on 4/3/20.
//  Copyright © 2020 Mohammad Shayan. All rights reserved.
//

import Foundation
import AVFoundation

enum WorkingOn {
    case leftSide
    case rightSide
}

enum Operation: String {
    case add = "+"
    case subtract = "-"
    case multiply = "*"
    case divide = "%"
    case equals = "="
    case noting = ""
}

class Calculator {
    
    var current = ""
    var leftSide: Double?
    var rightSide: Double?
    var operation: Operation?
    var result: Double?
    var newNumber: Double?
    
    var workingOn = WorkingOn.leftSide
    
    var canTakeDecimal: Bool = true
    var canTakeMinus: Bool = true
    
    var newNumberWillClear: Bool = false
    
    //  var timerLogic: TimerLogic!
    
    var timer: Timer!
    var count = 0
    
    //    class TimerLogic{
    //            var structRef: Calculator!
    //        var timer: Timer!
    //           var count = 0
    //          //  var timer: Timer!
    //
    //            init(_ structRef: Calculator){
    //                self.structRef = structRef;
    //
    //                debugPrint(" count1 ------ \(self.count)")
    //                if count == 0 && timer == nil &&  self.structRef != nil{
    //
    //                    self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
    //
    //
    //                                      self.count += 1
    //
    //                        debugPrint(" count ------ \(self.count)")
    //                                      if self.count == 2 {
    //
    //                                          self.timer.invalidate()
    //                                          self.timer = nil
    //
    //
    //
    //                                         // self.structRef = nil
    //                                                                                   debugPrint("Hello")
    //
    //                                          guard let newNumber = Double(self.structRef.current) else {
    //                                                      return
    //                                                  }
    //
    //                                          let isInt = floor(newNumber) == newNumber
    //                                                     var utterance = AVSpeechUtterance()
    //                                                     if isInt {
    //
    //                                                         utterance = AVSpeechUtterance(string: "\(Int(newNumber))")
    //
    //                                                     } else {
    //
    //                                                         utterance = AVSpeechUtterance(string: "\(newNumber)")
    //                                                     }
    //
    //                                                     utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
    //                                                     utterance.rate = 0.5
    //
    //                                                     let synthesizer = AVSpeechSynthesizer()
    //                                                     synthesizer.speak(utterance)
    //
    //
    //                                        self.structRef = nil
    //                                        self.count = 0
    //                                                                               }
    //                                                                   }
    //
    //                }
    //
    //
    ////                self.timer = Timer.scheduledTimer(
    ////                    timeInterval: 2.0,
    ////                    target: self,
    ////                    selector: #selector(timerTicked),
    ////                    userInfo: nil,
    ////                    repeats: true)
    //            }
    //        }
    //
    func appendNumber(_ number: Int) {
        if newNumberWillClear {
            self.current = String(number)
        } else {
            self.current += String(number)
        }
        newNumberWillClear = false
        updateNumberCurrentlyBeingWorkedOn()
    }
    
    func appendDecimal() {
        
        guard canTakeDecimal else {
            return
        }
        
        if newNumberWillClear {
            reset()
        }
        self.current += "."
        canTakeDecimal = false
        
    }
    
    func appendOperation(_ operation: Operation) {
        
       // debugPrint("\(operation)")
        if operation != .equals {
            
            var speechValue = ""
            
            switch operation {
            case .add:
                speechValue = "plus"
                break;
            case .multiply:
                speechValue = "multiply"
                break;
            case .divide:
                speechValue = "divide by"
                break;
            case .subtract:
                speechValue = "minus"
                break;
            default:
                break;
            }
            
            let utterance = AVSpeechUtterance(string: speechValue)
            
            
            utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
            utterance.rate = 0.4
            
//            let synthesizer = AVSpeechSynthesizer()
           
            
            AppDelegate.speechSynthesizer.speak(utterance)
        }
        if operation == .subtract && !canTakeMinus {
            return
        }
        
        if operation == .equals {
            doOperation()
            if let result = self.result {
                reset()
                self.current = "\(result)"
                newNumberWillClear = true
                self.leftSide = result
            }
            
        } else {
            
            if self.current != "" {
                
                workOnNextNumber()
                self.current = ""
                self.operation = operation
                
            } else {
                if operation == .subtract {
                    self.current += "-"
                    canTakeMinus = false
                    newNumberWillClear = false
                    updateNumberCurrentlyBeingWorkedOn()
                } else {
                    self.current = ""
                    self.operation = operation
                }
            }
        }
    }
    
    func delete() {
        if newNumberWillClear {
            reset()
        } else {
            let last = self.current.popLast()
            if last == "-" {
                canTakeMinus = true
            } else if last == "." {
                canTakeDecimal = true
            }
            if self.current == "" || self.current == "-" {
                resetWorkingNumber()
            }
            updateNumberCurrentlyBeingWorkedOn()
        }
    }
    
    func testFunc(){
        
    }
    
    func updateNumberCurrentlyBeingWorkedOn() {
        
//        let lessPrecisePI = Float(self.current)
//        
//        debugPrint(lessPrecisePI)
//        
        guard let newNumber = Double(self.current) else {
            return
        }
        
       // debugPrint("\(newNumber)")
        self.newNumber = newNumber
        
        if count == 0 && timer == nil && AppDelegate.isFinish {
            
            timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
                
                self.count += 1
                
                if self.count == 2 {
                   
                    APPDELEGATE.window?.isUserInteractionEnabled = false
                 //   DispatchQueue.global().sync {
                        
                        self.timer.invalidate()
                        self.timer = nil
                        self.count = 0
                        let isInt = floor(newNumber) == newNumber
                        var utterance = AVSpeechUtterance()
                        
                       // debugPrint(self.newNumber)
                        if isInt {
                            
                            utterance = AVSpeechUtterance(string: "\(Int(self.newNumber!))")
                            
                        } else {
                            
                            utterance = AVSpeechUtterance(string: "\(self.newNumber!)")
                        }
                        
                        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                        utterance.rate = 0.5
                        AppDelegate.isFinish = false
                        AppDelegate.speechSynthesizer = AVSpeechSynthesizer()
                        AppDelegate.speechSynthesizer.speak(utterance)
                        AppDelegate.speechSynthesizer.delegate = APPDELEGATE
                       // debugPrint("Hello \(newNumber)")
                        
                  //  }
                    
                }
            }
        }
        
        //  DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        //            let isInt = floor(newNumber) == newNumber
        //            var utterance = AVSpeechUtterance()
        //            if isInt {
        //
        //                utterance = AVSpeechUtterance(string: "\(Int(newNumber))")
        //
        //            } else {
        //
        //                utterance = AVSpeechUtterance(string: "\(newNumber)")
        //            }
        //
        //            utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        //            utterance.rate = 0.5
        //
        //            let synthesizer = AVSpeechSynthesizer()
        //            synthesizer.speak(utterance)
        
        //   }
        
        if self.workingOn == .leftSide {
            self.leftSide = newNumber
        } else {
            self.rightSide = newNumber
        }
    }
    
    func workOnNextNumber() {
        if self.workingOn == .leftSide {
            self.workingOn = .rightSide
        } else {
            doOperation()
            if let result = self.result {
                self.leftSide = result
            }
            self.workingOn = .rightSide
            self.rightSide = nil
        }
        
        self.canTakeMinus = true
        self.canTakeDecimal = true
        self.newNumberWillClear = false
    }
    
    func resetWorkingNumber() {
        if self.workingOn == .leftSide {
            self.leftSide = nil
        } else {
            self.rightSide = nil
        }
    }
    
    func doOperation() {
        guard let leftSide = self.leftSide, let rightSide = self.rightSide, let operation = self.operation else {
            return
        }
        
        switch operation {
        case .add:
            self.result = leftSide + rightSide
            break
        case .subtract:
            self.result = leftSide - rightSide
            break
        case .multiply:
            self.result = leftSide * rightSide
            break
        case .divide:
            self.result = leftSide / rightSide
            break
        default:
            return
        }
    }
    
    func reset() {
        self.leftSide = nil
        self.rightSide = nil
        self.operation = nil
        self.result = nil
        self.current = ""
        self.workingOn = .leftSide
        self.canTakeMinus = true
        self.canTakeDecimal = true
        self.newNumberWillClear = false
    }
    
    func getTextForPlaceholder() -> String {
        var string = ""
        
        if let leftSide = self.leftSide {
            let isInt = floor(leftSide) == leftSide
            if  isInt {
                let intValue = Int(leftSide)
                string += String(intValue)
                
            } else {
                
                string += String(leftSide)
            }
            
        }
        if let operation = self.operation {
            string += operation.rawValue
        }
        if let rightSide = self.rightSide {
            let isInt = floor(rightSide) == rightSide
            if  isInt {
                let intValue = Int(rightSide)
                string += String(intValue)
                
            } else {
                
                string += String(rightSide)
            }
            // string += String(rightSide)
        }
        
        return string
    }
    
}
