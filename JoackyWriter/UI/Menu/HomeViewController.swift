//
//  HomeViewController.swift
//  JoackyWriter
//
//  Created by Ilya Kulbakin on 20/02/2017.
//  Copyright © 2017 Jenex Software. All rights reserved.
//

import UIKit
//import SwiftyDropbox

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet var collectionView: UICollectionView!

   // var pdfFiles: Array<Files.Metadata>?
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }) { context in }
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Sounds.default.playMusic()
        
        collectionView.reloadData()
        
        if Account.name == nil {
            enterName()
        }
        
        if Account.reward == nil {
            Account.reward = "cookie"
        }
    }
    
    @objc func selectPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.navigationController?.show(imagePicker, sender: self)
    }
    
    func enterName() {
        let alert = UIAlertController(title: "Name", message: "Enter your name", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = Account.name
            textField.delegate = self
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            if let text = alert?.textFields![0].text {
                Account.name = text
                self.collectionView.reloadData()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
//    func checkDropBoxLink() {
//
//        if DropboxClientsManager.authorizedClient != nil {
//
//            // If the the app was linked to dropbox already, then show the listview
//            // but at this time, will show the newest file by comparing the
//            // modified date
//
////            DropboxClientsManager.unlinkClients()
//
//            self .getNewWorksheet()
//
//
//        } else {
//
//            // In this case, there is not any linked dropbox, so we will try
//            // to link the dropbox to our app
//
//            DropboxClientsManager.authorizeFromController(UIApplication.shared, controller: self, openURL: {(url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil)})
//
//        }
//
//    }
    
//    func getNewWorksheet() {
//
//        self.pdfFiles = []
//
//        if let client = DropboxClientsManager.authorizedClient {
//
//            // List contents of app folder
//            _ = client.files.listFolder(path: "/joacky_writer_worksheets").response { response, error in
//
//                if let result = response {
//
//                    print("Folder contents:")
//
//                    for entry in result.entries {
//
//                        print(entry.name)
//
//                        // Check that file is a photo (by file extension)
//
//                        if entry.name.hasSuffix(".pdf") {
//                            // Add photo!
//
//                            self.pdfFiles?.append(entry)
//                        }
//                    }
//
//                    self .selectWorksheetAndDoHomework()
//
//                } else {
//                    print("Error: \(error!)")
//                }
//            }
//        }
//    }
    
//    func selectWorksheetAndDoHomework() {
//
//        if let client = DropboxClientsManager.authorizedClient {
//
//            let pdfCount = self.pdfFiles!.count as Int
//
//            if pdfCount > 0 {
//
//                var lastPDF = self.pdfFiles!.first
//
//                for entry in self.pdfFiles! {
//
//                    //Get Path for save image in document directory
//                    let destination : (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
//                        return self.getDocumentDirectoryPath(fileName: entry.name)
//                    }
//
//                    //Download Image on destination path
//
//                    client.files.download(path: entry.pathLower!, destination: destination).response { response, error in
//
//                        if let (_, url) = response {
//
//                            print("\(url)")
//
//
//                        }
//                    }
//
//                }
//
//            }
//
//        }
//    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 && indexPath.section == 0 {
            enterName()
        }
        else if indexPath.section == 1 && indexPath.row == 1 {
            if let name = Account.name {
                if name.count > 0 {
                    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "DrawingViewController") as! DrawingViewController
                    vc.text = name
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        } else if (indexPath.section == 1 && indexPath.row == 5) {
            
            let storyboard = UIStoryboard.init(name: "WriteStoryboard", bundle: nil)
            
            let vc = storyboard.instantiateViewController(withIdentifier: "SpeakingCal")
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else if (indexPath.section == 1 && indexPath.row == 6) {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ChoiceCategoryViewController") as! ChoiceCategoryViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
           // self .checkDropBoxLink()
            
        }
        else if (indexPath.section == 1 && indexPath.row == 7) {
            
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TextToSpeechVC")
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if (indexPath.section == 1 && indexPath.row == 8) {
            
//            let storyboard = UIStoryboard.init(name: "WriteStoryboard", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "TempViewController")
//            self.navigationController?.pushViewController(vc, animated: true)
            let storyboard = UIStoryboard.init(name: "WriteStoryboard", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TempViewController")
         // let navigationController = UINavigationController(rootViewController: vc)
          
          vc.modalPresentationStyle = .fullScreen
          self.present(vc, animated: true, completion: nil)
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChildInfoCell", for: indexPath) as! ChildInfoCell
                cell.nameLabel.text = Account.name != nil && Account.name!.count > 0 ? Account.name : "You"
                cell.photoImageView.layer.cornerRadius = Utils.isPad ? 60.0 : 35.0
                cell.photoImageView.layer.borderWidth = Utils.isPad ? 4.0 : 2.0
                cell.photoImageView.layer.borderColor = UIColor.skyBlue.cgColor
                cell.photoImageView.layer.masksToBounds = true
                if let recognizers = cell.photoImageView.gestureRecognizers {
                    for rec in recognizers {
                        cell.photoImageView.removeGestureRecognizer(rec)
                    }
                }
                let rec = UITapGestureRecognizer.init(target: self,
                                                      action: #selector(HomeViewController.selectPhoto))
                cell.photoImageView.addGestureRecognizer(rec)
                if let photo = Account.photo {
                    cell.photoImageView.image = photo
                }
                else {
                    cell.photoImageView.image = UIImage.init(named: "I am")
                }
                return cell
            }
            else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InstructionsCell", for: indexPath)
                cell.contentView.backgroundColor = UIColor.init(red: 0.05, green: 0.3, blue: 0.5, alpha: 1.0)
                cell.contentView.layer.cornerRadius = 20.0
                cell.contentView.layer.borderWidth = Utils.isPad ? 4.0 : 2.0
                cell.contentView.layer.borderColor = UIColor.wood.cgColor
                cell.contentView.layer.masksToBounds = true
                return cell
            }
        }
        else {
            var identifier = ""
            switch indexPath.row {
            case 0: identifier = "LetterCell"
            case 1: identifier = "NameCell"
            case 2: identifier = "NumberCell"
            case 3: identifier = "WordsCell"
            case 4: identifier = "SentencesCell"
            case 5: identifier = "MathCell"
            case 6: identifier = "JournalCell"
            case 7: identifier = "TextToSpeechCell"
            case 8: identifier = "WriteBoardCell"
            default:
                break
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,
                                                          for: indexPath) as! PuzzleCell
            cell.titleLabel.font = UIFont.init(name: "BadaBoom BB",
                                               size: Utils.isPad ? 40.0 : 20.0)
            return cell
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            let offset: CGFloat = Utils.isPad ? 20.0 : 10.0
            return UIEdgeInsets.init(top: Utils.isLandscapeMode == true ? 0.0 : offset / 2.0,
                                     left: offset,
                                     bottom: Utils.isLandscapeMode == true ? 0.0 : offset / 2.0,
                                     right: offset)
        }
        else {
            let offset: CGFloat = Utils.isPad ? 50.0 : 25.0
            if self.view.bounds.height <= 667 && Utils.isPad == false {
                return UIEdgeInsets.init(top: offset,
                                         left: self.view.bounds.size.width * 0.125,
                                         bottom: offset,
                                         right: self.view.bounds.size.width * 0.125)
            }
            return UIEdgeInsets.init(top: offset,
                                     left: offset,
                                     bottom: offset,
                                     right: offset)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Utils.isPad ? 30.0 : 15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Utils.isPad ? 30.0 : 15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                if Utils.isPad == true {
                    return CGSize.init(width: 280.0, height: 260.0)
                }
                return CGSize.init(width: 250.0, height: 105.0)
            }
            else {
                if Utils.isPad == true {
                    return CGSize.init(width: 370.0, height: 180.0)
                }
                return CGSize.init(width: 220.0, height: 100.0)
            }
        }
        else {
            if Utils.isPad == true {
                return CGSize.init(width: 200.0, height: 260.0)
            }
            return CGSize.init(width: 100.0, height: 130.0)
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
            Account.photo = pickedImage
            collectionView.reloadData()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let set = NSCharacterSet(charactersIn: "ABCDEFGHIJKLMONPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ").inverted
        return string.rangeOfCharacter(from: set) == nil
    }
    
    // MARK: - Utility Function
    
    //to get document directory path
    func getDocumentDirectoryPath(fileName:String) -> URL {
        
        let fileManager = FileManager.default
        
        let directoryURL = fileManager.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: .userDomainMask)[0]
        
        let UUID = NSUUID().uuidString
        
        let pathComponent = "\(UUID)-\(fileName)"
        
        return directoryURL.appendingPathComponent(pathComponent)
    }
}
