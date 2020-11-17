//
//  CLLocationCoordinate2D.swift
//  SignalReborn
//
//  Created by Amy While on 17/11/2020.
//  Copyright © 2020 Amy While. All rights reserved.
//

import CoreLocation

extension CLLocationCoordinate2D {
    func distance(_ from: CLLocationCoordinate2D) -> CLLocationDistance {
        let destination=CLLocation(latitude:from.latitude,longitude:from.longitude)
        return CLLocation(latitude: latitude, longitude: longitude).distance(from: destination)
    }
}
