//
//  ContactSelectionViewController.swift
//  JoackyWriter
//
//  Created by Vinay Patel on 29/01/21.
//  Copyright © 2021 Jenex Software. All rights reserved.
//

import UIKit
import UICollectionViewLeftAlignedLayout
import MessageUI

class ContactSelectionViewController: UIViewController {
    
    @IBOutlet weak var clVw: UICollectionView!
    
    var arrContact: [ContactModel] = []
    var strMessageText: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Contact Selection"
        let addBarButton = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(btnAdd))
              self.navigationItem.rightBarButtonItem  = addBarButton
        
        let layout = UICollectionViewLeftAlignedLayout()
            //   lblPhrase.font = UIFont.init(name: "RockoFLF", size: Utils.isPad ? 45.0 : 40.0)!
               let offset: CGFloat = Utils.isPad ? 20.0 : 10.0
                       layout.sectionInset = UIEdgeInsets(top: offset, left: offset, bottom: offset, right: offset)
                       layout.minimumLineSpacing = offset
                       layout.minimumInteritemSpacing = offset
                       clVw.collectionViewLayout = layout
                       
               let lpgr = UILongPressGestureRecognizer.init(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
               lpgr.minimumPressDuration = 0.5
               lpgr.delaysTouchesBegan = true
               self.clVw.addGestureRecognizer(lpgr)
        checkForContactData()
        
        // Do any additional setup after loading the view.
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
           if (gestureRecognizer.state != .began) {
               return
           }
           let collectionViewTapPosition = gestureRecognizer.location(in: self.clVw)
           if let indexPath = clVw.indexPathForItem(at: collectionViewTapPosition) {
              // if indexPath.row >= WordsViewController.defaultWords.count {
                   
                   let actionSheet = UIAlertController(title: "JoackyWriter", message: "Are you sure want to delete it?", preferredStyle: .actionSheet)
                   
                   if UIDevice.current.userInterfaceIdiom != .pad {
                       actionSheet.addAction(UIAlertAction.init(title: "CANCEL", style: .cancel, handler: nil))
                   }
                           
                   actionSheet.addAction(UIAlertAction.init(title: "DELETE", style: .default, handler: { _ in
     
                    APPDELEGATE.removeItemForDocument(itemName: self.arrContact[indexPath.row].imgName!, fileExtension: "png")
                           
                   //    }

                        self.arrContact.remove(at: indexPath.row)
                       self.writeDataToUserDefaults()
                       self.clVw.reloadData()

                   }))
                   
                   
                   if UIDevice.current.userInterfaceIdiom == .pad {
                       
                       let cell = self.clVw.cellForItem(at: indexPath as IndexPath) as! choiceClVwCell
                       
                       
                      // let sorceRect = CGRect(x: cell.frame.origin.x, y: cell.frame.height, width: cell.frame.width, height: cell.frame.height)
                   
                       actionSheet.popoverPresentationController?.sourceView = cell
                       actionSheet.popoverPresentationController?.sourceRect = cell.lblTitle.frame
                   }
                   
                   self.present(actionSheet, animated: true, completion: nil)
                  // let ac = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
   //                ac.addAction(UIAlertAction.init(title: "Edit", style: .default, handler: { action in
   //                    self.performSegue(withIdentifier: "EditWord", sender: self.words[indexPath.row])
   //                }))
   //                ac.addAction(UIAlertAction.init(title: "Delete", style: .destructive, handler: { action in
   //                    if Account.removeWord(self.words[indexPath.row]) == true {
   //                        self.collectionView.reloadData()
   //                    }
   //                }))
   //                if Utils.isPad == false {
   //                    ac.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { action in
   //
   //                    }))
   //                }
   //                let viewTapPosition = gestureRecognizer.location(in: self.view)
   //                ac.popoverPresentationController?.sourceView = self.view
   //                ac.popoverPresentationController?.sourceRect = CGRect.init(origin: viewTapPosition, size: CGSize.init(width: 1.0, height: 1.0))
   //                self.present(ac, animated: true, completion: nil)
              // }
           }
       }
    
    func writeDataToUserDefaults(){
        
       // let dict : NSMutableDictionary = [:]

                let arr = NSMutableArray()
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
            self.clVw.reloadData()

        } else {
            
            USERDEFAULT.removeObject(forKey: "contact")
            self.clVw.reloadData()
        }

        
    }
    
    @objc func btnAdd() {
           
           let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddContactViewController") as! AddContactViewController
           
           vc.arrContact = arrContact
           vc.callBack = { arr in
               
               let arr1 = USERDEFAULT.object(forKey: "contact")
               
               let jsonData = try? JSONSerialization.data(withJSONObject: arr1 as Any, options: .prettyPrinted)
               
               let arrContactModel = try? JSONDecoder().decode([ContactModel].self, from: jsonData!)

               print(arr1 as Any)
               self.arrContact = arrContactModel!

               self.clVw.reloadData()
           }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            vc.view.backgroundColor = .white
            vc.modalPresentationStyle = .popover
            vc.preferredContentSize = CGSize(width: 400, height: 400)
            vc.popoverPresentationController?.sourceView = self.view
            vc.popoverPresentationController?.sourceRect = CGRect(
                x: self.view.frame.width - 50,
                y: 50,
                width: 1,
                height: 1)
        } else {
            
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
        }
       
        self.present(vc, animated: true, completion: nil)
          // self.navigationController?.pushViewController(vc, animated: true)
           // promptForAnswer()
           
       }
    
    func checkForContactData() {
        
        clVw.dataSource = self
        clVw.delegate = self
        
        guard let arr1 = USERDEFAULT.object(forKey: "contact") else {
            return
        }
        // let arr1 = USERDEFAULT.object(forKey: "category")
        
        let jsonData = try? JSONSerialization.data(withJSONObject: arr1 as Any, options: .prettyPrinted)
        
        let arrContactModel = try? JSONDecoder().decode([ContactModel].self, from: jsonData!)
        
        // let tempDict = try? JSONDecoder().decode([CategoryModel].self, from: arr1 as! Data)
        print(arr1 as Any)
        self.arrContact = arrContactModel!
        self.clVw.reloadData()
        
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



extension ContactSelectionViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrContact.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.clVw.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ContactClVwCell
        
        cell.result = arrContact[indexPath.row]
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let totalWidth = collectionView.bounds.size.width
        let cellSize = self.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: IndexPath.init(row: 0, section: 0))
        let cellsCount: Int = Int(totalWidth / cellSize.width)
        let freeSpace = totalWidth - CGFloat(cellsCount) * cellSize.width
        let sideOffset = freeSpace / CGFloat(cellsCount + 2)
        return UIEdgeInsets.init(top: sideOffset,
                                 left: sideOffset,
                                 bottom: sideOffset,
                                 right: sideOffset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let totalWidth = collectionView.bounds.size.width
        let cellSize = self.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: IndexPath.init(row: 0, section: 0))
        let cellsCount: Int = Int(totalWidth / cellSize.width)
        let freeSpace = totalWidth - CGFloat(cellsCount) * cellSize.width
        let sideOffset = freeSpace / CGFloat(cellsCount + 2)
        return sideOffset - 0.1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let totalWidth = collectionView.bounds.size.width
        let cellSize = self.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: IndexPath.init(row: 0, section: 0))
        let cellsCount: Int = Int(totalWidth / cellSize.width)
        let freeSpace = totalWidth - CGFloat(cellsCount) * cellSize.width
        let sideOffset = freeSpace / CGFloat(cellsCount + 2)
        return sideOffset - 0.1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if Utils.isPad == true {
            return CGSize.init(width: 300.0, height: 300.0)
        }
        return CGSize.init(width: clVw.frame.size.width/2 - 20, height: clVw.frame.size.width/2 - 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
        let messageVC = MFMessageComposeViewController()
               messageVC.body = strMessageText
                messageVC.recipients = [arrContact[indexPath.row].contactNumber!]
               messageVC.messageComposeDelegate = self
               self.present(messageVC, animated: true, completion: nil)
        
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChoiceSubCategoryViewController") as! ChoiceSubCategoryViewController
//        vc.strPhrase = lblPhrase.text!//btnPhrase.titleLabel!.text!
//        vc.strTitle = arrCategory[indexPath.row].title!
//        vc.strCategoryID = arrCategory[indexPath.row].id!
        
      //  self.navigationController?.pushViewController(vc, animated: true)
        
        }
    
    
}


class ContactClVwCell: UICollectionViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var imgVw: UIImageView!
    
    var result : ContactModel? {
        
        didSet {
            
            guard let model = result else {
                return
            }
            
            
            lblNumber.text = model.contactNumber
            imgVw.image = APPDELEGATE.loadImageFromDocumentDirectory(nameOfImage: model.imgName!)
            
            lblName.text = model.name
            lblName.font = UIFont.init(name: "RockoFLF", size: Utils.isPad ? 36.0 : 18.0)
            lblNumber.text = model.contactNumber
            lblNumber.font = UIFont.init(name: "RockoFLF", size: Utils.isPad ? 36.0 : 15.0)
            imgVw.image = APPDELEGATE.loadImageFromDocumentDirectory(nameOfImage: model.imgName!)
            imgVw.layer.cornerRadius = Utils.isPad ? 100 : 60
            imgVw.layer.borderWidth = Utils.isPad ? 4.0 : 2.0
            imgVw.layer.borderColor = UIColor.lightGray.cgColor
            imgVw.layer.masksToBounds = true
//                        self.contentView.layer.cornerRadius = Utils.isPad ? 30.0 : 15.0
//                        self.contentView.layer.borderWidth = Utils.isPad ? 4.0 : 2.0
//                        self.contentView.layer.borderColor = UIColor.lightGray.cgColor
//                        self.contentView.layer.masksToBounds = true
            
        }
    }
}


extension  ContactSelectionViewController : MFMessageComposeViewControllerDelegate {

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
        case .cancelled:
            print("Message was cancelled")
        case .failed:
            
            print("Message failed")
        case .sent:
            print("Message was sent")
            self.dismiss(animated: true, completion: nil)
        default:
            return
        }
        dismiss(animated: true, completion: nil)
    }
}
