//
//  ViewController.swift
//  Demo
//
//  Created by Vinay Patel on 13/01/21.
//

import UIKit
import UICollectionViewLeftAlignedLayout

class PhraseViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var clVw: UICollectionView!
    var arrPhrase: [String] = []
    var arrPhrases: [String] = []
    
    var callBack: ((String)->())?
    var font : UIFont!
    
    let iPad : Bool = UIDevice.current.userInterfaceIdiom == .pad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        arrPhrase = ["I want", "I don't want", "I like", "I don't like", "I want to go to the"]
        self.title = "Phrases"
        
        font = UIFont(name: "RockoFLF" , size: Utils.isPad ? 45.0 : 22.5 )
        let layout = UICollectionViewLeftAlignedLayout()
        let offset: CGFloat = Utils.isPad ? 20.0 : 10.0
                        layout.sectionInset = UIEdgeInsets(top: offset, left: offset, bottom: offset, right: offset)
                        layout.minimumLineSpacing = offset
                        layout.minimumInteritemSpacing = offset
                        clVw.collectionViewLayout = layout
        
        checkForPlistFile(strArr: [] as! [String])
        
        
        let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delegate = self
        lpgr.delaysTouchesBegan = true
        clVw?.addGestureRecognizer(lpgr)
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
                    
            actionSheet.addAction(UIAlertAction.init(title: "DELETE", style: .default, handler: { _ in
                
                self.arrPhrases.remove(at: indexPath.row)
                self.writePlistFile()
                self.clVw.reloadData()
                            
            }))
            
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                
                let cell = self.clVw.cellForItem(at: indexPath as IndexPath) as! clvwCell
                
                
               // let sorceRect = CGRect(x: cell.frame.origin.x, y: cell.frame.height, width: cell.frame.width, height: cell.frame.height)
            
                actionSheet.popoverPresentationController?.sourceView = cell
                actionSheet.popoverPresentationController?.sourceRect = cell.vw.frame
            }
            
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    func checkForPlistFile(strArr: [String]) {
        
        let dict : NSMutableDictionary = [:]
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let path = paths.appending("/phrase.plist")
        let fileManager = FileManager.default
        if (!(fileManager.fileExists(atPath: path)))
        {
            let bundle = Bundle.main.path(forResource: "phrase", ofType: "plist")
            try? fileManager.copyItem(atPath: bundle!, toPath: path)
            dict.setObject(arrPhrase, forKey: "phrase" as NSCopying)
            dict.write(toFile: path, atomically: true)
            arrPhrases.append(contentsOf: arrPhrase)
        } else {
            
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let path = paths.appending("/phrase.plist")
            let save = NSDictionary(contentsOfFile: path)
            let tempArr = save!["phrase"] as? [String]
            arrPhrases.append(contentsOf: tempArr!)
            print(save!)
            
        }
       
        clVw.dataSource = self
        clVw.delegate = self
        clVw.reloadData()

    }
    
    func writePlistFile(){
        
        let dict : NSMutableDictionary = [:]
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
                    let path = paths.appending("/phrase.plist")
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path)
                {
//                    let bundle = Bundle.main.path(forResource: "data", ofType: "plist")
//                    try? fileManager.copyItem(atPath: bundle!, toPath: path)
                    dict.setObject(arrPhrases, forKey: "phrase" as NSCopying)
                    dict.write(toFile: path, atomically: true)
                    //arrPhrases.append(contentsOf: arrPhrase)
                }
        
    }
    
    func stringArrayToData(stringArray: [String]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: stringArray, options: .prettyPrinted)
    }
    
    @IBAction func btnAdd(_ sender: Any) {
        
        
        promptForAnswer()
    }
    
    func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel) {  [unowned ac] _ in
            
            
        }
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0]
            
            if self.arrPhrases.contains(answer.text!) {
                
                return
            }
            
            self.arrPhrases.append(answer.text!)
            self.clVw.reloadData()
            self.writePlistFile()
                        
            // do something interesting with "answer" here
        }

        ac.addAction(submitAction)
        ac.addAction(cancelAction)
        present(ac, animated: true)
    }
}

extension PhraseViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrPhrases.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = clVw.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! clvwCell
        cell.lblTitle.text = arrPhrases[indexPath.row]
        cell.lblTitle.font = font//UIFont.systemFont(ofSize: iPad ? 45.0 : 22.5 )
        cell.vw.layer.cornerRadius = 8.0
        cell.vw.layer.borderWidth = 2
        cell.vw.layer.borderColor = UIColor.gray.cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        callBack?(arrPhrases[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
       // let font = UIFont.systemFont(ofSize: iPad ? 45.0 : 22.5 ) //init(name: "RockoFLF", size: Utils.isPad ? 45.0 : 22.5)!
            let stringWidth = arrPhrases[indexPath.row].size(withFont: font).width
            return CGSize.init(width: stringWidth + (iPad ? 130 : 90), height: iPad ? 100 : 60)
            
        }

}

class clvwCell: UICollectionViewCell {
    
    @IBOutlet weak var vw: UIView!
    @IBOutlet weak var lblTitle:UILabel!
    
}


