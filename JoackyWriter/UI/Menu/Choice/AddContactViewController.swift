//
//  AddContactViewController.swift
//  JoackyWriter
//
//  Created by Vinay Patel on 29/01/21.
//  Copyright © 2021 Jenex Software. All rights reserved.
//

import UIKit
import AVFoundation

class AddContactViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var btnAdd: UIButton!
    var arrContact : [ContactModel] = []
    var strUserName : String?
    var strPhoneNumber : String?
   // var isUserName : Bool = false
    var callBack : (([ContactModel])->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblName.textColor = UIColor.darkBlue.withAlphaComponent(0.5)
        lblNumber.textColor = UIColor.darkBlue.withAlphaComponent(0.5)
        imgVw.layer.borderWidth = Utils.isPad ? 1.0 : 0.5
        imgVw.layer.cornerRadius = 60.0
        imgVw.layer.borderColor = UIColor.darkGray.cgColor
        imgVw.layer.masksToBounds = true
       // tfTitle.delegate = self

        let rec2 = UITapGestureRecognizer.init(target: self,
                                                      action: #selector(enterName))
        rec2.numberOfTapsRequired = 1
        lblName.isUserInteractionEnabled = true
                lblName.addGestureRecognizer(rec2)
        let rec1 = UITapGestureRecognizer.init(target: self,
                                                      action: #selector(enterPhoneNumber))
        rec1.numberOfTapsRequired = 1
        lblNumber.isUserInteractionEnabled = true
                lblNumber.addGestureRecognizer(rec1)
        
        let rec = UITapGestureRecognizer.init(target: self,
                                              action: #selector(selectPhoto))
        rec.numberOfTapsRequired = 1
        imgVw.isUserInteractionEnabled = true
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
    
    @IBAction func btnClosePressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    func openActionSheetForImageCapture(){
        
        DispatchQueue.main.async {
            
            CameraHandler.shared.showActionSheet(vc: self, btn: self.imgVw)
            
            CameraHandler.shared.imagePickedBlock = { image in
                
                if image.size.width > 200.0 && !Utils.isPad {
                    
                    if let compressed = image.resized(toWidth: 200.0) {
                        self.imgVw.image = compressed
                        if self.strUserName != nil && self.strPhoneNumber != nil {
                            self.btnAdd.isEnabled = true
                        }
                        else {
                            self.btnAdd.isEnabled = false
                        }
                    }
                }
                            else {
                                self.imgVw.image = image
                                if self.strUserName != nil && self.strPhoneNumber != nil{
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
    
    @IBAction func btnAddContactPressed(_ sender: Any) {
        
        if strPhoneNumber == nil || strUserName == nil || imgVw.image == nil {
            return
        }
        
        addContact()
        
        
    }
    
    func addContact(){
        
        if arrContact.contains(where: {$0.contactNumber == strPhoneNumber}) {
            let alert = UIAlertController(title: nil, message: "\(strPhoneNumber!) number already exists", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }

        if APPDELEGATE.saveImageToDocumentDirectory(image: imgVw.image!, imageName: strPhoneNumber!) {
            
        }

        let arr: NSMutableArray = []
        let arrDict : [String: String] = ["id" : "\(arrContact.count + 1)" ,
                                             "name" : strUserName!,
                                             "contactNumber" :  strPhoneNumber!,
                                             "imgName" : strPhoneNumber!]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: arrDict, options: .prettyPrinted)
            
            let tempDict = try JSONDecoder().decode(ContactModel.self, from: jsonData)
            
            arrContact.append(tempDict)
            
            arrContact.forEach { model in
                
                let tempDict =  ["id" : model.id,
                                 "name" : model.name,
                                 "contactNumber" : model.contactNumber,
                                 "imgName" : model.imgName]
                arr.add(tempDict)
                
            }

                if arr.count > 0 {
                
                    
                    USERDEFAULT.set(arr, forKey: "contact")
                    USERDEFAULT.synchronize()
                    
                    imgVw.image = nil
                    lblName.text = "Add Name"
                    lblNumber.text = "Add Number"
                    strUserName = nil
                    lblName.textColor = UIColor.darkBlue.withAlphaComponent(0.5)
                    lblNumber.textColor = UIColor.darkBlue.withAlphaComponent(0.5)
                    btnAdd.isEnabled = false
                    callBack?(arrContact)
    
                        }
 
        } catch let err {
            print(err.localizedDescription)
        }
    }

    @objc func enterName() {
        self.strUserName = ""
        let message = "Enter Name"
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = self.strUserName
            textField.tag = 0
            //self.isUserName = true
            textField.delegate = self
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            if let text = alert?.textFields![0].text {
                if text.count > 0 {
                    self.strUserName = text
                }
                else {
                    self.strUserName = nil
                }
            }
            else {
                self.strUserName = nil
            }
            if let string = self.strUserName {
                self.lblName.text = string
                self.lblName.textColor = UIColor.darkBlue
                if self.imgVw.image != nil && self.strPhoneNumber != nil {
                    self.btnAdd.isEnabled = true
                }
                else {
                    self.btnAdd.isEnabled = false
                }
            }
            else {
                self.lblName.text = "Add Name"
                self.lblName.textColor = UIColor.darkBlue.withAlphaComponent(0.5)
                self.btnAdd.isEnabled = false
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func enterPhoneNumber() {
        self.strPhoneNumber = ""
        let message = "Enter Phone Number"
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = self.strPhoneNumber
            textField.keyboardType = .phonePad
            textField.tag = 1
            textField.delegate = self
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            if let text = alert?.textFields![0].text {
                if text.count > 0 {
                    self.strPhoneNumber = text
                }
                else {
                    self.strPhoneNumber = nil
                }
            }
            else {
                self.strPhoneNumber = nil
            }
            if let string = self.strPhoneNumber {
                self.lblNumber.text = string
                self.lblNumber.textColor = UIColor.darkBlue
                if self.imgVw.image != nil && self.strUserName != nil {
                    self.btnAdd.isEnabled = true
                }
                else {
                    self.btnAdd.isEnabled = false
                }
            }
            else {
                self.lblNumber.text = "Add Number"
                self.lblNumber.textColor = UIColor.darkBlue.withAlphaComponent(0.5)
                self.btnAdd.isEnabled = false
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
        if textField.tag == 0 {
          
            let characters = "ABCDEFGHIJKLMONPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
                      let set = NSCharacterSet(charactersIn: characters).inverted
                      return string.rangeOfCharacter(from: set) == nil
        } else {
            
            let characters = "0123456789"
                      let set = NSCharacterSet(charactersIn: characters).inverted
                      return string.rangeOfCharacter(from: set) == nil
        }
          
       }
    

}

//
//extension AddContactViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            if pickedImage.size.width > 500.0 {
//                if let compressed = pickedImage.resized(toWidth: 500.0) {
//                    imgVw.image = compressed
//                    if strUserName != nil {
//                        self.btnAdd.isEnabled = true
//                    }
//                    else {
//                        self.btnAdd.isEnabled = false
//                    }
//                }
//            } else if pickedImage.size.width > 300.0 && !Utils.isPad {
//
//                if let compressed = pickedImage.resized(toWidth: 300.0) {
//                    self.imgVw.image = compressed
//                    if self.strUserName != nil {
//                        self.btnAdd.isEnabled = true
//                    }
//                    else {
//                        self.btnAdd.isEnabled = false
//                    }
//                }
//            } else {
//                imgVw.image = pickedImage
//                if strUserName != nil {
//                    self.btnAdd.isEnabled = true
//                }
//                else {
//                    self.btnAdd.isEnabled = false
//                }
//            }
//        }
//        picker.dismiss(animated: true, completion: nil)
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
//}
