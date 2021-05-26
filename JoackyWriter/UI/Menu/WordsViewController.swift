//
//  WordsViewController.swift
//  JoackyWriter
//
//  Created by Ilya Kulbakin on 26/02/2017.
//  Copyright © 2017 Jenex Software. All rights reserved.
//

import UIKit

class WordsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!
    
    static let defaultWords: [String] = ["backpack", "bed", "bike", "book", "car",
                                         "chair", "couch", "crayon", "door", "eyes",
                                         "jacket", "pencil", "pillow", "shoes",
                                         "sock", "spoon", "table",
                                         "toothbrush"]
    
    private var words: [String] {
        var result = WordsViewController.defaultWords
        if let customWords = Account.words {
            result.append(contentsOf: customWords)
        }
        return result
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let lpgr = UILongPressGestureRecognizer.init(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        self.collectionView.addGestureRecognizer(lpgr)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }) { context in
            
        }
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Sounds.default.playMusic()
        collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DrawingViewController") as! DrawingViewController
        vc.text = words[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return words.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WordCell",
                                                      for: indexPath) as! CardCell
        cell.cardImageView.image = Utils.image(for: words[indexPath.row])
        cell.cardImageView.contentMode = indexPath.row >= WordsViewController.defaultWords.count ? .scaleAspectFill : .scaleAspectFit
        cell.titleLabel.font = UIFont.init(name: "RockoFLF",
                                          size: Utils.isPad ? 36.0 : 18.0)
        cell.titleLabel.text = words[indexPath.row]
        cell.contentView.layer.cornerRadius = Utils.isPad ? 30.0 : 15.0
        cell.contentView.layer.borderWidth = Utils.isPad ? 4.0 : 2.0
        cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
        cell.contentView.layer.masksToBounds = true
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
    
    // MARK: - Actions
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != .began) {
            return
        }
        let collectionViewTapPosition = gestureRecognizer.location(in: self.collectionView)
        if let indexPath = collectionView.indexPathForItem(at: collectionViewTapPosition) {
            if indexPath.row >= WordsViewController.defaultWords.count {
                let ac = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
                ac.addAction(UIAlertAction.init(title: "Edit", style: .default, handler: { action in
                    self.performSegue(withIdentifier: "EditWord", sender: self.words[indexPath.row])
                }))
                ac.addAction(UIAlertAction.init(title: "Delete", style: .destructive, handler: { action in
                    if Account.removeWord(self.words[indexPath.row]) == true {
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
        if segue.identifier == "EditWord" {
            if let vc = segue.destination as? CustomWordsViewController {
                vc.originalString = (sender as! String)
            }
        }
    }
}
