//
//  CSVParser.swift
//  SignalReborn
//
//  Created by Somica on 17/10/2022.
//

import Foundation

final class CSVParser {
    
    private let file: URL
    
    init(file: URL) {
        self.file = file
    }
    
    internal func parse<T: CSVParsable>(creating: T) -> [T] {
        var set = [T]()
        guard let data = try? Data(contentsOf: file),
              let string = String(data: data, encoding: .utf8) else { return set }
        set = string.split(separator: "\n").compactMap { T(row: String($0)) }
        return set
    }
    
}
