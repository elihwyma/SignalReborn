//
//  MapViewController.swift
//  SignalReborn
//
//  Created by Somica on 17/10/2022.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    let mapView: MKMapView = {
        let view = MKMapView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsScale = true
        view.showsCompass = true
        view.showsUserLocation = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}
