//
//  SettingsViewController.swift
//  JoackyWriter
//
//  Created by Ilya Kulbakin on 24/03/2017.
//  Copyright © 2017 Jenex Software. All rights reserved.
//

import UIKit
import StepSlider

class SettingsViewController: UITableViewController {
    
    @IBOutlet var numberOfTokensSlider: StepSlider!
    
    @IBOutlet weak var img_setting_Type: UIImageView!
    @IBOutlet weak var img_setting_Trace_hippo: UIImageView!
    @IBOutlet weak var img_setting_Trace_without_hippo: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self .initSetting()
        
        numberOfTokensSlider.index = UInt(Account.numberOfTokens - 1)
        numberOfTokensSlider.labels = ["1", "2", "3", "4", "5"]
        
        let backgrnd = UIImageView.init(frame: self.tableView.frame)
        backgrnd.image = UIImage.init(named: "Background-Notepad")
        backgrnd.contentMode = .scaleAspectFill
        tableView.backgroundView = backgrnd
    }
    
    @IBAction func changeNumberOfTokensValue(sender: StepSlider) {
        Account.numberOfTokens = Int(sender.index) + 1
    }
    
    @IBAction func onSelectOption(_ sender: UIButton) {
        
        let butTag = sender.tag - 100
        
        img_setting_Type.isHidden = true
        img_setting_Trace_hippo.isHidden = true
        img_setting_Trace_without_hippo.isHidden = true
        
        if butTag == 0 {
            
            img_setting_Type.isHidden = false
            
        }
        else if butTag == 1 {
            
            img_setting_Trace_hippo.isHidden = false
            
        }
        else if butTag == 2 {
            
            img_setting_Trace_without_hippo.isHidden = false
            
        }
        
        Account.writerOption = Int(butTag)
    }
    
    func initSetting() {
        
        img_setting_Type.isHidden = true
        img_setting_Trace_hippo.isHidden = true
        img_setting_Trace_without_hippo.isHidden = true
        
        if Account.writerOption == 0 {
            
            img_setting_Type.isHidden = false
            
        }
        else if Account.writerOption == 1 {
            
            img_setting_Trace_hippo.isHidden = false
            
        }
        else if Account.writerOption == 2 {
            
            img_setting_Trace_without_hippo.isHidden = false
            
        }
    }
    
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 1 {
            
            let screenWidth = UIScreen.main.bounds.width
            let buttonWidth = ((screenWidth - (20 * 2 )) / 3) - 10
            let cellHeight = buttonWidth * 1.3 + (20 * 2)
            
            return cellHeight
        }
        
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
}
