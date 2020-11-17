//
//  CSVController.swift
//  SignalReborn
//
//  Created by Amy While on 18/09/2020.
//  Copyright © 2020 Amy While. All rights reserved.
//

import Foundation
import UIKit

class CSVController {
    //The CSV is bundled with the tweak, and can be found in /var/mobile/Library/Application\\ Support/SignalReborn
    static let shared = CSVController()
    
    var carriers = [Carrier]()
    
    //MARK: - For loading the CSV into memory to be used by the Database and Cell Controller
    func readDataFromCSV() {
        do {
            if let url = Bundle.main.path(forResource: "CarrierDatabase", ofType: "csv") {
                let contents = try String(contentsOfFile: url, encoding: .utf8)
                csv(data: contents)
            }
        } catch {
            return
        }
    }

    func csv(data: String) {
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ";")
            if columns.count == 6 {
                let mcc = Int((columns[0].replacingOccurrences(of: " ", with: "")).replacingOccurrences(of: "\t", with: ""))
                let mnc = Int((columns[1].replacingOccurrences(of: " ", with: "")).replacingOccurrences(of: "\t", with: ""))
                let iso = columns[2].uppercased()
                let cc = Int((columns[4].replacingOccurrences(of: " ", with: "")).replacingOccurrences(of: "\t", with: ""))
                let carrier = columns[5]
                carriers.append(Carrier(mcc: mcc, mnc: mnc, carrier: carrier, iso: iso, cc: cc))
            }
        }
    }
}

struct Carrier {
    let mcc: Int!
    let mnc: Int!
    let carrier: String!
    let iso: String!
    let cc: Int!
}
