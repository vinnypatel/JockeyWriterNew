//
//  DrawingViewController.swift
//  JoackyWriter
//
//  Created by Ilya Kulbakin on 01/02/2017.
//  Copyright © 2017 Jenex Software. All rights reserved.
//

import UIKit

class DrawingViewController: UIViewController, DrawingViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var tokenEconomyBoardTopSpace: NSLayoutConstraint!
    @IBOutlet weak var typeLblHeight: NSLayoutConstraint!
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var tokenEconomyBoardView: TokenEconomyBoardView!
    @IBOutlet var popUpView: UIImageView!
    @IBOutlet weak var typeTextfield: UITextField!
    @IBOutlet var typeLblContainer: UIView!
    @IBOutlet fileprivate var typeLbl: UILabel!
    
    @IBOutlet weak var typeLblScrollView: UIScrollView!
    @IBOutlet weak var typeLblScrollViewTop: NSLayoutConstraint!
    @IBOutlet weak var typeLblScrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var typeLblScrollViewLeading: NSLayoutConstraint!
    @IBOutlet weak var typeLblScrollViewTrailing: NSLayoutConstraint!
    @IBOutlet var trainBackImgView : UIImageView!
    
    
    var text: String = "test"
    var isSightWords = false
    var correctCharCount = 0 as Int
    var onlyNumber = false

    private var attemptIndex = 0
    private var currentDrawingViewIndex = 0
    private var drawingViews = [DrawingView]()
    
    private let phoneFixedFontSize = 160.0 as CGFloat
    private var padFixedFontSize = 400.0 as CGFloat
    private var scrollviewWidth = 0 as CGFloat
    private var totalStringLength = 0 as CGFloat
    private let fontName = "RockoFLF" as String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Utils.isPad {
            
            let value = UIInterfaceOrientation.landscapeRight.rawValue
            
            UIDevice.current.setValue(value, forKey: "orientation")
            
        }
        
        
        trainBackImgView.isHidden = true
        
        if let reward = Account.reward {
            tokenEconomyBoardView.setReward(reward)
        }
        
        if Account.writerOption == 0 {
            
            let grayString = NSMutableAttributedString(
                string: text,
                attributes: [:])
            
            grayString.addAttribute(
                NSAttributedString.Key.foregroundColor,
                value: UIColor.lightGray,
                range: NSRange(
                    location:0,
                    length:text.length))
            
            typeLbl.attributedText = grayString
            
            scrollView.isHidden = true
            trainBackImgView.isHidden = true
            
            if onlyNumber {
                
                typeTextfield.keyboardType = UIKeyboardType.numberPad
                
            }
            
            typeTextfield.text = ""
            
        } else {
            
            scrollView.isHidden = false
            trainBackImgView.isHidden = false
            
        }
        
        typeLblScrollView.isHidden = !scrollView.isHidden
        
        typeLbl.font = UIFont.init(name: fontName,
                                    size: Utils.isPad ? padFixedFontSize : phoneFixedFontSize)
        
        typeLbl.backgroundColor = UIColor.clear
        typeLblScrollView.backgroundColor = UIColor.clear
        scrollView.backgroundColor = UIColor.clear
        
        print("\(UIScreen.main.bounds.size)")
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let image = Utils.image(for: text), isSightWords == false {
            showImage(image, afterCompletion: false)
        }
        else
        {
            Sounds.default.speak(text)
            setupDrawingViews()
            
            if scrollView.isHidden {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                
                    self.typeTextfield.becomeFirstResponder()
                    
                }
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutViews()
        setChildInfo()
        tokenEconomyBoardView.tokensCount = Account.numberOfTokens
        tokenEconomyBoardView.score = attemptIndex
        Sounds.default.stopMusic()
        UIApplication.shared.statusBarStyle = .default
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
            self.layoutViews()
        }) { context in }
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    // MARK: - UI
    
    func setDrawingViewOffset() {
        let drawingView = drawingViews[currentDrawingViewIndex]
        let xOffset = drawingView.frame.origin.x - (scrollView.frame.width - drawingView.frame.size.width) / 2.0
        if xOffset > 0 {
            self.scrollView.setContentOffset(CGPoint.init(x: xOffset, y: 0),
                                             animated: true)
        }
    }
    
    func setChildInfo() {
        tokenEconomyBoardView.setName(name: Account.name)
        tokenEconomyBoardView.photoImageView.layer.cornerRadius = Utils.isPad ? 35.0 : 17.5
        tokenEconomyBoardView.photoImageView.layer.borderWidth = Utils.isPad ? 2.0 : 1.0
        tokenEconomyBoardView.photoImageView.layer.borderColor = UIColor.skyBlue.cgColor
        tokenEconomyBoardView.photoImageView.layer.masksToBounds = true
        if let photo = Account.photo {
            tokenEconomyBoardView.photoImageView.image = photo
        }
        else {
            tokenEconomyBoardView.photoImageView.image = UIImage.init(named: "I am")
        }
    }
    
    func layoutViews() {
        
        if Utils.isLandscapeMode == true || UIScreen.main.bounds.height == 480.0 {
            
            tokenEconomyBoardTopSpace.constant = 4.0
            
            if scrollView.isHidden {
                
                if Utils.isPad {
                    
                    if (UIScreen.main.bounds.size.height == 1024.0
                    && UIScreen.main.bounds.size.width == 1366.0)
                    {
                        typeLblHeight.constant = 360.0
                        
                        typeLblScrollViewHeight.constant = 360.0
                        
                        padFixedFontSize = 230.0
                    }
                    else if (UIScreen.main.bounds.size.height == 834.0
                        && UIScreen.main.bounds.size.width == 1112.0)
                    {
                        typeLblHeight.constant = 240.0
                        
                        typeLblScrollViewHeight.constant = 240.0
                        
                        padFixedFontSize = 200.0
                    }
                    else //(UIScreen.main.bounds.size.height == 768.0 && UIScreen.main.bounds.size.width == 1024.0)
                    {
                        typeLblHeight.constant = 180.0
                        
                        typeLblScrollViewHeight.constant = 180.0
                        
                        padFixedFontSize = 150.0
                    }
                    
                    typeLblScrollViewTop.constant = 5.0
                    
                }
                
            }
        }
        else {
           tokenEconomyBoardTopSpace.constant = 20.0
            
            if scrollView.isHidden {
                
                if Utils.isPad {
                    
                    if (UIScreen.main.bounds.size.height == 1024.0
                        && UIScreen.main.bounds.size.width == 1366.0)
                    {
                        
                    }
                    else if (UIScreen.main.bounds.size.height == 834.0
                        && UIScreen.main.bounds.size.width == 1112.0)
                    {
                        
                    }
                    else //(UIScreen.main.bounds.size.height == 768.0 && UIScreen.main.bounds.size.width == 1024.0)
                    {
                        
                    }
                    
                    typeLblHeight.constant = 500
                    
                    typeLblScrollViewHeight.constant = 500
                    
                    padFixedFontSize = 400.0
                    
                } else {
                    
                    // for iphone5, 200 is the best height for the typeLbl
                    
                    typeLblHeight.constant = 200 + (UIScreen.main.bounds.size.height - 568)
                    
                    typeLblScrollViewHeight.constant = 200 + (UIScreen.main.bounds.size.height - 568)
                }
                
            }
        }
        
        typeLbl.font = UIFont.init(name: fontName,
                                   size: Utils.isPad ? padFixedFontSize : phoneFixedFontSize)
        
        if typeLblScrollView.isHidden == false {
            
            totalStringLength = (typeLbl.text?.width(withFixedHeight: typeLbl.bounds.size.height,
                                                     font: UIFont.init(name: fontName, size: Utils.isPad ? padFixedFontSize : phoneFixedFontSize)!))!
            
            totalStringLength = totalStringLength + 40
            
            scrollviewWidth = UIScreen.main.bounds.size.width // decrease as much as padding from both sides
            
            var fixedPadding = 0 as CGFloat
            
            if Utils.isLandscapeMode == true || UIScreen.main.bounds.height == 480.0 {
                
                scrollviewWidth = UIScreen.main.bounds.size.height
                
            }
            
            if Utils.isPad {
                
                scrollviewWidth = UIScreen.main.bounds.size.width
                
            }
            
            print("Screen Size :  \(UIScreen.main.bounds.size)")
            
            fixedPadding = (scrollviewWidth - totalStringLength) / 2.0
            
            if fixedPadding < 15 {
                
                fixedPadding = 15.0
                
            }
            
            typeLblScrollView.frame = CGRect(x: fixedPadding, y: typeLblScrollView.frame.origin.y, width: totalStringLength, height: typeLblScrollView.frame.size.height)
            
            typeLblScrollViewLeading.constant = fixedPadding
            typeLblScrollViewTrailing.constant = fixedPadding
            
        }
        
    }
    
    func setupDrawingViews() {
        currentDrawingViewIndex = 0
        drawingViews.removeAll()
        for subview in scrollView.subviews {
            subview.removeFromSuperview()
        }
        var totalWidth: CGFloat = 0
        for letter in text {
            totalWidth += DrawingView.width(for: letter)
        }
        let count = text.count
        let contentView = UIView.init(frame: CGRect.init(x: 0,
                                                         y: 0,
                                                         width: totalWidth,
                                                         height: scrollView.frame.size.height))
        contentView.backgroundColor = UIColor.clear
        var currentPos: CGFloat = 0
        for i in 0..<count {
            let drawingView = DrawingView()
            let letter = text[text.index(text.startIndex, offsetBy: i)]
            if letter == " " {
                currentPos += Utils.isPad ? 144.0 : 80.0
                continue
            }
            let letterWidth = DrawingView.width(for: letter)
            drawingView.frame = CGRect.init(x: currentPos,
                                            y: 0,
                                            width: letterWidth,
                                            height: scrollView.frame.size.height)
            currentPos += letterWidth
            drawingView.backgroundColor = UIColor.clear
            drawingView.letter = letter
            drawingView.delegate = self
            
            drawingView.backgroundColor = UIColor.clear
            
            contentView.addSubview(drawingView)
            drawingViews.append(drawingView)
        }
        if contentView.frame.size.width < scrollView.frame.size.width {
            let freeSpace = scrollView.frame.size.width - contentView.frame.size.width
            var frame = contentView.frame
            frame.origin.x = freeSpace / 2
            contentView.frame = frame
            contentView.autoresizingMask = [.flexibleTopMargin,
                                            .flexibleBottomMargin,
                                            .flexibleLeftMargin,
                                            .flexibleRightMargin]
        }
        drawingViews.first?.isActive = true
        scrollView.addSubview(contentView)
        scrollView.contentSize = contentView.frame.size
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func showImage(_ image: UIImage, afterCompletion: Bool) {
        popUpView.layer.borderWidth = 0.0
        popUpView.layer.borderColor = UIColor.clear.cgColor
        popUpView.layer.cornerRadius = 0.0
        popUpView.layer.masksToBounds = true
        popUpView.isHidden = false
        popUpView.alpha = 0.0
        popUpView.image = image
        UIView.animate(withDuration: 1.0, animations: { 
            self.popUpView.alpha = 1.0
        }) { success in
            if afterCompletion == false {
                Sounds.default.speak(self.text)
                
                if self.scrollView.isHidden {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        
                        self.typeTextfield.becomeFirstResponder()
                        
                    }
                    
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if afterCompletion == true {
                _ = self.navigationController?.popViewController(animated: true)
            }
            UIView.animate(withDuration: 1.0, animations: {
                self.popUpView.alpha = 0.0
            }) { success in
                self.setupDrawingViews()
                self.popUpView.isHidden = true
            }
        }
    }
    
    func showSuccessView() {
        popUpView.layer.borderWidth = Utils.isPad ? 1.0 : 0.5
        popUpView.layer.borderColor = UIColor.darkGray.cgColor
        popUpView.layer.cornerRadius = Utils.isPad ? 20.0 : 10.0
        popUpView.layer.masksToBounds = true
        popUpView.isHidden = false
        popUpView.alpha = 0.0
        popUpView.image = UIImage.init(named: "GoodJob")
        UIView.animate(withDuration: 1.0) { 
            self.popUpView.alpha = 1.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func checkTypeGoal() {
        
        print("success")
        
        attemptIndex = attemptIndex + 1
        
        // init the typeLbl with attributed text
        
        let grayString = NSMutableAttributedString(
            string: text,
            attributes: [:])
        
        grayString.addAttribute(
            NSAttributedString.Key.foregroundColor,
            value: UIColor.lightGray,
            range: NSRange(
                location:0,
                length:text.length))
        
        typeLbl.attributedText = grayString
        
        correctCharCount = 0 as Int
        typeTextfield.text = ""
        typeLblScrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
        
        tokenEconomyBoardView.score = attemptIndex
        Sounds.default.playSuccessSound()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            if self.attemptIndex == Account.numberOfTokens {
                
                self.typeTextfield.resignFirstResponder()
                
                if let image = Utils.image(for: self.text), self.isSightWords == true {
                    
                    self.showImage(image, afterCompletion: true)
                    
                }
                else {
                    
                    self.showSuccessView()
                }
            }
        }
        
    }
    
    // MARK: - DrawingViewDelegate
    
    func drawingViewDidCompleteDraw(drawingView: DrawingView) {
        if currentDrawingViewIndex == text.replacingOccurrences(of: " ", with: "").count - 1 {
            attemptIndex += 1
            tokenEconomyBoardView.score = attemptIndex
            Sounds.default.playSuccessSound()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if self.attemptIndex == Account.numberOfTokens {
                    if let image = Utils.image(for: self.text), self.isSightWords == true {
                        self.showImage(image, afterCompletion: true)
                    }
                    else {
                        self.showSuccessView()
                    }
                }
                else {
                    self.setupDrawingViews()
                }
            }
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.currentDrawingViewIndex += 1
                let drawingView = self.drawingViews[self.currentDrawingViewIndex]
                drawingView.isActive = true
                self.setDrawingViewOffset()
            }
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("\(String(describing: textField.text)) - 1")
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("\(String(describing: textField.text)) - 2")
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        print("\(String(describing: textField.text)) - 3")
        
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        print("\(String(describing: textField.text)) - 4")
        
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        print("\(String(describing: textField.text)) - 5")
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let inputedTxt = textField.text!
        
        let totalLettercount = text.count
        
        if correctCharCount < totalLettercount {
            
            let letter = self.text[self.text.index(self.text.startIndex, offsetBy: correctCharCount)]
            
            // if the inputted character is same as the indexed pattern char
            // then add the inputted char at the end of the text
            
            if string.lowercased() == String(letter).lowercased() {
                
                let sumTxt = inputedTxt + String(letter)
                
                let hightlightedString = NSMutableAttributedString(
                    string: text,
                    attributes: [:])
                
                hightlightedString.addAttribute(
                    NSAttributedString.Key.foregroundColor,
                    value: UIColor.lightGray,
                    range: NSRange(
                        location:0,
                        length:text.length))
                
                hightlightedString.addAttribute(
                    NSAttributedString.Key.foregroundColor,
                    value: UIColor.init(red: (41.0/255.0), green: (171.0/255.0), blue: (226.0/255.0), alpha: 1.0),
                    range: NSRange(
                        location:0,
                        length:sumTxt.length))
                
                typeLbl.attributedText = hightlightedString
                
                // will move the
                
                let inputtedTxtWidth = sumTxt.width(withFixedHeight: typeLbl.bounds.size.height,
                                                    font: UIFont.init(name: fontName, size: Utils.isPad ? padFixedFontSize : phoneFixedFontSize)!)
                
                print("Label Width : \(inputtedTxtWidth)")
                
                correctCharCount = correctCharCount + 1
                
                // expected width
                
                if correctCharCount < totalLettercount {
                    
                    let nLetter = text[text.index(text.startIndex, offsetBy: correctCharCount)]
                    
                    let futureWord = sumTxt + String(nLetter)
                    
                    let nLetterWidth = String(nLetter).width(withFixedHeight: typeLbl.bounds.size.height,
                                                        font: UIFont.init(name: fontName, size: Utils.isPad ? padFixedFontSize : phoneFixedFontSize)!)
                    
                    let futureTxtWidth = futureWord.width(withFixedHeight: typeLbl.bounds.size.height,
                                                        font: UIFont.init(name: fontName, size: Utils.isPad ? padFixedFontSize : phoneFixedFontSize)!)
                    
                    print("Future Label Width : \(futureTxtWidth)")
                
                    if futureTxtWidth > (scrollviewWidth - 30 - nLetterWidth/2) {
                        
                        var nextOffsetPoint = CGPoint.zero
                        var nextOffsetXPos = 0.0 as CGFloat
                        
                        nextOffsetXPos = futureTxtWidth - scrollviewWidth + 30 + nLetterWidth
                        
                        nextOffsetPoint = CGPoint(x: nextOffsetXPos, y: 0)
                        
                        typeLblScrollView.setContentOffset(nextOffsetPoint, animated: true)
                    }
                    
                }
                
                if correctCharCount < totalLettercount {
                    
                    Sounds.default.playTraceSound()
                    
                }
                
                if self.text.lowercased() == sumTxt.lowercased() {
                
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        
                        self .checkTypeGoal()
                        
                    }
                    
                    return false
                    
                } else {
                    
                    return true
                    
                }
                
            } else {
                
                if (String(letter) == " ") {
                    
                    Sounds.default.speak("space")
                    
                } else {
                    
                    Sounds.default.speak(String(letter).lowercased())
                }
                
                
                
                return false
            }
        } else {
            
            if self.text.lowercased() == inputedTxt.lowercased() {
                
                self .checkTypeGoal()
            }
            
            return false
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        print("\(String(describing: textField.text)) - 7")
        
        return true
    }
}

