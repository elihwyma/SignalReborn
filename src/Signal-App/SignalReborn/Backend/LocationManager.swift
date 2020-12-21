//
//  LocationManager.swift
//  SignalReborn
//
//  Created by Amy While on 17/11/2020.
//  Copyright © 2020 Amy While. All rights reserved.
//

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
 
    let locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locationManager.location?.coordinate
        NotificationCenter.default.post(name: .AddLines, object: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorisation()
    }
    
    public func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorisation()
        }
    }
       
    private func checkLocationAuthorisation() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            self.allowed()
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            self.allowed()
        @unknown default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func allowed() {
        locationManager.startUpdatingLocation()
        self.currentLocation = locationManager.location?.coordinate
        NotificationCenter.default.post(name: .Authorized, object: nil)
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
}
