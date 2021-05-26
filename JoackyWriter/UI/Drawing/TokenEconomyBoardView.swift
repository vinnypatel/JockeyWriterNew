//
//  TokenEconomyBoardView.swift
//  JoackyWriter
//
//  Created by Ilya Kulbakin on 21/02/2017.
//  Copyright © 2017 Jenex Software. All rights reserved.
//

import UIKit

class TokenEconomyBoardView: UIView {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var rewardLabel: UILabel!
    @IBOutlet var rewardView: UIView!
    @IBOutlet var rewardImageView: UIImageView!
    @IBOutlet var photoImageView: UIImageView!
    
    @IBOutlet var photoImageViewTopSpace: NSLayoutConstraint!
    @IBOutlet var spacesFromScoreToReward: [NSLayoutConstraint]!
    
    var tokensCount = 5 {
        didSet {
            layoutScore()
        }
    }
    
    var score = 0 {
        didSet {
            layoutScore()
        }
    }
    
    lazy var scoreImageViews: [UIImageView] = {
        var result = [UIImageView]()
        for subview in self.subviews {
            guard subview != self.rewardImageView, subview != self.photoImageView else {
                continue
            }
            if let imageView = subview as? UIImageView {
                result.append(imageView)
            }
        }
        return result
    }()
    
    // MARK: - Setters
    
    func setReward(_ reward: String) {
        rewardImageView.image = Utils.image(for: reward)
        rewardLabel.text = reward
    }
    
    func setName(name: String?) {
        if let name = Account.name {
            if name.count > 0 {
                self.nameLabel.text = name
                self.textLabel.text = "is working for:"
            }
            else {
                self.nameLabel.text = "You"
                self.textLabel.text = "are working for:"
            }
        }
        else {
            self.nameLabel.text = "You"
            self.textLabel.text = "are working for:"
        }
    }
    
    
    // MARK: - Layout
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = 4.0
        layer.borderWidth = Utils.isPad ? 1.0 : 0.5
        layer.borderColor = UIColor.darkGray.cgColor
        rewardView.layer.borderWidth = Utils.isPad ? 2.0 : 1.0
        rewardView.layer.borderColor = UIColor.darkBlue.cgColor
        for score in scoreImageViews {
            score.layer.borderWidth = Utils.isPad ? 2.0 : 1.0
            score.layer.borderColor = UIColor.darkBlue.cgColor
        }
    }
    
    private func layoutScore() {
        for (index, imageView) in scoreImageViews.enumerated() {
            if index < tokensCount && tokensCount != 1 {
                spacesFromScoreToReward[index].isActive = true
                imageView.isHidden = false
                if index < score {
                    imageView.image = UIImage.init(named: "Score")
                }
                else {
                    imageView.image = UIImage.init(named: "Dot")
                }
            }
            else {
                imageView.isHidden = true
                spacesFromScoreToReward[index].isActive = false
            }
        }
        if tokensCount == 1 {
            photoImageViewTopSpace.constant = Utils.isPad ? 40.0 : 20.0
        }
        else {
            photoImageViewTopSpace.constant = 8
        }
    }
}
