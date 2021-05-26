//
//  ChoiceCategoryViewController.swift
//  Demo
//
//  Created by Vinay Patel on 13/01/21.
//

import UIKit
import UICollectionViewLeftAlignedLayout

class ChoiceCategoryViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var clVw: UICollectionView!
    
   // @IBOutlet weak var btnPhrase : UIButton!
    @IBOutlet weak var lblPhrase: UILabel!
    var arrCategory:[CategoryModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Choice Menu"
        
       // let isPad : Bool = UIDevice.current.userInterfaceIdiom == .pad
        
        
        let layout = UICollectionViewLeftAlignedLayout()
        lblPhrase.font = UIFont.init(name: "RockoFLF", size: Utils.isPad ? 45.0 : 40.0)!
        let offset: CGFloat = Utils.isPad ? 20.0 : 10.0
                layout.sectionInset = UIEdgeInsets(top: offset, left: offset, bottom: offset, right: offset)
                layout.minimumLineSpacing = offset
                layout.minimumInteritemSpacing = offset
                clVw.collectionViewLayout = layout
                
        let lpgr = UILongPressGestureRecognizer.init(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        self.clVw.addGestureRecognizer(lpgr)
        checkForCategoryData()
        
//        let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
//        lpgr.minimumPressDuration = 0.5
//        //lpgr.delegate = self
//        lpgr.delaysTouchesBegan = true
//        clVw?.addGestureRecognizer(lpgr)
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
                    
//                    self.arrCategory.remove(at: indexPath.row)
//                    self.writeDataToUserDefaults()
//                    self.clVw.reloadData()
                    let arrSubcategory = self.checkForSubCategoryUserDefaults()
                    let arr = arrSubcategory.filter({$0.categoryId == self.arrCategory[indexPath.row].id})
                    
                  //  let temArr = NSMutableArray()
                    arr.forEach { model in
                        
                        APPDELEGATE.removeItemForDocument(itemName: model.imgName!, fileExtension: "png")
                        
                    }

                    let arrTemp = arrSubcategory.filter({$0.categoryId != self.arrCategory[indexPath.row].id})
                   
                    if arr.count > 0 {
                        self.writeSubCategoryUserDefaults(arrAllSubCategory: arrTemp)
                    }
                     self.arrCategory.remove(at: indexPath.row)
                    self.writeDataToUserDefaults()
                    self.clVw.reloadData()
//
//                    let arrSubcategory = self.checkForSubCategoryUserDefaults()
//                    let arr = arrSubcategory.filter({$0.categoryId == self.arrCategory[indexPath.row].id})
//
//
//                    let arrTemp = arrSubcategory.filter({$0.categoryId != self.arrCategory[indexPath.row].id})
//                    USERDEFAULT.set(arrTemp, forKey: "subCategory")
//                    USERDEFAULT.synchronize()
//                    self.arrCategory.remove(at: indexPath.row)
//                    self.writeDataToUserDefaults()
//                    self.clVw.reloadData()
                                
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
    
    func checkForSubCategoryUserDefaults() -> [SubCategoryModel] {
        
        guard let arr1 = USERDEFAULT.object(forKey: "subCategory") else {
            return []
        }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: arr1 as Any, options: .prettyPrinted)
        
        let arrSubCategoryModel = try? JSONDecoder().decode([SubCategoryModel].self, from: jsonData!)
        
        return arrSubCategoryModel!

    }
    
    
    @objc func handleLongPress1(gestureRecognizer : UILongPressGestureRecognizer){

        if (gestureRecognizer.state != .ended){
            return
        }

        let p = gestureRecognizer.location(in: self.clVw)

        if let indexPath : NSIndexPath = self.clVw.indexPathForItem(at: p) as NSIndexPath?{
            //do whatever you need to do
            print(indexPath.row)
            
            let actionSheet = UIAlertController(title: "JoackyWriter", message: "Are you sure want to delete it?", preferredStyle: .actionSheet)
            
            if UIDevice.current.userInterfaceIdiom != .pad {
                actionSheet.addAction(UIAlertAction.init(title: "CANCEL", style: .cancel, handler: nil))
            }
                    
            actionSheet.addAction(UIAlertAction.init(title: "DELETE", style: .default, handler: { _ in
                
                
                let arrSubcategory = self.checkForSubCategoryUserDefaults()
                let arr = arrSubcategory.filter({$0.categoryId == self.arrCategory[indexPath.row].id})
                
              //  let temArr = NSMutableArray()
                arr.forEach { model in
                    
                    APPDELEGATE.removeItemForDocument(itemName: model.imgName!, fileExtension: "png")
                    
                }

                let arrTemp = arrSubcategory.filter({$0.categoryId != self.arrCategory[indexPath.row].id})
               
                if arrTemp.count > 0 {
                    self.writeSubCategoryUserDefaults(arrAllSubCategory: arrTemp)
                }
                 self.arrCategory.remove(at: indexPath.row)
                self.writeDataToUserDefaults()
                self.clVw.reloadData()
                            
            }))
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                
                let cell = self.clVw.cellForItem(at: indexPath as IndexPath) as! choiceClVwCell
                
                
               // let sorceRect = CGRect(x: cell.frame.origin.x, y: cell.frame.height, width: cell.frame.width, height: cell.frame.height)
            
                actionSheet.popoverPresentationController?.sourceView = cell
                actionSheet.popoverPresentationController?.sourceRect = cell.vw.frame
            }
            
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    func writeSubCategoryUserDefaults(arrAllSubCategory: [SubCategoryModel]){

                let arr = NSMutableArray()
                arrAllSubCategory.forEach { model in
                    
                    let tempDict =  ["id" : model.id,
                                     "categoryId" : model.categoryId,
                                     "title" : model.title,
                                     "imgName" : model.imgName]
                    arr.add(tempDict)
                    
                }
                
                if arr.count > 0 {
                
                    USERDEFAULT.set(arr, forKey: "subCategory")
                    USERDEFAULT.synchronize()
                    self.clVw.reloadData()

                } else {
                    
                    USERDEFAULT.removeObject(forKey: "subCategory")
                    self.clVw.reloadData()
                }

    }
    func checkForCategoryData() {
        
        clVw.dataSource = self
        clVw.delegate = self
        
        guard let arr1 = USERDEFAULT.object(forKey: "category") else {
            return
        }
        
        
       // let arr1 = USERDEFAULT.object(forKey: "category")
        
        let jsonData = try? JSONSerialization.data(withJSONObject: arr1 as Any, options: .prettyPrinted)
        
        let arrCategoryModel = try? JSONDecoder().decode([CategoryModel].self, from: jsonData!)
        
       // let tempDict = try? JSONDecoder().decode([CategoryModel].self, from: arr1 as! Data)
        print(arr1 as Any)
        self.arrCategory = arrCategoryModel!
        self.clVw.reloadData()

    }
    
    func writeDataToUserDefaults(){
        
       // let dict : NSMutableDictionary = [:]

                let arr = NSMutableArray()
                arrCategory.forEach { model in
                    
                    let tempDict =  ["id" : model.id,
                                     "title" : model.title,
                                     "imgName" : model.imgName]
                    arr.add(tempDict)
                    
                }
                       
        if arr.count > 0 {
        
            USERDEFAULT.set(arr, forKey: "category")
            USERDEFAULT.synchronize()
            self.clVw.reloadData()

        } else {
            
            USERDEFAULT.removeObject(forKey: "category")
            self.clVw.reloadData()
        }

        
    }
    
    func stringArrayToData(stringArray: [String]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: stringArray, options: .prettyPrinted)
    }
    
    @IBAction func btnAdd(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddViewController") as! AddViewController
        
        vc.arrCategory = arrCategory
        vc.isCategory = true
        vc.callBack = { arr in

            let arr1 = USERDEFAULT.object(forKey: "category")
            
            let jsonData = try? JSONSerialization.data(withJSONObject: arr1 as Any, options: .prettyPrinted)
            
            let arrCategoryModel = try? JSONDecoder().decode([CategoryModel].self, from: jsonData!)
            
           // let tempDict = try? JSONDecoder().decode([CategoryModel].self, from: arr1 as! Data)
            print(arr1 as Any)
            self.arrCategory = arrCategoryModel!
            self.clVw.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
       // promptForAnswer()
        
    }
    
    @IBAction func btnChoosePhrasePressed(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PhraseViewController") as! PhraseViewController

        vc.callBack = { strPhrase in
            self.lblPhrase.text = strPhrase
            //self.btnPhrase.setTitle(strPhrase, for: .normal)
        }

        self.navigationController?.pushViewController(vc, animated: true)
    }
//
//    func promptForAnswer() {
//        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
//        ac.addTextField()
//
//        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel) {  [unowned ac] _ in
//
//
//        }
//        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
//            let answer = ac.textFields![0]
//
////            if self.arrPhrases.contains(answer.text!) {
////
////                return
////            }
////
////            self.arrPhrases.append(answer.text!)
//            self.clVw.reloadData()
//            self.writePlistFile()
//
//            // do something interesting with "answer" here
//        }
//
//        ac.addAction(submitAction)
//        ac.addAction(cancelAction)
//        present(ac, animated: true)
//    }
}

extension ChoiceCategoryViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrCategory.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = clVw.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! choiceClVwCell
        cell.result = arrCategory[indexPath.row]
        //cell.lblTitle.text = arrPhrases[indexPath.row]
        
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
            return CGSize.init(width: 200.0, height: 200.0)
        }
        return CGSize.init(width: 100.0, height: 100.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChoiceSubCategoryViewController") as! ChoiceSubCategoryViewController
        vc.strPhrase = lblPhrase.text!//btnPhrase.titleLabel!.text!
        vc.strTitle = arrCategory[indexPath.row].title!
        vc.strCategoryID = arrCategory[indexPath.row].id!
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        }
}

class choiceClVwCell: UICollectionViewCell {
    
    @IBOutlet weak var vw: UIView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var imgVw: UIImageView!
    
    var result : CategoryModel? {
        
        didSet {
            guard let model = result else {
                return
            }
            
            lblTitle.text = model.title
            imgVw.image = APPDELEGATE.loadImageFromDocumentDirectory(nameOfImage: model.imgName!)
            lblTitle.font = UIFont.init(name: "RockoFLF",
                                              size: Utils.isPad ? 36.0 : 18.0)
            self.contentView.layer.cornerRadius = Utils.isPad ? 30.0 : 15.0
            self.contentView.layer.borderWidth = Utils.isPad ? 4.0 : 2.0
            self.contentView.layer.borderColor = UIColor.lightGray.cgColor
            self.contentView.layer.masksToBounds = true
        }
    }
    
}
