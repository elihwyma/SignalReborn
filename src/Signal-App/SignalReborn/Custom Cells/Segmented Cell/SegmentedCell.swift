//
//  SegmentedCell.swift
//  SignalReborn
//
//  Created by Amy While on 23/09/2020.
//  Copyright © 2020 Amy While. All rights reserved.
//

import UIKit

class SegmentedCell: UITableViewCell {
    
    @IBOutlet weak var segment: UISegmentedControl!
    var segments = [String]()
    
    var prefsName = ""
    var notificationName = ""
    var defaultValue = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup() {
        self.segment.removeAllSegments()
        for (index, segment) in segments.enumerated() {
            self.segment.insertSegment(withTitle: segment, at: index, animated: false)
        }
        
        if !prefsName.isEmpty {
            if UserDefaults.standard.object(forKey: prefsName) != nil {
                segment.selectedSegmentIndex = UserDefaults.standard.integer(forKey: prefsName)
            } else {
                segment.selectedSegmentIndex = defaultValue
            }
        }
    }

    @IBAction func segment(_ sender: Any) {
        if !prefsName.isEmpty {
            UserDefaults.standard.setValue(self.segment.selectedSegmentIndex, forKey: prefsName)
        }
        
        if !notificationName.isEmpty {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationName), object: nil)
        }
    }
}
