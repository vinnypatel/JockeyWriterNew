

import UIKit
import MLKit
import AVFoundation

class TempViewController: UIViewController {
  
  @IBOutlet weak var mainImageView: UIImageView!
  @IBOutlet weak var tempImageView: UIImageView!
  
  @IBOutlet weak var mImageView: UIImageView!
  @IBOutlet weak var tImageView: UIImageView!
  
    @IBOutlet weak var lblMessage: UILabel!
  
  private var strokeManager: StrokeManager!
  
  var speechUtterance : AVSpeechUtterance!
  var lastPoint = CGPoint.zero
  var color = UIColor.black
  var brushWidth: CGFloat = 4.0
  var opacity: CGFloat = 1.0
  var swiped = false
  var secondImg = false
  
  override func viewDidLoad() {
    
    navigationItem.title = "Writeboard"
    
    let button = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
    
    self.navigationItem.leftBarButtonItem = button
        //self.navigationItem.backBarButtonItem = button
   // navigationItem.backBarButtonItem = UIBarButtonItem(
       // title: "Back", style: .plain, target: nil, action: nil)
    strokeManager = StrokeManager.init(delegate: self)

    let defaultLanguageIdentifier: DigitalInkRecognitionModelIdentifier =
      NSLocale.preferredLanguages.lazy.compactMap {
        try? DigitalInkRecognitionModelIdentifier.from(languageTag: $0)
      }.first ?? (try! DigitalInkRecognitionModelIdentifier.from(languageTag: "en"))
  

    strokeManager!.selectLanguage(languageTag: defaultLanguageIdentifier.languageTag)

    // Initialize the language picker and scroll it to have the above language selected.
    strokeManager!.downloadModel()
    
    }

    @objc func goBack()
    {
        self.dismiss(animated: true, completion: nil)
    }
  
  // MARK: - Actions
  
  @IBAction func btnBackPressed(_ sender: Any){
    
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func resetPressed(_ sender: Any) {
    mainImageView.image = nil
    mImageView.image = nil
    tempImageView.image = nil
    tImageView.image = nil
    secondImg = false
    strokeManager!.clear()
    displayMessage(message: "")
  }
  
  @IBAction func sharePressed(_ sender: Any) {
    strokeManager.recognizeInk()
//    guard let image = mainImageView.image else {
//      return
//    }
//    let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
//    present(activity, animated: true)
  }

  
  func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
    UIGraphicsBeginImageContext((secondImg ? mImageView : mainImageView).frame.size)
    guard let context = UIGraphicsGetCurrentContext() else {
      return
    }
    (secondImg ? tImageView : tempImageView).image?.draw(in: (secondImg ? mImageView : mainImageView).bounds)
    
    context.move(to: fromPoint)
    context.addLine(to: toPoint)
    
    context.setLineCap(.round)
    context.setBlendMode(.normal)
    context.setLineWidth(brushWidth)
    context.setStrokeColor(color.cgColor)
    
    context.strokePath()
    
    (secondImg ? tImageView : tempImageView).image = UIGraphicsGetImageFromCurrentImageContext()
    (secondImg ? tImageView : tempImageView).alpha = opacity
    
    UIGraphicsEndImageContext()
  }
  
  
  /** Handle start of stroke: Draw the point, and pass it along to the `StrokeManager`. */
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
 //   let touch = touches.first
//
    //if touch?.view?.frame.size > =
    // Since this is a new stroke, make last point the same as the current point.
//    lastPoint = touch!.location(in: view)
    
    guard let touch = touches.first else {
          return
        }
    
    
        swiped = false
        lastPoint = touch.location(in: view)
   // debugPrint("last point : \(lastPoint)")
    if lastPoint.y + self.topbarHeight > lblMessage.frame.origin.y {
          return
        }
    
    if lastPoint.y >= mImageView.frame.size.height * 0.25  {//mainImageView.frame.origin.y + mainImageView.frame.height {
    
        lastPoint = touch.location(in: mImageView)
        secondImg = true
         
        } else {
          
            lastPoint = touch.location(in: mainImageView)
            secondImg = false
        }
    
        let time = touch.timestamp
    
//        lastPoint = touch!.location(in: mainImageView)
//
//        if lastPoint.y > mainImageView.frame.origin.y + mainImageView.frame.height {
//
//          lastPoint = touch!.location(in: mImageView)
//          secondImg = true
//        } else {
//          secondImg = false
//        }
//
//        let time = touch!.timestamp
    
  //  let time = touch!.timestamp
    drawLineSegment(touch: touch)
    strokeManager!.startStrokeAtPoint(point: lastPoint, t: time)

  }
  /** Handle continuing a stroke: Draw the line segment, and pass along to the `StrokeManager`. */
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touch = touches.first
    
//    lastPoint = touch!.location(in: view)
   // debugPrint("last point : \(lastPoint)")
    if touch!.location(in: view).y > lblMessage.frame.origin.y {
      return
    }
//    if secondImg && touch!.location(in: view).y < mImageView.frame.height * 0.25 {
//
//        return
//
//    }
//    if !secondImg && touch!.location(in: view).y > mImageView.frame.height * 0.25 {
//        return
//    }
    drawLineSegment(touch: touch)
    strokeManager!.continueStrokeAtPoint(point: lastPoint, t: touch!.timestamp)
    
  }

  /** Handle end of stroke: Draw the line segment, and pass along to the `StrokeManager`. */
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
   // debugPrint("last point : \(lastPoint)")
    if lastPoint.y > lblMessage.frame.origin.y {
      return
    }
//
//    if secondImg && lastPoint.y < mImageView.frame.height * 0.75 {
//
//        return
//
//    }
//
//    if !secondImg && lastPoint.y > mImageView.frame.height * 0.75 {
//        return
//    }
    let touch = touches.first
    drawLineSegment(touch: touch)
    strokeManager!.endStrokeAtPoint(point: lastPoint, t: touch!.timestamp)
    
  }
  
//  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//    guard let touch = touches.first else {
//      return
//    }
//
//
//    swiped = false
//    lastPoint = touch.location(in: view)
//
//    if lastPoint.y > lblMessage.frame.origin.y {
//      return
//    }
//
//    if lastPoint.y <= mImageView.frame.origin.y {//mainImageView.frame.origin.y + mainImageView.frame.height {
//
//      lastPoint = touch.location(in: mainImageView)
//      secondImg = false
//    } else {
//      lastPoint = touch.location(in: mImageView)
//      secondImg = true
//    }
//
//    let time = touch.timestamp
//
//
//    //drawLineSegment(touch: touch)
//    strokeManager!.startStrokeAtPoint(point: lastPoint, t: time)
//  }
//
//  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//    guard let touch = touches.first else {
//      return
//    }
//    swiped = true
//    let currentPoint = touch.location(in: secondImg ? mImageView : mainImageView)
//    drawLine(from: lastPoint, to: currentPoint)
//
//    lastPoint = currentPoint
//   // strokeManager!.continueStrokeAtPoint(point: lastPoint, t: touch.timestamp)
//  }
//
//  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//    if !swiped {
//      // draw a single point
//      drawLine(from: lastPoint, to: lastPoint)
//    }
//
//    // Merge tempImageView into mainImageView
//    UIGraphicsBeginImageContext((secondImg ? mImageView : mainImageView).frame.size)
//    (secondImg ? mImageView : mainImageView).image?.draw(in: (secondImg ? mImageView : mainImageView).bounds, blendMode: .normal, alpha: 1.0)
//    (secondImg ? tImageView : tempImageView)?.image?.draw(in: (secondImg ? mImageView : mainImageView).bounds, blendMode: .normal, alpha: opacity)
//    (secondImg ? mImageView : mainImageView).image = UIGraphicsGetImageFromCurrentImageContext()
//    UIGraphicsEndImageContext()
//    let touch = touches.first
//    strokeManager!.endStrokeAtPoint(point: lastPoint, t: touch!.timestamp)
//    tempImageView.image = nil
//    tImageView.image = nil
//  }
}

extension TempViewController: StrokeManagerDelegate {
  func clearInk() {
    mainImageView.image = nil
    mImageView.image = nil
    tempImageView.image = nil
    tImageView.image = nil
    secondImg = false
  }
  
  func redraw() {
//    tempImageView.image = nil
//    tImageView.image = nil
//    let recognizedInks = strokeManager!.recognizedInks
//    for recognizedInk in recognizedInks {
//      drawInk(ink: recognizedInk.ink)
//      if recognizedInk.text != nil {
//        drawText(recognizedInk: recognizedInk)
//      }
//    }
  }
  
  func displayMessage(message: String) {
    
    lblMessage.text = message
   // debugPrint("Display message: \(message)")
    
    if message.isEmpty {// || message == "Model is already downloaded" {
        return
    }
    
    AppDelegate.speechSynthesizer.delegate = self

    speechUtterance = AVSpeechUtterance(string: lblMessage.text!)
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
  }
  
  func drawInk(ink: Ink) {
    UIGraphicsBeginImageContext((secondImg ? mImageView : mainImageView).frame.size)
    (secondImg ? tImageView : tempImageView).image?.draw(
      in: CGRect(
        x: 0, y: 0, width: (secondImg ? mImageView : mainImageView).frame.size.width, height: (secondImg ? mImageView : mainImageView).frame.size.height))
    let ctx: CGContext! = UIGraphicsGetCurrentContext()
    
    for stroke in ink.strokes {
        
      if stroke.points.isEmpty {
        continue
      }
      let point = CGPoint.init(x: Double(stroke.points[0].x), y: Double(stroke.points[0].y))
      ctx.move(to: point)
      ctx.addLine(to: point)
      for point in stroke.points {
        ctx.addLine(to: CGPoint.init(x: Double(point.x), y: Double(point.y)))
      }
    }
    
    ctx.setLineCap(CGLineCap.round)
    ctx.setLineWidth(10.0)
    // Recognized strokes are drawn in gray.
    ctx.setStrokeColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
    ctx.setBlendMode(CGBlendMode.normal)
    ctx.strokePath()
    ctx.flush()
    (secondImg ? tImageView : tempImageView).image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
  }

  /** Given an `Ink`, returned the bounding box of the ink. */
  func getInkRect(ink: Ink) -> CGRect {
    var rect = CGRect.null
    if ink.strokes.count == 0 {
      return rect
    }
    for stroke in ink.strokes {
      for point in stroke.points {
        rect = rect.union(CGRect(x: Double(point.x), y: Double(point.y), width: 0, height: 0))
      }
    }
    // Make the minimum size 10x10 pixels.
    rect = rect.union(
      CGRect(
        x: rect.midX - 5,
        y: rect.midY - 5,
        width: 10,
        height: 10))
    return rect
  }

  /**
   * Given a `recognizedInk`, compute the bounding box of the ink that it contains, and render the
   * text at roughly the same size as the bounding box.
   */
  func drawText(recognizedInk: RecognizedInk) {
    let rect = getInkRect(ink: recognizedInk.ink)
    UIGraphicsBeginImageContext((secondImg ? mImageView : mainImageView).frame.size)
    (secondImg ? tImageView : tempImageView).image?.draw(
      in: CGRect(
        x: 0, y: 0, width: (secondImg ? mImageView : mainImageView).frame.size.width, height: (secondImg ? mImageView : mainImageView).frame.size.height))
    let ctx: CGContext! = UIGraphicsGetCurrentContext()
    ctx.setBlendMode(CGBlendMode.normal)

    let arbitrarySize: CGFloat = 20
    let font = UIFont.systemFont(ofSize: arbitrarySize)
    let attributes = [
      NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.green,
    ]
    var size = recognizedInk.text!.size(withAttributes: attributes)
    if size.width <= 0 {
      size.width = 1
    }
    if size.height <= 0 {
      size.height = 1
    }
    ctx.translateBy(x: rect.origin.x, y: rect.origin.y)
    ctx.scaleBy(x: ceil(rect.size.width) / size.width, y: ceil(rect.size.height) / size.height)
    recognizedInk.text!.draw(at: CGPoint.init(x: 0, y: 0), withAttributes: attributes)
    ctx.flush()
    (secondImg ? tImageView : tempImageView).image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
  }
  
  func drawLineSegment(touch: UITouch!) {
    
    
    let currentPoint = touch.location(in: (secondImg ? mImageView : mainImageView))

    UIGraphicsBeginImageContext((secondImg ? mImageView : mainImageView).frame.size)
    (secondImg ? mImageView : mainImageView).image?.draw(
      in: CGRect(
        x: 0, y: 0, width: (secondImg ? mImageView : mainImageView).frame.size.width, height: (secondImg ? mImageView : mainImageView).frame.size.height))
    let ctx: CGContext! = UIGraphicsGetCurrentContext()
    ctx.move(to: lastPoint)
    ctx.addLine(to: currentPoint)
    ctx.setLineCap(CGLineCap.round)
    ctx.setLineWidth(3.0)
    // Unrecognized strokes are drawn in blue.
    
    if #available(iOS 12.0, *) {
        if self.traitCollection.userInterfaceStyle == .dark {
            ctx.setStrokeColor(red: 1, green: 1, blue: 1, alpha: 1)
        } else {
            ctx.setStrokeColor(red: 0, green: 0, blue: 0, alpha: 1)
        }
    } else {
        ctx.setStrokeColor(red: 0, green: 0, blue: 0, alpha: 1)
        // Fallback on earlier versions
    }
    
    ctx.setBlendMode(CGBlendMode.normal)
    ctx.strokePath()
    ctx.flush()
    (secondImg ? mImageView : mainImageView).image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    lastPoint = currentPoint
  }

}

extension TempViewController: AVSpeechSynthesizerDelegate {
  
  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
      let mutableAttributedString = NSMutableAttributedString(string: utterance.speechString)
      mutableAttributedString.addAttribute(.foregroundColor, value: UIColor.skyBlue, range: characterRange)
      lblMessage.attributedText = mutableAttributedString
  }

  func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
    lblMessage.attributedText = NSAttributedString(string: utterance.speechString)
  }
}


extension UIViewController {

    var topbarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        } else {
            let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
            return topBarHeight
        }
    }
}
