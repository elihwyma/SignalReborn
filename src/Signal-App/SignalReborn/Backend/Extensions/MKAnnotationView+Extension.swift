//
//  MKAnnotationView.swift
//  SignalReborn
//
//  Created by Amy While on 26/09/2020.
//  Copyright © 2020 Amy While. All rights reserved.
// This is taken from https://stackoverflow.com/questions/40214778/how-to-show-multiple-lines-in-mkannotation-with-autolayout

import MapKit

extension MKAnnotationView {

    func loadCustomLines(customLines: [String]) {
        let stackView = self.stackView()
        let distanceResponse = self.getDistance()
        var customyLines = customLines
        
        if distanceResponse.0 {
            customyLines.append("Distance: \(distanceResponse.1)m")
        }
        
        for line in customyLines {
            let label = UILabel()
            label.text = line
            stackView.addArrangedSubview(label)
        }
        
        self.detailCalloutAccessoryView = stackView
    }
    
    private func getDistance() -> (Bool, Int) {
        if let currentLocation = LocationManager.shared.currentLocation {
            let location = self.annotation?.coordinate
            guard let distance = location?.distance(currentLocation) else { return (false, 0) }
            return (true, Int(distance))
        }
        
        return (false, 0)
    }
    
    private func stackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }
}
