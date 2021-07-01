//
//  CropViewController.swift
//  CropPickerView
//
//  Created by pikachu987 on 11/28/2018.
//  Copyright (c) 2018 pikachu987. All rights reserved.
//

import UIKit
import MobileCoreServices

class ScanToTextVC: UIViewController {
    @IBOutlet private weak var cropContainerView: UIView!

    @IBOutlet weak var cameraButton: UIButton!
      
    let processor = ScaledElementProcessor()
    
    var scannedText: String = "" {
      didSet {
        //textView.text = scannedText
      }
    }
    
    private let cropPickerView: CropPickerView = {
        let cropPickerView = CropPickerView()
        cropPickerView.translatesAutoresizingMaskIntoConstraints = false
        cropPickerView.backgroundColor = .black
        return cropPickerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.cropContainerView.addSubview(self.cropPickerView)
        
        self.cropContainerView.addConstraints([
            NSLayoutConstraint(item: self.cropContainerView!, attribute: .top, relatedBy: .equal, toItem: self.cropPickerView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.cropContainerView!, attribute: .bottom, relatedBy: .equal, toItem: self.cropPickerView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.cropContainerView!, attribute: .leading, relatedBy: .equal, toItem: self.cropPickerView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self.cropContainerView!, attribute: .trailing, relatedBy: .equal, toItem: self.cropPickerView, attribute: .trailing, multiplier: 1, constant: 0)
        ])

        self.cropPickerView.delegate = self

        DispatchQueue.main.async {
            self.cropPickerView.image(UIImage(named: "scanned-text"))
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getTextPressed(_ sender: Any) {
        
        self.cropPickerView.crop { (crop) in
            
            let image = crop.image
            let widthInPixels = image!.size.width
            let heightInPixels = image!.size.height
            
            let imgVw = UIImageView.init(frame:CGRect(x: 0, y: 0, width: widthInPixels, height: heightInPixels) )
            
            
            imgVw.image = image
           
            
                    APPDELEGATE.showLoadingView()
            
            self.drawFeatures(in: imgVw) {
                        APPDELEGATE.hideLoadingView()
            
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
                        let vc = storyboard.instantiateViewController(withIdentifier: "GetTextFromScanViewController") as! GetTextFromScanViewController
            
                        vc.strScanText = self.scannedText
            
                        self.navigationController?.pushViewController(vc, animated: true)
                    }

        }
  
    }
    
    private func drawFeatures(in imageView: UIImageView, completion: (() -> Void)? = nil) {
      //removeFrames()
      processor.process(in: imageView) { text, elements in
  //      elements.forEach() { element in
  //        self.frameSublayer.addSublayer(element.shapeLayer)
  //      }
        self.scannedText = text
          
        completion?()
      }
    }
    
    
  @IBAction func cameraDidTouch(_ sender: UIButton) {
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      presentImagePickerController(withSourceType: .camera)
    } else {
      let alert = UIAlertController(title: "Camera Not Available", message: "A camera is not available. Please try picking an image from the image library instead.", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      present(alert, animated: true, completion: nil)
    }
  }
  
  @IBAction func libraryDidTouch(_ sender: UIButton) {
    presentImagePickerController(withSourceType: .photoLibrary)
  }

}

// MARK: CropPickerViewDelegate
extension ScanToTextVC: CropPickerViewDelegate {
    func cropPickerView(_ cropPickerView: CropPickerView, result: CropResult) {

    }

    func cropPickerView(_ cropPickerView: CropPickerView, didChange frame: CGRect) {

    }
}


extension ScanToTextVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate {
  // MARK: UIImagePickerController
  
  private func presentImagePickerController(withSourceType sourceType: UIImagePickerController.SourceType) {
    let controller = UIImagePickerController()
    controller.delegate = self
    controller.sourceType = sourceType
    controller.mediaTypes = [String(kUTTypeImage), String(kUTTypeMovie)]
    present(controller, animated: true, completion: nil)
  }
  
  // MARK: UIImagePickerController Delegate
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    if let pickedImage =
      info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      
     // imageView.contentMode = .scaleAspectFit
      let fixedImage = pickedImage.fixOrientation1()
     // imageView.image = fixedImage
        self.cropPickerView.image(fixedImage)
    }
    dismiss(animated: true, completion: nil)
  }
}
