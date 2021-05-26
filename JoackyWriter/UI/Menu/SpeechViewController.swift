//
//  ViewController.swift
//  TextToSpeech
//
//  Created by Vinay Patel on 01/01/21.
//

import UIKit
import AVFoundation

class SpeechViewController: UIViewController, AVSpeechSynthesizerDelegate {
    
   // @IBOutlet weak var tfTextToSpeech : UITextField!

    @IBOutlet weak var txVw: UITextView!
   
    @IBOutlet weak var txVwHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnClear: UIButton!
    
    // set this up somewhere
    let minTextViewHeight: CGFloat = 72
    var maxTextViewHeight: CGFloat = 0.0
    
   // let speechSynthesizer = AVSpeechSynthesizer()
    var speechUtterance: AVSpeechUtterance!
   // var range: NSRange?
    
    var fontSize: CGFloat?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let kIsiPad = UIDevice.current.userInterfaceIdiom == .pad
        
        
        self.title = "Text To Speech"
        maxTextViewHeight = self.view.frame.height * (kIsiPad ? 0.3 : 0.4)
        fontSize = kIsiPad ? 80 : 40
        txVw.font = UIFont(name: "Avenir Next Condensed Bold", size: fontSize!)
        btnClear.titleLabel?.font = UIFont(name: "Avenir Next Condensed Bold", size: fontSize! - 20)
        txVw.becomeFirstResponder()

    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
    
      //  print("Length of the string. \(txVw.text.length)")
        print("\(NSRange(location: 0, length: txVw.text.length))")
        
        
//
//        if txVw.text.contains("..") {
//            return
      //  }
        
        
        
//        guard let rangeofString = (strNumber).range(of: txVw.text) as NSRange else {
//            return
//        }
        
        
        
        let mutableAttributedString = NSMutableAttributedString(string: utterance.speechString)
        
      //  print("mutableString ######\(mutableAttributedString)")
      //  print("Textview Text ######\(txVw.text!)")
       // let range1 = txVw.text.range(of: txVw.text)
        let strNumber: NSString = txVw.text as NSString // you must set your
        
        
        if mutableAttributedString.length == self.txVw.attributedText.length {
            let range11 = (strNumber).range(of: txVw.text)
            mutableAttributedString.addAttribute(.font, value: UIFont(name: "Avenir Next Condensed Bold", size: fontSize!) as Any, range: range11)
            mutableAttributedString.addAttributes([.foregroundColor: UIColor.skyBlue, .font: UIFont(name: "Avenir Next Condensed Bold", size: fontSize!) as Any], range: characterRange)
            
           // print("Mutable String length = \(mutableAttributedString.length)")
    //            //mutableAttributedString.addAttribute(.foregroundColor, value: UIColor.skyBlue, range: characterRange)
            txVw.attributedText = mutableAttributedString
           // tfTextToSpeech.attributedText = mutableAttributedString
        }
      //  mutableAttributedString.addAttributes([.foregroundColor: UIColor.skyBlue], range: characterRange)
        
       // txVw.text.trimmedTrailingSpaces()
        
     
        
       
        
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {

        print("Finish")
       
    }

    func textToSpeech(str: String, fullString: String) {
        
        if !fullString.isEmpty {
            
            AppDelegate.speechSynthesizer.delegate = self

            speechUtterance = AVSpeechUtterance(string: fullString)
            //Line 3. Specify the speech utterance rate. 1 = speaking extremely the higher the values the slower speech patterns. The default rate, AVSpeechUtteranceDefaultSpeechRate is 0.5
            speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 3.0
            // Line 4. Specify the voice. It is explicitly set to English here, but it will use the device default if not specified.
            speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            // Line 5. Pass in the urrerance to the synthesizer to actually speak.
            AppDelegate.speechSynthesizer.speak(speechUtterance)
            
            return
          
        }
        
        speechUtterance = AVSpeechUtterance(string: str)
        //Line 3. Specify the speech utterance rate. 1 = speaking extremely the higher the values the slower speech patterns. The default rate, AVSpeechUtteranceDefaultSpeechRate is 0.5
        speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.0
        // Line 4. Specify the voice. It is explicitly set to English here, but it will use the device default if not specified.
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        // Line 5. Pass in the urrerance to the synthesizer to actually speak.
        AppDelegate.speechSynthesizer.speak(speechUtterance)
        
       
 
    }
//
//    func delay(_ delay:Double, closure:@escaping ()->()) {
//        DispatchQueue.main.asyncAfter(
//            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
//    }
//
    func changeTextColor(str: String, rangeString: String) {
        
      //  fatalError()
      //  print("rangeString #####  \(rangeString)")
        let indices = str.indices(of: rangeString)
      //  print("[Int] : \(indices)")
        if let _ = str.range(of: rangeString) {
         //  print(range)
            let rangeOfString = NSRange(location: indices.last!, length: rangeString.length)
          //  print("rangeOfString - \(rangeOfString)")
          //  let strNumber: NSString = str as NSString // you must set your
           // let range1 = (strNumber).range(of: rangeString)
            let attribute = NSMutableAttributedString.init(string: str)
            attribute.addAttributes([NSAttributedString.Key.font: UIFont(name: "Avenir Next Condensed Bold", size: fontSize!) as Any, NSAttributedString.Key.foregroundColor: UIColor.skyBlue], range: rangeOfString)
            
            attribute.addAttribute(.font, value: UIFont(name: "Avenir Next Condensed Bold", size: fontSize!) as Any, range: NSRange(location: 0, length: str.length))
            
            //attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.skyBlue , range: rangeOfString)
            txVw.attributedText = attribute
           // tfTextToSpeech.attributedText = attribute

        }
        
    }
    
    func removeTrailingSpaces(with spaces : String) -> String{
        
            var spaceCount = 0
        
            for characters in spaces{
                if characters == " "{
                    print("Space Encountered")
                    spaceCount = spaceCount + 1
                }else{
                    break;
                }
            }

            var finalString = ""
            let duplicateString = spaces.replacingOccurrences(of: " ", with: "")
            while spaceCount != 0 {
              finalString = finalString + " "
                spaceCount = spaceCount - 1
            }

            return (finalString + duplicateString)
        }
    
    @IBAction func btnClearPressed(_ sender: Any) {
        
        txVw.text = ""
        txVwHeight.constant = 72
        btnClear.isHidden = true
    }

}

extension SpeechViewController : UITextViewDelegate {
 

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if let text1 = textView.text,
           let textRange = Range(range, in: text1) {
         var updatedText = text1.replacingCharacters(in: textRange,
                                                       with: text)
            
        
         
        print(updatedText)
            if updatedText.contains("..") {
                return false
            }
            if !btnClear.isHidden {
                
                if updatedText.isEmpty {
                    btnClear.isHidden = true
                }
                
            } else {
                if btnClear.isHidden && updatedText.length > 0 {
                    btnClear.isHidden = false
                }
            }
            
         if let char = text.cString(using: String.Encoding.utf8) {
                 let isBackSpace = strcmp(char, "\\b")
                 if (isBackSpace == -92) {
                     
          //           print("Backspace was pressed")
                     
                     return true
                 }
             }
         
         if updatedText.contains(" ") {
             
            
             var arrText = updatedText.components(separatedBy: " ")
             
             if arrText.last == "" {
                 
                AppDelegate.speechSynthesizer.delegate = nil
                 arrText.removeLast()
                 updatedText.trimmedTrailingSpaces()
                
               //  updatedText = removeTrailingSpaces(with: updatedText)
                 changeTextColor(str: updatedText, rangeString: arrText.last!)

                 textToSpeech(str: arrText.last!, fullString: "")
                 
             } else if arrText.last!.contains(".") {
                if arrText.last!.contains("..") {
                    return true
                }
                let tempArr = arrText.last?.components(separatedBy: "\n")
                if tempArr?.last == "" {
                    return true
                }
                if tempArr!.count > 1  {
                    return true
                }
//                if (tempArr?.last?.contains("\n"))! || tempArr?.last == ""  {
//                    return true
//                }
                
                updatedText.trimmedTrailingSpaces()
              //  self.range = NSRange(location: 0, length: updatedText.length)
              //  print("updatedText range \(NSRange(location: 0, length: updatedText.length))")
                 textToSpeech(str: arrText.last!, fullString: updatedText)
             }

         }

        }
        return true
        
    }
    func textViewDidChange(_ textView: UITextView) {

        var height = ceil(textView.contentSize.height) // ceil to avoid decimal

        if (height < minTextViewHeight + 5) { // min cap, + 5 to avoid tiny height difference at min height
            height = minTextViewHeight
        }
        if (height > maxTextViewHeight) { // max cap
            height = maxTextViewHeight
        }

        if height != txVwHeight.constant { // set when height changed
            txVwHeight.constant = height // change the value of NSLayoutConstraint
            txVw.setContentOffset(CGPoint.zero, animated: false) // scroll to top to avoid "wrong contentOffset" artefact when line count changes
        }
    }
}

//extension ViewController : UITextFieldDelegate {
//
//    func textField(_ textField: UITextField,
//                      shouldChangeCharactersIn range: NSRange,
//                      replacementString string: String) -> Bool {
//           if let text = textField.text,
//              let textRange = Range(range, in: text) {
//            var updatedText = text.replacingCharacters(in: textRange,
//                                                          with: string)
//
//          //  print(updatedText)
//
//            if let char = string.cString(using: String.Encoding.utf8) {
//                    let isBackSpace = strcmp(char, "\\b")
//                    if (isBackSpace == -92) {
//
//             //           print("Backspace was pressed")
//
//                        return true
//                    }
//                }
//
//            if updatedText.contains(" ") {
//
//                var arrText = updatedText.components(separatedBy: " ")
//
//                if arrText.last == "" {
//
//                    speechSynthesizer.delegate = nil
//                    arrText.removeLast()
//                    updatedText.trimmedTrailingSpaces()
//                  //  updatedText = removeTrailingSpaces(with: updatedText)
//                    changeTextColor(str: updatedText, rangeString: arrText.last!)
//
//                    textToSpeech(str: arrText.last!, fullString: "")
//
//                } else if arrText.last!.contains(".") {
//                    updatedText.trimmedTrailingSpaces()
//                    textToSpeech(str: arrText.last!, fullString: updatedText)
//                }
//
//            }
//
//           }
//           return true
//       }
//
//}


extension String {
    func indices(of occurrence: String) -> [Int] {
        var indices = [Int]()
        var position = startIndex
        while let range = range(of: occurrence, range: position..<endIndex) {
            let i = distance(from: startIndex,
                             to: range.lowerBound)
            indices.append(i)
            let offset = occurrence.distance(from: occurrence.startIndex,
                                             to: occurrence.endIndex) - 1
            guard let after = index(range.lowerBound,
                                    offsetBy: offset,
                                    limitedBy: endIndex) else {
                                        break
            }
            position = index(after: after)
        }
        return indices
    }
    
        func trimmingTrailingSpaces() -> String {
            var t = self
            while t.hasSuffix(" ") {
              t = "" + t.dropLast()
            }
            return t
        }

        mutating func trimmedTrailingSpaces() {
            self = self.trimmingTrailingSpaces()
        }

}
