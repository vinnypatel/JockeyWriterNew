//
//  GetTextFromScanViewController.swift
//  JoackyWriter
//
//  Created by Vinay Patel on 14/06/21.
//

import UIKit
import IQKeyboardManagerSwift
import AVFoundation

class GetTextFromScanViewController: UIViewController {

    @IBOutlet weak var tw: UITextView!
    var speechUtterance: AVSpeechUtterance!
    var strScanText : String =  ""
    @IBOutlet weak var btnPlay: UIButton!
    var fontSize: CGFloat?
    override func viewDidLoad() {
        super.viewDidLoad()

        if strScanText == "" {
            
            tw.text = "No text found from Scan"
        } else {
            
            tw.text = strScanText
        }
        let kIsiPad = UIDevice.current.userInterfaceIdiom == .pad
        fontSize = kIsiPad ? 60 : 40
        tw.font = UIFont(name: "Avenir Next Condensed Bold", size: fontSize!)
        
        self.title = "SCAN TEXT"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared.enable = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewDidDisappear(animated)
        AppDelegate.speechSynthesizer.stopSpeaking(at: .immediate)
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    @IBAction func btnStopPressed(_ sender: Any) {
        
        if speechUtterance != nil && (AppDelegate.speechSynthesizer.isPaused || AppDelegate.speechSynthesizer.isSpeaking) {
            btnPlay.isSelected = false
            AppDelegate.speechSynthesizer.stopSpeaking(at: .immediate)
        }
        
    }
    
    @IBAction func btnSpeakPressed(_ sender: UIButton) {
        
        
        if !btnPlay.isSelected {
            btnPlay.isSelected = true
            if speechUtterance != nil  && AppDelegate.speechSynthesizer.isPaused {
                
                AppDelegate.speechSynthesizer.continueSpeaking()
                
            } else {
                
                AppDelegate.speechSynthesizer.delegate = self
                
                if speechUtterance != nil {
                    speechUtterance = nil
                }

                speechUtterance = AVSpeechUtterance(string: tw.text)
                //Line 3. Specify the speech utterance rate. 1 = speaking extremely the higher the values the slower speech patterns. The default rate, AVSpeechUtteranceDefaultSpeechRate is 0.5
                speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 3.0
                // Line 4. Specify the voice. It is explicitly set to English here, but it will use the device default if not specified.
                speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                // Line 5. Pass in the urrerance to the synthesizer to actually speak.
                AppDelegate.speechSynthesizer.speak(speechUtterance)
                
            }
            
           
            
        } else {
            btnPlay.isSelected = false
            
            if speechUtterance != nil  && AppDelegate.speechSynthesizer.isSpeaking {
                
                AppDelegate.speechSynthesizer.pauseSpeaking(at: .immediate)
            }
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GetTextFromScanViewController: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        
        let mutableAttributedString = NSMutableAttributedString(string: utterance.speechString)
//            mutableAttributedString.addAttribute(.foregroundColor, value: UIColor.red, range: characterRange)
//
//        tw.attributedText = mutableAttributedString
        let strNumber: NSString = tw.text as NSString
        
        if mutableAttributedString.length == self.tw.attributedText.length {
            let range11 = (strNumber).range(of: tw.text)
            mutableAttributedString.addAttribute(.font, value: UIFont(name: "Avenir Next Condensed Bold", size: fontSize!) as Any, range: range11)
            mutableAttributedString.addAttributes([.foregroundColor: UIColor.skyBlue, .font: UIFont(name: "Avenir Next Condensed Bold", size: fontSize!) as Any], range: characterRange)
            
           // print("Mutable String length = \(mutableAttributedString.length)")
    //            //mutableAttributedString.addAttribute(.foregroundColor, value: UIColor.skyBlue, range: characterRange)
            tw.attributedText = mutableAttributedString
           // tfTextToSpeech.attributedText = mutableAttributedString
        }
        
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        
        btnPlay.isSelected = false
//        let mutableAttributedString = NSMutableAttributedString(string: utterance.speechString)
//        mutableAttributedString.addAttribute(.font, value: UIFont(name: "Avenir Next Condensed Bold", size: fontSize!) as Any, range: NSRange(utterance.speechString)!)
//        mutableAttributedString.addAttributes([.foregroundColor: UIColor.skyBlue, .font: UIFont(name: "Avenir Next Condensed Bold", size: fontSize!) as Any], range:  NSRange(utterance.speechString)!)
//        tw.attributedText = NSAttributedString(string: utterance.speechString)
    }
}
