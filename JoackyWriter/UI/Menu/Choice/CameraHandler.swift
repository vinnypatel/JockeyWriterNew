//
//  CameraHandler.swift
//  FMD
//
//  Created by Vinay Patel on 15/03/2019.
//  Copyright © 2019 GHPL. All rights reserved.
//
import Foundation
import UIKit


class CameraHandler: NSObject{
    static let shared = CameraHandler()
    
    fileprivate var currentVC1: UIViewController!
    
    //MARK: Internal Properties
    var imagePickedBlock: ((UIImage) -> Void)?
    
    func camera() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .camera
          //  myPickerController.allowsEditing = true
            currentVC1.present(myPickerController, animated: true, completion: nil)
        }
        
    }
    
    func photoLibrary(){
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .photoLibrary
            //myPickerController.allowsEditing = true
            currentVC1.present(myPickerController, animated: true, completion: nil)
        }
        
    }
    
    func showActionSheet(vc: UIViewController, btn: UIView) {
        currentVC1 = vc
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "CAMERA", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "GALLERY", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            //
            actionSheet.modalPresentationStyle = .popover
            actionSheet.popoverPresentationController?.sourceView = btn
            //actionSheet.preferredContentSize = CGSize.init(width: 400, height: 250)
            actionSheet.popoverPresentationController?.sourceRect = btn.bounds
            actionSheet.popoverPresentationController?.permittedArrowDirections = .any
            vc.present(actionSheet, animated: true)
            
            return
            
        }
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
    
}


extension CameraHandler: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentVC1.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        if let image = info[.originalImage] as? UIImage {
            self.imagePickedBlock?(image)
        }else{
            print("Something went wrong")
        }
        currentVC1.dismiss(animated: true, completion: nil)
    }

}
