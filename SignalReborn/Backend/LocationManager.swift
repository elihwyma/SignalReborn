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
    
    override init() {
        super.init()
        
        self.checkLocationServices()
    }
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locationManager.location?.coordinate
        NotificationCenter.default.post(name: .AddLines, object: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorisation()
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorisation()
        }
    }
       
    func checkLocationAuthorisation() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            self.currentLocation = locationManager.location?.coordinate
            NotificationCenter.default.post(name: .Authorized, object: nil)
            break
        case .denied:
            //Oof
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            //lol not happening bruv
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
}
