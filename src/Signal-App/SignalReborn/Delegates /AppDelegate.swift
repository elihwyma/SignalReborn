//
//  AppDelegate.swift
//  SignalReborn
//
//  Created by Amy While on 16/06/2020.
//  Copyright © 2020 Amy While. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        #if jailed
        SignalController.shared.jailedInfo()
        #else
        SignalController.shared.setup()
        SignalController.shared.getInfo()
        #endif
        CSVController.shared.readDataFromCSV()
        
        return true
    }
    
}

