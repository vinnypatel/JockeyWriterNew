//
//  AddViewController.swift
//  Demo
//
//  Created by Vinay Patel on 13/01/21.
//

import UIKit
import AVFoundation

class AddViewController: UIViewController, UITextFieldDelegate {

    var isCategory: Bool = false
    
   // @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var btnAdd:UIButton!
    @IBOutlet weak var wordLabel: UILabel!
    
    
    var strTxt: String?
    
    var arrCategory: [CategoryModel] = []
    var arrSubCategory:[SubCategoryModel] = []
    var path: String?
    var strCategoryId: String = ""
    
    var callBack : (([CategoryModel])->())?
    var callBack1 : (([SubCategoryModel])->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = isCategory ? "Add Category" : "Add Word"
        wordLabel.textColor = UIColor.darkBlue.withAlphaComponent(0.5)
        imgVw.layer.borderWidth = Utils.isPad ? 1.0 : 0.5
        imgVw.layer.borderColor = UIColor.darkGray.cgColor
        imgVw.layer.masksToBounds = true
       // tfTitle.delegate = self

        let rec2 = UITapGestureRecognizer.init(target: self,
                                                      action: #selector(AddViewController.enterWord))
                wordLabel.addGestureRecognizer(rec2)
        
        let rec = UITapGestureRecognizer.init(target: self,
                                              action: #selector(AddViewController.selectPhoto))
        imgVw.addGestureRecognizer(rec)
   
    
        // Do any additional setup after loading the view.
    }
    
    @objc func selectPhoto() {
        checkForCameraPermission()
//        let imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
//        imagePicker.sourceType = .photoLibrary
//        self.navigationController?.show(imagePicker, sender: self)
    }
    
    @objc func enterWord() {
        self.strTxt = ""
        let message = "Enter word"
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = self.strTxt
            textField.delegate = self
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            if let text = alert?.textFields![0].text {
                if text.count > 0 {
                    self.strTxt = text
                }
                else {
                    self.strTxt = nil
                }
            }
            else {
                self.strTxt = nil
            }
            if let string = self.strTxt {
                self.wordLabel.text = string
                self.wordLabel.textColor = UIColor.darkBlue
                if self.imgVw.image != nil {
                    self.btnAdd.isEnabled = true
                }
                else {
                    self.btnAdd.isEnabled = false
                }
            }
            else {
                self.wordLabel.text = "Add Word"
                self.wordLabel.textColor = UIColor.darkBlue.withAlphaComponent(0.5)
                self.btnAdd.isEnabled = false
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func btnAddImagePressed(_ sender: Any) {

            checkForCameraPermission()
        }
        
        func openActionSheetForImageCapture(){
            
            DispatchQueue.main.async {
                
                CameraHandler.shared.showActionSheet(vc: self, btn: self.imgVw)
                
                CameraHandler.shared.imagePickedBlock = { image in
                    
                    if image.size.width > 500.0 && Utils.isPad {
                                    if let compressed = image.resized(toWidth: 500.0) {
                                        self.imgVw.image = compressed
                                        if self.strTxt != nil {
                                            self.btnAdd.isEnabled = true
                                        }
                                        else {
                                            self.btnAdd.isEnabled = false
                                        }
                                    }
                    } else if image.size.width > 300.0 && !Utils.isPad {
                        
                        if let compressed = image.resized(toWidth: 300.0) {
                            self.imgVw.image = compressed
                            if self.strTxt != nil {
                                self.btnAdd.isEnabled = true
                            }
                            else {
                                self.btnAdd.isEnabled = false
                            }
                        }
                    }
                                else {
                                    self.imgVw.image = image
                                    if self.strTxt != nil {
                                        self.btnAdd.isEnabled = true
                                    }
                                    else {
                                        self.btnAdd.isEnabled = false
                                    }
                                }
                            }
//
//                    if image.size.width > 300 {
//                        self.imgVw.image = image.resized(toWidth: 300)
//
//                        return
//                       // self.imgVw.image = image
//                    }
//
//                    self.imgVw.image = image

                    
                }
            
        }
        
        func checkForCameraPermission(){
            if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                
                openActionSheetForImageCapture()
            } else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    if granted {
                        self.openActionSheetForImageCapture()
                        //access allowed
                    } else {
                        

                        
                    }
                })
            }
        }
    
    @IBAction func btnAddPressed(_ sender:Any) {
        
        
        
        if imgVw.image != nil && strTxt != "" {
            isCategory ? writeCategoryToUserDefaults() : writeSubCategoryToUserDefaults()
        }
        
    }
    func writeSubCategoryToUserDefaults(){
        
        let arrTemp = arrSubCategory.filter({$0.categoryId == strCategoryId})
        
        if arrTemp.contains(where: {$0.title == strTxt}) {
            let alert = UIAlertController(title: nil, message: "\(strTxt!) already exists", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }

            if APPDELEGATE.saveImageToDocumentDirectory(image: imgVw.image!, imageName: strTxt!.replacingOccurrences(of: " ", with: "_")) {
                
            }

            let arr: NSMutableArray = []
            let arrDict : [String: String] = ["id" : "\(arrSubCategory.count + 1)" ,
                                              "categoryId" : strCategoryId,
                                                 "title" : strTxt!,
                                                 "imgName" : strTxt!.replacingOccurrences(of: " ", with: "_")]

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: arrDict, options: .prettyPrinted)
                
                let tempDict = try JSONDecoder().decode(SubCategoryModel.self, from: jsonData)
                
                arrSubCategory.append(tempDict)
                
                arrSubCategory.forEach { model in
                    
                    let tempDict =  ["id" : model.id,
                                     "categoryId" : model.categoryId,
                                     "title" : model.title,
                                     "imgName" : model.imgName]
                    arr.add(tempDict)
                    
                }
                
                if arr.count > 0 {
            
                    USERDEFAULT.set(arr, forKey: "subCategory")
                    USERDEFAULT.synchronize()
                    
                    imgVw.image = nil
                    wordLabel.text = "Add Word"
                    strTxt = nil
                    wordLabel.textColor = UIColor.darkBlue.withAlphaComponent(0.5)
                    btnAdd.isEnabled = false
                    callBack1?(arrSubCategory)
    
                        }

                
            } catch let err {
                print(err.localizedDescription)
            }
        }
    
    func writeCategoryToUserDefaults(){
        
        if arrCategory.contains(where: {$0.title == strTxt}) {
            let alert = UIAlertController(title: nil, message: "\(strTxt!) already exists", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }

        if APPDELEGATE.saveImageToDocumentDirectory(image: imgVw.image!, imageName: strTxt!.replacingOccurrences(of: " ", with: "_")) {
            
        }

        let arr: NSMutableArray = []
        let arrDict : [String: String] = ["id" : "\(arrCategory.count + 1)" ,
                                             "title" : strTxt!,
                                             "imgName" : strTxt!.replacingOccurrences(of: " ", with: "_")]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: arrDict, options: .prettyPrinted)
            
            let tempDict = try JSONDecoder().decode(CategoryModel.self, from: jsonData)
            
            arrCategory.append(tempDict)
            
            arrCategory.forEach { model in
                
                let tempDict =  ["id" : model.id,
                                 "title" : model.title,
                                 "imgName" : model.imgName]
                arr.add(tempDict)
                
            }

                if arr.count > 0 {
                
                    
                    USERDEFAULT.set(arr, forKey: "category")
                    USERDEFAULT.synchronize()
                    
                    imgVw.image = nil
                    wordLabel.text = "Add Word"
                    strTxt = nil
                    wordLabel.textColor = UIColor.darkBlue.withAlphaComponent(0.5)
                    btnAdd.isEnabled = false
                    callBack?(arrCategory)
    
                        }
 
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           let characters = "ABCDEFGHIJKLMONPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
           let set = NSCharacterSet(charactersIn: characters).inverted
           return string.rangeOfCharacter(from: set) == nil
       }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//
//        tfTitle.resignFirstResponder()
//        return true
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if pickedImage.size.width > 500.0 {
                if let compressed = pickedImage.resized(toWidth: 500.0) {
                    imgVw.image = compressed
                    if strTxt != nil {
                        self.btnAdd.isEnabled = true
                    }
                    else {
                        self.btnAdd.isEnabled = false
                    }
                }
            } else if pickedImage.size.width > 300.0 && !Utils.isPad {
                
                if let compressed = pickedImage.resized(toWidth: 300.0) {
                    self.imgVw.image = compressed
                    if self.strTxt != nil {
                        self.btnAdd.isEnabled = true
                    }
                    else {
                        self.btnAdd.isEnabled = false
                    }
                }
            } else {
                imgVw.image = pickedImage
                if strTxt != nil {
                    self.btnAdd.isEnabled = true
                }
                else {
                    self.btnAdd.isEnabled = false
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
