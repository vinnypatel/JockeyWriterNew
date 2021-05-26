//
//  LettersViewController.swift
//  JoackyWriter
//
//  Created by Ilya Kulbakin on 22/02/2017.
//  Copyright © 2017 Jenex Software. All rights reserved.
//

import UIKit

class LettersViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let uppercase: [Character] = ["A", "B", "C", "D", "E", "F", "G", "H",
                                          "I", "J", "K", "L", "M", "N", "O", "P",
                                          "Q", "R", "S", "T", "U", "V", "W", "X",
                                          "Y", "Z"]
    
    private let lowercase: [Character] = ["a", "b", "c", "d", "e", "f", "g", "h",
                                          "i", "j", "k", "l", "m", "n", "o", "p",
                                          "q", "r", "s", "t", "u", "v", "w", "x",
                                          "y", "z"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Sounds.default.playMusic()
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var letter: Character = "A"
        if indexPath.section == 0 {
            letter = uppercase[indexPath.row]
        }
        else {
            letter = lowercase[indexPath.row]
        }
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DrawingViewController") as! DrawingViewController
        vc.text = String.init(letter)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return uppercase.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DrawItemCell",
                                                      for: indexPath) as! DrawItemCell
        switch (indexPath.row % 8) {
        case 0: cell.textLabel.textColor = UIColor.red
        case 1: cell.textLabel.textColor = UIColor.orange
        case 2: cell.textLabel.textColor = UIColor.brown
        case 3: cell.textLabel.textColor = UIColor.darkBlue
        case 4: cell.textLabel.textColor = UIColor.darkGreen
        case 5: cell.textLabel.textColor = UIColor.sea
        case 6: cell.textLabel.textColor = UIColor.darkYellow
        default: cell.textLabel.textColor = UIColor.purple
        }
        cell.textLabel.font = UIFont.init(name: "RockoFLF",
                                          size: Utils.isPad ? 40.0 : 25.0)
        cell.contentView.layer.cornerRadius = Utils.isPad ? 30.0 : 20.0
        cell.contentView.layer.borderWidth = 2.0
        cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
        cell.contentView.backgroundColor = UIColor.white
        cell.contentView.clipsToBounds = true
        if indexPath.section == 0 {
            cell.textLabel.text = String.init(uppercase[indexPath.row])
        }
        else {
            cell.textLabel.text = String.init(lowercase[indexPath.row])
        }
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
