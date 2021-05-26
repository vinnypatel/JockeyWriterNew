//
//  RewardsViewController.swift
//  JoackyWriter
//
//  Created by Ilya Kulbakin on 28/02/2017.
//  Copyright © 2017 Jenex Software. All rights reserved.
//

import UIKit

class RewardsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!
    
    static let defaultRewards: [String] = ["cookie", "TV", "bubble", "chips", "balloon",
                                           "juice", "trampoline", "sand box", "ipad", "break"]
    
    private var rewards: [String] {
        var result = RewardsViewController.defaultRewards
        if let custom = Account.rewards {
            result.append(contentsOf: custom)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
            self.collectionView.collectionViewLayout.invalidateLayout()
        }) { context in }
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Account.reward = rewards[indexPath.row]
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rewards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RewardCell",
                                                      for: indexPath) as! CardCell
        cell.cardImageView.image = Utils.image(for: rewards[indexPath.row])
        cell.cardImageView.contentMode = indexPath.row >= RewardsViewController.defaultRewards.count ? .scaleAspectFill : .scaleAspectFit
        cell.titleLabel.font = UIFont.init(name: "RockoFLF",
                                          size: Utils.isPad ? 36.0 : 18.0)
        cell.titleLabel.text = rewards[indexPath.row]
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
            if indexPath.row >= RewardsViewController.defaultRewards.count {
                let ac = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
                ac.addAction(UIAlertAction.init(title: "Edit", style: .default, handler: { action in
                    self.performSegue(withIdentifier: "Edit", sender: self.rewards[indexPath.row])
                }))
                ac.addAction(UIAlertAction.init(title: "Delete", style: .destructive, handler: { action in
                    if Account.removeSightWords(self.rewards[indexPath.row]) == true {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CustomRewardViewController {
            if segue.identifier == "Edit" {
                vc.originalString = sender as? String
            }
        }
    }
}
