//
//  NumbersViewController.swift
//  JoackyWriter
//
//  Created by Ilya Kulbakin on 24/02/2017.
//  Copyright © 2017 Jenex Software. All rights reserved.
//

import UIKit

class NumbersViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var numbers: [Int] {
        
        var result = [Int]()
        
        for i in 1...100 {
            
            result.append(i)
            
        }
        
        return result
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Sounds.default.playMusic()
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DrawingViewController") as! DrawingViewController
        vc.text = "\(numbers[indexPath.row])"
        vc.onlyNumber = true
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DrawItemCell",
                                                      for: indexPath) as! DrawItemCell
        switch (indexPath.row % 8) {
        case 0:
            cell.textLabel.textColor = UIColor.red
        case 1:
            cell.textLabel.textColor = UIColor.orange
        case 2:
            cell.textLabel.textColor = UIColor.brown
        case 3:
            cell.textLabel.textColor = UIColor.darkBlue
        case 4:
            cell.textLabel.textColor = UIColor.darkGreen
        case 5:
            cell.textLabel.textColor = UIColor.sea
        case 6:
            cell.textLabel.textColor = UIColor.darkYellow
        default:
            cell.textLabel.textColor = UIColor.purple
        }
        cell.textLabel.font = UIFont.init(name: "RockoFLF",
                                          size: Utils.isPad ? 36.0 : 23.0)
        cell.textLabel.text = "\(numbers[indexPath.row])"
        cell.contentView.layer.cornerRadius = Utils.isPad ? 30.0 : 20.0
        cell.contentView.layer.borderWidth = 2.0
        cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
        cell.contentView.backgroundColor = UIColor.white
        cell.contentView.clipsToBounds = true
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if Utils.isPad == true {
            return CGSize.init(width: 60.0, height: 60.0)
        }
        return CGSize.init(width: 40.0, height: 40.0)
    }
}
