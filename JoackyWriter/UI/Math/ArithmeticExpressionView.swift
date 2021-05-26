//
//  ArithmeticExpressionView.swift
//  JoackyWriter
//
//  Created by Ilya Kulbakin on 14/04/2017.
//  Copyright © 2017 Jenex Software. All rights reserved.
//

import UIKit

class ArithmeticExpressionView: UIView {
    
    var mode: ArithmeticMode = .add
    var firstNumber: Int?
    var secondNumber: Int?
    var expression: String?
    
    @IBOutlet var firstNumberLabel: UILabel!
    @IBOutlet var secondNumberLabel: UILabel!
    @IBOutlet var signLabel: UILabel!
    @IBOutlet var answerLabel: UILabel!
    
    func getAnswer() -> Bool {
        signLabel.text = mode == .add ? "+" : "-"
        firstNumberLabel.text = firstNumber != nil ? "\(firstNumber!)" : "?"
        if let secondNumber = secondNumber {
            if let firstNumber = firstNumber {
                secondNumberLabel.text = mode == .substract && secondNumber > firstNumber ? "?" : "\(secondNumber)"
            }
            else {
                secondNumberLabel.text = "\(secondNumber)"
            }
        }
        else {
            secondNumberLabel.text = "?"
        }
        var answer: Int?
        if let secondNumber = secondNumber {
            if let firstNumber = firstNumber {
                if mode == .add {
                    answer = firstNumber + secondNumber
                }
                else {
                    answer = firstNumber - secondNumber
                }
            }
        }
        if let answer = answer, answer >= 0 {
            answerLabel.text = "\(answer)"
        }
        else {
            answerLabel.text = "?"
        }
        expression = "\(firstNumberLabel.text!)\(signLabel.text!)\(secondNumberLabel.text!)=\(answerLabel.text!)"
        if firstNumberLabel.text == "?" ||
            secondNumberLabel.text == "?" ||
            answerLabel.text == "?" {
            return false
        }
        return true
    }
}
