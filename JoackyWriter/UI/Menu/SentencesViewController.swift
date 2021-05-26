//
//  SentencesViewController.swift
//  JoackyWriter
//
//  Created by Ilya Kulbakin on 27/02/2017.
//  Copyright © 2017 Jenex Software. All rights reserved.
//

import UIKit
import UICollectionViewLeftAlignedLayout

class SentencesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    static let sentences: [String] = ["I want", "I am", "I like", "I see", "The green", "The big", "My small"]
    
    @IBOutlet var collectionView: UICollectionView!
    
    private var allSentences: [String] {
        var result = SentencesViewController.sentences
        if let custom = Account.sightWords {
            result.append(contentsOf: custom)
        }
        return result
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let layout = UICollectionViewLeftAlignedLayout()
        let offset: CGFloat = Utils.isPad ? 20.0 : 10.0
        layout.sectionInset = UIEdgeInsets(top: offset, left: offset, bottom: offset, right: offset)
        layout.minimumLineSpacing = offset
        layout.minimumInteritemSpacing = offset
        collectionView.collectionViewLayout = layout
        
        let lpgr = UILongPressGestureRecognizer.init(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        self.collectionView.addGestureRecognizer(lpgr)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        collectionView.reloadData()
        Sounds.default.playMusic()
        
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DrawingViewController") as! DrawingViewController
        vc.isSightWords = true
        vc.text = allSentences[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return allSentences.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentenceCell",
                                                      for: indexPath) as! SentenceCell
        let sentence = allSentences[indexPath.row]
        cell.sentenceLabel.text = sentence
        cell.sentenceLabel.font = UIFont.init(name: "RockoFLF", size: Utils.isPad ? 45.0 : 22.5)!
        cell.pictureImageView.image = Utils.image(for: sentence)
        cell.contentView.layer.cornerRadius = Utils.isPad ? 30.0 : 15.0
        cell.contentView.layer.borderWidth = Utils.isPad ? 4.0 : 2.0
        cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
        cell.contentView.layer.masksToBounds = true
        return cell
        
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let font = UIFont.init(name: "RockoFLF", size: Utils.isPad ? 45.0 : 22.5)!
        let stringWidth = allSentences[indexPath.row].size(withFont: font).width
        return CGSize.init(width: stringWidth + (Utils.isPad ? 130 : 90), height: Utils.isPad ? 100 : 60)
        
    }
    
    // MARK: - Actions
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        
        if (gestureRecognizer.state != .began) {
            return
        }
        let collectionViewTapPosition = gestureRecognizer.location(in: self.collectionView)
        
        if let indexPath = collectionView.indexPathForItem(at: collectionViewTapPosition) {
            
            if indexPath.row >= SentencesViewController.sentences.count {
                let ac = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
                ac.addAction(UIAlertAction.init(title: "Edit", style: .default, handler: { action in
                    self.performSegue(withIdentifier: "Edit", sender: self.allSentences[indexPath.row])
                }))
                ac.addAction(UIAlertAction.init(title: "Delete", style: .destructive, handler: { action in
                    if Account.removeSightWords(self.allSentences[indexPath.row]) == true {
                        self.collectionView.reloadData()
                    }
                }))
                if Utils.isPad == false {
                    ac.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { action in
                        
                    }))
                }
                let viewTapPosition = gestureRecognizer.location(in: self.view)
                ac.popoverPresentationController?.sourceView = self.view
                ac.popoverPresentationController?.sourceRect = CGRect.init(origin: viewTapPosition, size: CGSize.init(width: 1.0, height: 1.0))
                self.present(ac, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CustomWordsViewController {
            vc.isSightWords = true
            if segue.identifier == "Edit" {
                vc.originalString = sender as? String
            }
        }
    }
}
