//
//  UserDefaults+Extension.swift
//  SignalReborn
//
//  Created by Charlie While on 27/09/2020.
//  Copyright © 2020 Charlie While. All rights reserved.
//

import Foundation

extension UserDefaults {
    func getBoolWithDefault(key: String, defaultValue: Bool) -> Bool {
        return UserDefaults.standard.object(forKey: key) as? Bool ?? defaultValue
    }
}
