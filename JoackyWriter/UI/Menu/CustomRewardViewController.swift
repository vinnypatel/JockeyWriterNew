//
//  CustomRewardViewController.swift
//  JoackyWriter
//
//  Created by Ilya Kulbakin on 04/03/2017.
//  Copyright © 2017 Jenex Software. All rights reserved.
//

import UIKit

class CustomRewardViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var originalString: String?
    var string: String?
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var wordLabel: UILabel!
    @IBOutlet var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = originalString != nil ? "Edit \"\(originalString!)\"" : "Add"
        if let string = originalString {
            self.string = string
            wordLabel.text = string
            wordLabel.textColor = UIColor.darkBlue
            imageView.image = Utils.image(for: string)
            addButton.setTitle("Save", for: .normal)
            addButton.isEnabled = true
        }
        else {
            self.wordLabel.text = "enter reward"
            wordLabel.textColor = UIColor.darkBlue.withAlphaComponent(0.7)
        }
        
        imageView.layer.borderWidth = Utils.isPad ? 1.0 : 0.5
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        imageView.layer.masksToBounds = true
        let rec = UITapGestureRecognizer.init(target: self,
                                              action: #selector(CustomRewardViewController.selectPhoto))
        imageView.addGestureRecognizer(rec)
        let rec2 = UITapGestureRecognizer.init(target: self,
                                               action: #selector(CustomRewardViewController.enterWord))
        wordLabel.addGestureRecognizer(rec2)
    }
    
    // MARK: -
    
    @IBAction func add() {
        var words = RewardsViewController.defaultRewards
        if let rewards = Account.rewards {
            words.append(contentsOf: rewards)
        }
        if words.contains(string!) == true, string! != originalString {
            let alert = UIAlertController(title: nil, message: "\(self.string!) already exists", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if let editingString = originalString {
            Account.editReward(editingString, newWord: string!, picture: imageView.image!)
            _ = self.navigationController?.popViewController(animated: true)
        }
        else {
            if Account.addReward(string!, picture: imageView.image!) {
                _ = self.navigationController?.popViewController(animated: true)
            }
            else {
                let alert = UIAlertController(title: nil, message: "Oops! Something went wrong", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { (_) in
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func selectPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.navigationController?.show(imagePicker, sender: self)
    }
    
    @objc func enterWord() {
        let message = "Enter reward"
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = self.string
            textField.delegate = self
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            if let text = alert?.textFields![0].text {
                if text.count > 0 {
                    self.string = text
                }
                else {
                    self.string = nil
                }
            }
            else {
                self.string = nil
            }
            if let string = self.string {
                self.wordLabel.text = string
                self.wordLabel.textColor = UIColor.darkBlue
                if self.imageView.image != nil {
                    self.addButton.isEnabled = true
                }
                else {
                    self.addButton.isEnabled = false
                }
            }
            else {
                self.wordLabel.text = "enter reward"
                self.wordLabel.textColor = UIColor.darkBlue.withAlphaComponent(0.7)
                self.addButton.isEnabled = false
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
            if pickedImage.size.width > 300.0 {
                if let compressed = pickedImage.resized(toWidth: 300.0) {
                    imageView.image = compressed
                    if string != nil {
                        self.addButton.isEnabled = true
                    }
                    else {
                        self.addButton.isEnabled = false
                    }
                }
            }
            else {
                imageView.image = pickedImage
                if string != nil {
                    self.addButton.isEnabled = true
                }
                else {
                    self.addButton.isEnabled = false
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let characters = "ABCDEFGHIJKLMONPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
        let set = NSCharacterSet(charactersIn: characters).inverted
        return string.rangeOfCharacter(from: set) == nil
    }
}
