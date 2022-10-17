//
//  CarrierDatabase.swift
//  SignalReborn
//
//  Created by Somica on 17/10/2022.
//

import Foundation

final class CarrierDatabase {
    
    static let shared = CarrierDatabase()
    
    public let carriers: Set<Carrier>
    
    init() {
    }
    
}
