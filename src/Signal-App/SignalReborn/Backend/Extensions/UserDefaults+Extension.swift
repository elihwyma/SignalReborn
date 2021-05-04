//
//  UserDefaults+Extension.swift
//  SignalReborn
//
//  Created by Amy While on 27/09/2020.
//  Copyright © 2020 Amy While. All rights reserved.
//

import Foundation

extension UserDefaults {
    func getBoolWithDefault(key: String, defaultValue: Bool) -> Bool {
        return UserDefaults.standard.object(forKey: key) as? Bool ?? defaultValue
    }
}
