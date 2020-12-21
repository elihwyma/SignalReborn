//
//  MainViewController.swift
//  SignalReborn
//
//  Created by Amy While on 16/06/2020.
//  Copyright © 2020 Amy While. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MainViewController: UIViewController {
   
    // MARK: - General setup
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var centerButton: UIButton!
    @IBOutlet weak var debugButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    
    var locationsAdded = 0
    let regionInMeters: Double = 500
    var hasDebugged = false
    
    @IBAction func centerButton(_ sender: Any) {
        centerViewOnUserLocation()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
    func setup() {
        LocationManager.shared.checkLocationServices()
        self.mapView.delegate = self
        self.hideMapWatermarks()
        self.defineMapType()
        
        if #available(iOS 13.0, *) {
            infoButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
            infoButton.setImage(UIImage(systemName: "info.circle"), for: .highlighted)
            debugButton.setImage(UIImage(systemName: "exclamationmark.triangle"), for: .normal)
            debugButton.setImage(UIImage(systemName: "exclamationmark.triangle"), for: .highlighted)
            centerButton.setImage(UIImage(systemName: "mappin.circle"), for: .normal)
            centerButton.setImage(UIImage(systemName: "mappin.circle"), for: .highlighted)
        }

        if DatabaseManager.shared.copyTheDatabase() {
            self.hardRefresh()
        }
                
        if CellInfo.shared.mnc == 0 {
            self.navigationBar?.title = "No SIM"
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(addAnnotationsAndCells), name: .RefreshCellNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addAnnotationsAndCells), name: .CellUpdateNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(defineMapType), name: .ChangeMapType, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideMapWatermarks), name: .HideMapWatermarks, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(authorized), name: .Authorized, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addLines), name: .AddLines, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(hardRefresh), name: .HardRefresh, object: nil)
        
        if !self.hasDebugged {
            if DatabaseManager.shared.cells.count == 0 {
                self.hasDebugged = true
                self.performSegue(withIdentifier: "noTowersMapped", sender: nil)
            }
        }
    }
    
    @objc private func hardRefresh() {
        DatabaseManager.shared.prepareCells()
        SignalController.shared.getInfo()
        self.addAnnotationsAndCells()
    }
    
    @objc func authorized() {
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
    }
    
    //MARK: - Adding the lines and annotations on the map
    @objc private func addLines() {
        let overlays = mapView.overlays
        
        for (index, _) in CellInfo.shared.lat.enumerated() {
            let servingLocation = CLLocationCoordinate2D(latitude: CellInfo.shared.lat[index], longitude: CellInfo.shared.lon[index])
            let servingLine: [CLLocationCoordinate2D] = [LocationManager.shared.currentLocation!, servingLocation]
            let servingMapLine = currentServing(coordinates: servingLine, count: servingLine.count)
            mapView.addOverlay(servingMapLine)
        }
        
        mapView.removeOverlays(overlays)
    }

    @objc private func addAnnotationsAndCells() {
        let showLTE = UserDefaults.standard.getBoolWithDefault(key: "ShowLTE", defaultValue: true)
        let showGSM = UserDefaults.standard.getBoolWithDefault(key: "ShowGSM", defaultValue: false)
        let showCDMA = UserDefaults.standard.getBoolWithDefault(key: "ShowCDMA", defaultValue: false)
        
        let allAnnotations = self.mapView.annotations
        
        for cell in DatabaseManager.shared.cells {
            if ((cell.type == "LTE") && (showLTE)) || ((cell.type == "GSM") && (showGSM)) || ((cell.type == "CDMA") && (showCDMA)) {
                self.addAnnotation(lat: cell.lat, lon: cell.lon, cellID: cell.cellID, MNC: cell.mnc, MCC: cell.mcc, type: cell.type, carrier: cell.carrier ?? "", iso: cell.iso ?? "", cc: cell.cc ?? 0, confidence: cell.confidence, tac: cell.tac ?? 0)
            }
        }
        
        self.mapView.removeAnnotations(allAnnotations)
        
        if LocationManager.shared.currentLocation != nil {
            self.addLines()
        }
    }
    
    private func addAnnotation(lat: CLLocationDegrees, lon: CLLocationDegrees, cellID: Int, MNC: Int, MCC: Int, type: String, carrier: String, iso: String, cc: Int, confidence: Int, tac: Int) {
        
        if UserDefaults.standard.getBoolWithDefault(key: "HideOtherCarriers", defaultValue: true) {
            if CellInfo.shared.mnc != MNC || CellInfo.shared.mcc != MCC {
                return
            }
        }
        
        let pin: CellAnnotation!
        let serving = CellInfo.shared.cells.contains(cellID)
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        self.locationsAdded += 1
        var extraLines = [String]()
        
        if tac != 0 {
            extraLines.append("TAC: \(tac)")
        }
        
        if !carrier.isEmpty && !iso.isEmpty && cc != 0 {
            extraLines += ["Owner: \(carrier)", "ISO: \(iso)", "CC: +\(cc)"]
        }

        if !serving {
            pin = CellAnnotation(pinTitle: "Nearby \(type)", lines: (["ID: \(cellID)", "MCC: \(MCC)", "MNC: \(MNC)", "Confidence: \(confidence)"] + extraLines), location: location, image: "nearby\(type)", carrier: carrier)
        } else {
            pin = CellAnnotation(pinTitle: "Serving \(type)", lines: (["ID: \(cellID)", "MCC: \(MCC)", "MNC: \(MNC)", "Confidence: \(confidence)"] + extraLines), location: location, image: "serving\(type)", carrier: carrier)
        }
        
        self.mapView.addAnnotation(pin)
    }
    
    // MARK: - Handling the button presses
    @IBAction func refreshButton(_ sender: Any) {

        let debugAlert = UIAlertController(title: "Full Info", message: "Locations Added: \(self.locationsAdded), Cells: \(SignalController.shared.cellInfo), Serving: \(CellInfo.shared.lat), \(CellInfo.shared.lon)", preferredStyle: .alert)
        debugAlert.addAction(UIAlertAction(title: ":)", style: .default, handler: nil))
        self.present(debugAlert, animated: true)
    }
    
    func centerViewOnUserLocation() {
        if let location = LocationManager.shared.locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func clearOverlays() {
        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
    }
    
    func clearAnnotations() {
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? currentServing {
            let currentRenderer = MKPolylineRenderer(polyline: polyline)
            currentRenderer.strokeColor = .green
            currentRenderer.lineWidth = 2.5
            return currentRenderer
        }
        
        if let polyline = overlay as? neighbouringCell {
            let currentRenderer = MKPolylineRenderer(polyline: polyline)
            currentRenderer.strokeColor = .cyan
            currentRenderer.lineWidth = 2.5
            return currentRenderer
        }
        
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        if let uwu = annotation as? CellAnnotation {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "CellAnnotation")
            annotationView.image = UIImage(named: uwu.image!)
            annotationView.canShowCallout = true
            annotationView.loadCustomLines(customLines: uwu.lines!)
            
            if SignalController.shared.devmode {
                annotationView.clusteringIdentifier = uwu.carrier
            }
            
            return annotationView
        }
        
        return nil
    }
    
}

//MARK: - Map View Delegate
extension MainViewController: MKMapViewDelegate {
    
    @objc func defineMapType() {
        switch (UserDefaults.standard.integer(forKey: "MapType")) {
            case 0:
                mapView.mapType = MKMapType.standard
                break
            case 1:
                mapView.mapType = MKMapType.satellite
                break
            case 2:
                mapView.mapType = MKMapType.hybrid
                break
            default:
                mapView.mapType = MKMapType.standard
                break
        }
    }
    
    @objc func hideMapWatermarks() {
        
        var legalLabel: UIView?
        var logoView: UIView?
        
        for subview in mapView.subviews {
            if String(describing: type(of: subview)) == "MKAttributionLabel" {
                legalLabel = subview
            }
        }
        
        for subview in mapView.subviews {
            if String(describing: type(of: subview)) == "MKAppleLogoImageView" {
                logoView = subview
            }
        }
        
        if UserDefaults.standard.getBoolWithDefault(key: "HideMapWatermarks", defaultValue: true) {
            legalLabel?.isHidden = true
            logoView?.isHidden = true
        } else {
            legalLabel?.isHidden = false
            logoView?.isHidden = false
        }
    }
}
