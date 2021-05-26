//
//  ArithmeticExpressionViewController.swift
//  JoackyWriter
//
//  Created by Ilya Kulbakin on 14/04/2017.
//  Copyright © 2017 Jenex Software. All rights reserved.
//

import UIKit

enum ArithmeticMode: String {
    case add = "Add"
    case substract = "Substract"
}

class ArithmeticExpressionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var mode: ArithmeticMode = .add
    
    var firstNumber: Int?
    var secondNumber: Int?
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var expressionView: ArithmeticExpressionView!
    @IBOutlet var startButton: UIButton!
    
    private var numbers: [Int] {
        var result = [Int]()
        for i in 0...9 {
            result.append(i)
        }
        return result
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = mode.rawValue
        startButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutExpression()
        Sounds.default.playMusic()
    }
    
    func layoutExpression() {
        expressionView.mode = mode
        expressionView.firstNumber = firstNumber
        expressionView.secondNumber = secondNumber
        if expressionView.getAnswer() == true {
            startButton.isEnabled = true
            startButton.titleLabel?.layer.addBlinkAnimtion()
            startButton.titleLabel?.layer.addGlowAnimtion(glowColor: UIColor.skyBlue)
        }
        else {
            startButton.isEnabled = false
            startButton.titleLabel?.layer.removeAllAnimations()
            startButton.titleLabel?.layer.shadowOpacity = 0.0
        }
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            firstNumber = numbers[indexPath.row]
            layoutExpression()
            collectionView.reloadData()
        }
        else {
            if let firstNumber = firstNumber {
                if mode == .substract && numbers[indexPath.row] > firstNumber {
                    return
                }
            }
            secondNumber = numbers[indexPath.row]
            layoutExpression()
            collectionView.reloadData()
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DrawItemCell",
                                                      for: indexPath) as! DrawItemCell
        cell.textLabel.text = "\(numbers[indexPath.row])"
        if indexPath.section == 1, let firstNumber = firstNumber,
            mode == .substract, numbers[indexPath.row] > firstNumber {
            cell.textLabel.textColor = UIColor.lightGray
            cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
        }
        else if (numbers[indexPath.row] == firstNumber && indexPath.section == 0) ||
            (numbers[indexPath.row] == secondNumber && indexPath.section == 1) {
            cell.textLabel.textColor = UIColor.skyBlue
            cell.contentView.layer.borderColor = UIColor.skyBlue.cgColor
        }
        else {
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
            cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
        }
        cell.contentView.layer.cornerRadius = Utils.isPad ? 30.0 : 20.0
        cell.contentView.layer.borderWidth = 2.0
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
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ExpressionSolvingViewController {
            vc.text = expressionView.expression!
        }
    }
}
