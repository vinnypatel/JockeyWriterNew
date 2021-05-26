//
//  ChoiceCategoryViewController.swift
//  Demo
//
//  Created by Vinay Patel on 13/01/21.
//

import UIKit
import UICollectionViewLeftAlignedLayout

class ChoiceSubCategoryViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var clVw: UICollectionView!
    var arrSubCategory:[SubCategoryModel] = []
    var arrAllSubCategory:[SubCategoryModel] = []
    var strTitle: String = ""
    var strCategoryID : String = ""
    var strPhrase: String = ""
    
    @IBOutlet weak var btnPhrase: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = strTitle
        // let addBarButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(btnAdd))
        let addBarButton = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(btnAdd))
        self.navigationItem.rightBarButtonItem  = addBarButton
        
        //let isPad : Bool = UIDevice.current.userInterfaceIdiom == .pad
       
        
        let layout = UICollectionViewLeftAlignedLayout()
        let offset: CGFloat = Utils.isPad ? 20.0 : 10.0
        layout.sectionInset = UIEdgeInsets(top: offset, left: offset, bottom: offset, right: offset)
        layout.minimumLineSpacing = offset
        layout.minimumInteritemSpacing = offset
        clVw.collectionViewLayout = layout
        
        
        let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delegate = self
        lpgr.delaysTouchesBegan = true
        clVw?.addGestureRecognizer(lpgr)
        checkForSubCategoryUserDefaults()
        // Do any additional setup after loading the view.
    }
    
    @objc func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer){
        
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
            
            actionSheet.addAction(UIAlertAction.init(title: "DELETE", style: .default, handler: { [self] _ in
                
                let model = self.arrSubCategory[indexPath.row]
                if let index = self.arrAllSubCategory.index(where: {$0.id == model.id && $0.categoryId == model.categoryId}) {
                    
                    APPDELEGATE.removeItemForDocument(itemName: self.arrAllSubCategory[index].imgName!, fileExtension: "png")
                    self.arrAllSubCategory.remove(at: index)
                    self.arrSubCategory.remove(at: indexPath.row)
                    self.writeJSONFile()
                    self.clVw.reloadData()
                }
                
                
            }))
            
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                
                let cell = self.clVw.cellForItem(at: indexPath as IndexPath) as! choiceSubCategoryClVwCell
                
                
                // let sorceRect = CGRect(x: cell.frame.origin.x, y: cell.frame.height, width: cell.frame.width, height: cell.frame.height)
                
                actionSheet.popoverPresentationController?.sourceView = cell
                actionSheet.popoverPresentationController?.sourceRect = cell.vw.frame
            }
            
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    func checkForSubCategoryUserDefaults() {
        
        
        clVw.dataSource = self
        clVw.delegate = self
        
        guard let arr1 = USERDEFAULT.object(forKey: "subCategory") else {
            return
        }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: arr1 as Any, options: .prettyPrinted)
        
        let arrSubCategoryModel = try? JSONDecoder().decode([SubCategoryModel].self, from: jsonData!)
        
       // let tempDict = try? JSONDecoder().decode([CategoryModel].self, from: arr1 as! Data)
        print(arr1 as Any)
        self.arrAllSubCategory = arrSubCategoryModel!
        arrSubCategory = arrAllSubCategory.filter({$0.categoryId == strCategoryID})
        self.clVw.reloadData()

    }
    
    func writeJSONFile(){

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

    @objc func btnAdd() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddViewController") as! AddViewController
        
        vc.arrSubCategory = arrAllSubCategory
        vc.isCategory = false
        vc.strCategoryId = strCategoryID
        vc.callBack1 = { arr in
            
            let arr1 = USERDEFAULT.object(forKey: "subCategory")
            
            let jsonData = try? JSONSerialization.data(withJSONObject: arr1 as Any, options: .prettyPrinted)
            
            let arrCategoryModel = try? JSONDecoder().decode([SubCategoryModel].self, from: jsonData!)
            
           // let tempDict = try? JSONDecoder().decode([CategoryModel].self, from: arr1 as! Data)
            print(arr1 as Any)
            self.arrAllSubCategory = arrCategoryModel!
//            self.clVw.reloadData()
//            self.arrAllSubCategory = arr
            self.arrSubCategory = self.arrAllSubCategory.filter({$0.categoryId == self.strCategoryID})
            self.clVw.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
        // promptForAnswer()
        
    }

}

extension ChoiceSubCategoryViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrSubCategory.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = clVw.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! choiceSubCategoryClVwCell
        cell.result = arrSubCategory[indexPath.row]
        //cell.lblTitle.text = arrPhrases[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        vc.strPhrase = strPhrase
        vc.strText = arrSubCategory[indexPath.row].title!
        vc.img = APPDELEGATE.loadImageFromDocumentDirectory(nameOfImage: arrSubCategory[indexPath.row].imgName!)
        self.navigationController?.pushViewController(vc, animated: true)
        
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
    
    
}

class choiceSubCategoryClVwCell: UICollectionViewCell {
    
    @IBOutlet weak var vw: UIView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var imgVw: UIImageView!
    
    
    var result : SubCategoryModel? {
        
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
