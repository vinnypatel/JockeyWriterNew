//
//  MathViewController.swift
//  JoackyWriter
//
//  Created by Ilya Kulbakin on 13/04/2017.
//  Copyright © 2017 Jenex Software. All rights reserved.
//

import UIKit

class MathViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }) { context in }
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Sounds.default.playMusic()
    }
    
    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var identifier = ""
        switch indexPath.row {
        case 0: identifier = "AddCell"
        case 1: identifier = "SubstractCell"
        default:
            break
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,
                                                      for: indexPath) as! PuzzleCell
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Utils.isPad ? 30.0 : 15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Utils.isPad ? 30.0 : 15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if Utils.isPad == true {
            return CGSize.init(width: 200.0, height: 260.0)
        }
        return CGSize.init(width: 100.0, height: 130.0)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ArithmeticExpressionViewController {
            if segue.identifier == "Substract" {
                vc.mode = .substract
            }
        }
    }
}
