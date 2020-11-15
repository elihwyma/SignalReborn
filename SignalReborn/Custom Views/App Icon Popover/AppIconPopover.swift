//
//  LightControlPopover.swift
//  Shade
//
//  Created by Amy While on 26/10/2020.
//

import UIKit

class AppIconPopover: UIView {
    
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var background: UIControl!
    @IBOutlet weak var tableView: FancyTableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setup()
    }
    
    override func willMove(toSuperview: UIView?) {
        super.willMove(toSuperview: toSuperview)
    }
    
    func setup() {
        if !UIAccessibility.isReduceTransparencyEnabled {
            let blurEffect = UIBlurEffect(style: .regular)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)

            blurEffectView.frame = self.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            self.blurView.addSubview(blurEffectView)
        }
        
        self.blurView.alpha = 0.5
    }
    
    @objc func hideView() {
        NotificationCenter.default.post(name: .HidePopup, object: nil)
    }
}
