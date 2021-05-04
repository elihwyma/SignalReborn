//
//  helpTheCache.swift
//  SignalReborn
//
//  Created by Amy While on 06/07/2020.
//  Copyright © 2020 Amy While. All rights reserved.
//

import UIKit

class helpTheCache: UIViewController {

    @IBOutlet weak var topText: UILabel!
    @IBOutlet weak var subText: UILabel!
    @IBOutlet weak var extraDetail: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topText.adjustsFontSizeToFitWidth = true
        subText.adjustsFontSizeToFitWidth = true
        extraDetail.text = ("- Close the app \n - Enable Airplane Mode for a few seconds\n - Turn off Airplane Mode, and wait up to 24 hours \n - Ensure Auto-Call is enabled in Emergency SOS settings \n - Also try, restarting your phone, re-inserting sim card, and trying these steps again \n - Contact me for more help")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func purgeButton(_ sender: Any) {
        SignalController.sharedRootController.purge()
        _ = SignalController.sharedRootController.copyFiles()
        let newAlert = UIAlertController(title: "Purge Successful", message: "Now follow the other steps!", preferredStyle: .alert)
        newAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(newAlert, animated: true)
    }
    
    
}
