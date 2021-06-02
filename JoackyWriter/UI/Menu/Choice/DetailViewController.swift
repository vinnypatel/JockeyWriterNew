//
//  DetailViewController.swift
//  Demo
//
//  Created by Vinay Patel on 13/01/21.
//

import UIKit
import AVFoundation


class DetailViewController: UIViewController, AVSpeechSynthesizerDelegate {

    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var imgVw: UIImageView!
    
    var strPhrase: String?
    var strText:String?
    var img: UIImage!
    
    //static var speechSynthesizer = AVSpeechSynthesizer()
    var speechUtterance : AVSpeechUtterance!
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        speechUtterance = nil
        
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        lblText.text = strPhrase! + " " + strText!
        imgVw.image = img
        
        
//        let longString = "Lorem ipsum dolor. VeryLongWord ipsum foobar"
//        let longestWord = "VeryLongWord"
//
//        let longestWordRange = (lblText.text! as NSString).range(of: strText!)
//
//        let attributedString = NSMutableAttributedString(string: lblText.text!, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 40)])
//
//        attributedString.setAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 50)], range: longestWordRange)
//
//
//        lblText.attributedText = attributedString
       // attributedString.setAttributes([NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 20), NSAttributedStringKey.foregroundColor : UIColor.red], range: longestWordRange)
        
        
//        let utterance = AVSpeechUtterance(string: strText!)
//            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")

            //let synthesizer = AVSpeechSynthesizer()
        AppDelegate.speechSynthesizer.delegate = self
        
        speechUtterance = AVSpeechUtterance(string: lblText.text!)
                    //Line 3. Specify the speech utterance rate. 1 = speaking extremely the higher the values the slower speech patterns. The default rate, AVSpeechUtteranceDefaultSpeechRate is 0.5
                    speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 3.0
                    // Line 4. Specify the voice. It is explicitly set to English here, but it will use the device default if not specified.
                    speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
                    // Line 5. Pass in the urrerance to the synthesizer to actually speak.
                   // speechSynthesizer.speak(speechUtterance)
       // utterance.rate = AVSpeechUtteranceMaximumSpeechRate / 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // your code here
            AppDelegate.speechSynthesizer.speak(self.speechUtterance)
        }
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnMessage(_sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactSelectionViewController") as! ContactSelectionViewController
        vc.strMessageText = lblText.text!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        let mutableAttributedString = NSMutableAttributedString(string: utterance.speechString)
        mutableAttributedString.addAttribute(.foregroundColor, value: UIColor.skyBlue, range: characterRange)
        lblText.attributedText = mutableAttributedString
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        lblText.attributedText = NSAttributedString(string: utterance.speechString)
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



