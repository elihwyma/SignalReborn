//
//  SettingsSwitchCell.swift
//  SignalReborn
//
//  Created by Charlie While on 23/09/2020.
//  Copyright © 2020 Charlie While. All rights reserved.
//

import UIKit

class SettingsSwitchCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var prefsSwitch: UISwitch!
    
    var prefsName = ""
    var notificationName = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup() {
        if !prefsName.isEmpty {
            if UserDefaults.standard.object(forKey: prefsName) != nil {
                prefsSwitch.isOn = UserDefaults.standard.bool(forKey: prefsName)
            }
        }
    }
    
    @IBAction func prefsSwitched(_ sender: Any) {
        if !prefsName.isEmpty {
            UserDefaults.standard.setValue(prefsSwitch.isOn, forKey: prefsName)
        }
        
        if !notificationName.isEmpty {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationName), object: nil)
        }
    }
}
