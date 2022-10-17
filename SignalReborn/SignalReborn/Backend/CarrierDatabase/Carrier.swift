//
//  Carrier.swift
//  SignalReborn
//
//  Created by Somica on 17/10/2022.
//

import Foundation

struct Carrier: CSVParsable, Equatable, Hashable {
    
    /// Mobile Network Code
    let mnc: Int
    /// Mobile Country Code
    let mcc: Int
    /// Call Code
    let cc: Int
    
    /// Carrier Name
    let name: String
    /// ISO 3166-1 Country Code
    let iso: String
    
    
    init?(row: String) {
        let split = row.split(separator: ";")
        guard split.count == 6,
              let mcc = Int(split[0]),
              let mnc = Int(split[1]),
              let cc = Int(split[4]) else { return nil }
        self.mcc = mcc
        self.mnc = mnc
        self.cc = cc
        self.name = String(split[5])
        self.iso = String(split[2]).uppercased()
    }
    
    static func ==(lhs: Carrier, rhs: Carrier) -> Bool {
        lhs.mnc == rhs.mnc &&
        lhs.mcc == rhs.mcc
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(mnc)
        hasher.combine(mcc)
    }
    
}
