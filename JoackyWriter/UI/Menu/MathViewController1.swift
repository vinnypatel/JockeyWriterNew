//
//  ViewController.swift
//  Calculator
//
//  Created by Mohammad Shayan on 4/3/20.
//  Copyright © 2020 Mohammad Shayan. All rights reserved.
//

import UIKit
import AVFoundation

class MathViewController1: UIViewController {
    
    @IBOutlet weak var currentTextField: UITextField!  // -- TopMost
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var topView: UIView!
    
    var strSpeechValue = ""
    var arrRange = [NSRange]()
    
    var timer: Timer!
    var count = 0
    var index = 0
    
    var calculator: Calculator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Sample Math"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        //        self.navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.tintColor = .white
        calculator = Calculator()
        reset()
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: Selector(("clearAll:")))
        deleteButton.addGestureRecognizer(longPressGesture)
    }
    
    @IBAction func numberOrDecimalButtonPressed(_ sender: UIButton) {
        
        if sender.tag == 10 {
            calculator.appendDecimal()
        } else {
            calculator.appendNumber(sender.tag)
        }
        updateCurrent()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .black
    }
    
    @IBAction func operationButtonPressed (_ sender: UIButton) {
        
        var operation: Operation
        
        let tag = sender.tag
        if tag == 1 {
            operation = .add
        } else if tag == 2 {
            operation = .subtract
        } else if tag == 3 {
            operation = .multiply
        } else if tag == 4 {
            operation = .divide
        } else {
            operation = .equals
            
        }
        calculator.appendOperation(operation)
        updateCurrent(operation)
    }
    
    @IBAction func deleteButtonPressed (_ sender: UIButton) {
        
        calculator.reset()
        updateCurrent()
    }
    
    @objc func clearAll(_ sender: UIGestureRecognizer) {
        if sender.state == .began {
            UIView.animate(withDuration: 0.7, delay: 0.0, options: [.autoreverse], animations: {
                self.topView.backgroundColor = UIColor.black
            }) { _ in
                self.topView.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.7803921569, blue: 0.3490196078, alpha: 1)
            }
            reset()
        }
        
    }
    
    func updateCurrent(_ operation: Operation = .noting) {
        
        // debugPrint("Function updateCurrent() \(calculator.current)")
        if operation == .equals {
            
            if let current = calculator.current.convertFromDoubleToCleanString() {
                currentTextField.text = current
            } else {
                currentTextField.text = calculator.current
            }
            
            var speechValue = resultLabel.attributedText?.string
            
            if !(resultLabel.attributedText?.string.contains("="))! {
                
                if let text = calculator.getTextForPlaceholder().convertFromDoubleToCleanString() {
                    
                    
                    let text = resultLabel.attributedText!.string + " = " + text
                    resultLabel.attributedText =  NSAttributedString(string: text)
                } else {
                    
                    let text = resultLabel.attributedText!.string + " = " + calculator.getTextForPlaceholder()
                    resultLabel.attributedText = NSAttributedString(string: text) //resultLabel.text! + " = " + calculator.getTextForPlaceholder()
                }
                
                speechValue = resultLabel.attributedText?.string
                
                strSpeechValue = speechValue!
                
                
                
                let char = speechValue?.stripped
                
                
                
                
                speechValue = speechValue?.replacingOccurrences(of: char!, with: " \(char ?? "") ")
                
                let arr = speechValue?.split(separator: " ")
                
                debugPrint("array \(arr!)")
                var tempStr = strSpeechValue
                arr?.forEach{ value in
                    
                    if let range = tempStr.range(of: value) {
                        tempStr = tempStr.replacingOccurrences(of: value, with: replaceCharacterwith(str: String(value), count: value.count), options: .caseInsensitive, range: range)
                        arrRange.append(NSRange(range, in: strSpeechValue))

                    }
                }
                
                debugPrint("Range \(arrRange)")
            
                
                if char == "+" {
                    speechValue = speechValue!.replacingOccurrences(of: "+", with: " plus ")
                }
               else  if char == "-" {
                    speechValue = speechValue!.replacingOccurrences(of: "-", with: " minus ")
                }
               else if char == "*" {
                    speechValue = speechValue!.replacingOccurrences(of: "*", with: " multiply ")
                }
               else if char == "%" {
                    speechValue = speechValue!.replacingOccurrences(of: "%", with: " divide ")
                }
                
                
                //
                //
                //                let char = speechValue?.stripped
                //
                //
                //                speechValue = speechValue?.replacingOccurrences(of: char!, with: " \(char ?? "") ")
                //
                //                let arr = speechValue?.split(separator: " ")
                //
                //                debugPrint("array \(arr)")
                //
                //
                //                arr?.forEach {
                //                    value in
                //                    doSpeechWithString(speechValue: String(value))
                //                    sleep(UInt32(0.5))
                //
                //                }
                //
                //
                
                //                let arr = Array(arrayLiteral: resultLabel.attributedText?.string).filter{["+", "-", "x", "/"].contains($0)}
                //
                //
                //                if !arr.isEmpty {
                //
                //                    if arr[0] == "+" {
                //                        speechValue = speechValue!.replacingOccurrences(of: "+", with: "plus")
                //                    }
                //                    if arr[0] == "-" {
                //                        speechValue = speechValue!.replacingOccurrences(of: "-", with: "minus")
                //                    }
                //                    if arr[0] == "x" {
                //                        speechValue = speechValue!.replacingOccurrences(of: "x", with: "multiply by")
                //                    }
                //                    if arr[0] == "/" {
                //                        speechValue = speechValue!.replacingOccurrences(of: "/", with: "divided by")
                //                    }
                //                }
                //                print(arr)
                
                //  return
                //
            } else {
                
                speechValue = resultLabel.attributedText?.string
                
                strSpeechValue = speechValue!
                
                
                
                let char = speechValue?.stripped
                
                
                
                
                speechValue = speechValue?.replacingOccurrences(of: char!, with: " \(char ?? "") ")
                
                let arr = speechValue?.split(separator: " ")
                
                debugPrint("array \(arr!)")
                var tempStr = strSpeechValue
                arr?.forEach{ value in
                    
                    if let range = tempStr.range(of: value) {
                        tempStr = tempStr.replacingOccurrences(of: value, with: replaceCharacterwith(str: String(value), count: value.count), options: .caseInsensitive, range: range)
                        arrRange.append(NSRange(range, in: strSpeechValue))

                    }
                }
                
                debugPrint("Range \(arrRange)")
            
                
                if char == "+" {
                    speechValue = speechValue!.replacingOccurrences(of: "+", with: " plus ")
                }
               else  if char == "-" {
                    speechValue = speechValue!.replacingOccurrences(of: "-", with: " minus ")
                }
               else if char == "*" {
                    speechValue = speechValue!.replacingOccurrences(of: "*", with: " multiply ")
                }
               else if char == "%" {
                    speechValue = speechValue!.replacingOccurrences(of: "%", with: " divide ")
                }
            }
            
            doSpeechWithString(speechValue: speechValue!)
            
            
            
        } else {
            //                   if let current = calculator.current.convertFromDoubleToCleanString() {
            //
            //                       currentTextField.text = current
            //                   } else {
            currentTextField.text = calculator.current
            //                   }
            //                   if let text = calculator.getTextForPlaceholder().convertFromDoubleToCleanString() {
            //                        debugPrint(" - current")
            //                       resultLabel.attributedText = NSAttributedString(string: text)
            //                   } else {
            resultLabel.attributedText = NSAttributedString(string: calculator.getTextForPlaceholder())
            //  }
        }
        
    }
    
    func reset() {
        calculator.reset()
        resultLabel.attributedText = NSAttributedString(string: "")
        updateCurrent()
    }
    
    func doSpeechWithString(speechValue: String) {
        
        
        let utterance = AVSpeechUtterance(string: speechValue)
        
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = 0.4
        APPDELEGATE.window?.isUserInteractionEnabled = false
        // AppDelegate.speechSynthesizer.delegate = APPDELEGATE
        AppDelegate.speechSynthesizer.delegate = self
        AppDelegate.speechSynthesizer.speak(utterance)
    }
    
}

extension MathViewController1 : AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        
        let str = utterance.speechString
        
        debugPrint(str.substring(characterRange))
        
       // if let _ = Int(str.substring(characterRange)) {
            
            
            let mutableAttributedString = NSMutableAttributedString(string: strSpeechValue)
            mutableAttributedString.addAttribute(.foregroundColor, value: UIColor.skyBlue, range: arrRange[index])
            resultLabel.attributedText = mutableAttributedString
            
       // }
        index += 1
       // let mutableAttributedString = NSMutableAttributedString(string: utterance.speechString)
        
//        print(characterRange)
//        print(utterance.speechString)
       
        AppDelegate.isFinish = true
        APPDELEGATE.window?.isUserInteractionEnabled = true
        
    }
    
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        
        print("done")
        index = 0
        
        arrRange = []
        
    }
}

extension MathViewController1: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            //    myvalidator(text: updatedText)
            
        }
        
        return true
    }
    
    func replaceCharacterwith(str: String, count: Int) -> String {
        
        var str = ""
        for _ in 0..<count {
            str = str + "#"
        }
        
        return str
    }
}




extension String {
    var stripped: String {
        let okayChars = Set("+-*%")
        return self.filter {okayChars.contains($0) }
    }
   func substring(_ range: NSRange) -> String {
            let start = self.index(self.startIndex, offsetBy: range.lowerBound)
            let end = self.index(self.startIndex, offsetBy: range.upperBound)
            let subString = self[start..<end]
            return String(subString)
        }
}

