//
//  CSVParsableProtocol.swift
//  SignalReborn
//
//  Created by Somica on 17/10/2022.
//

import Foundation

protocol CSVParsable: Hashable {
    
    init?(row: String)
    
}
