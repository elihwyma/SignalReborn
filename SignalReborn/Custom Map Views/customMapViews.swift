//
//  customMapViews.swift
//  SignalReborn
//
//  Created by Charlie While on 21/06/2020.
//  Copyright © 2020 Charlie While. All rights reserved.
//

import UIKit
import Foundation
import MapKit

class currentServing : MKPolyline {
    var color: String?
}

class neighbouringCell : MKPolyline {
    var color: String?
}

class CellAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var lines: [String]?
    var image: String?
    
    init(pinTitle:String, lines: [String], location: CLLocationCoordinate2D, image: String) {
        self.title = pinTitle
        self.lines = lines
        self.coordinate = location
        self.image = image
    }
}
