//
//  MKAnnotationView.swift
//  SignalReborn
//
//  Created by Charlie While on 26/09/2020.
//  Copyright © 2020 Charlie While. All rights reserved.
// This is taken from https://stackoverflow.com/questions/40214778/how-to-show-multiple-lines-in-mkannotation-with-autolayout

import MapKit

extension MKAnnotationView {

    func loadCustomLines(customLines: [String]) {
        let stackView = self.stackView()
        for line in customLines {
            let label = UILabel()
            label.text = line
            stackView.addArrangedSubview(label)
        }
        self.detailCalloutAccessoryView = stackView
    }



    private func stackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }
}
