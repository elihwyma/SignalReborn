//
//  SignalController.swift
//  SignalReborn
//
//  Created by Amy While on 17/09/2020.
//  Copyright © 2020 Amy While. All rights reserved.
//

import UIKit
import CoreTelephony
import MapKit

class SignalController {
    static let sharedMonitor = SRMonitor()
    static let sharedRootController = rootController()
    static let shared = SignalController()
    static let connection = SignalController.sharedMonitor.setupServerAndNotifications()
    
    var cellInfo: [[String : Any]] = []
    var devmode = false
    
    //MARK: - General setup
    func sendAlertication(title: String, message: String, okButton: String, sender: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okButton, style: .default, handler: nil))
        sender.present(alert, animated: true)
    }
    
    func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(getInfo), name: .CellUpdateNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getInfo), name: .RefreshCellNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fuckyWucky), name: .FuckyWucky, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.devMode(_:)), name: .ToggleDevMode, object: nil)
    }
    
    @objc private func devMode(_ notification: NSNotification) {
        self.devmode = notification.userInfo?["enable"] as! Bool
        NotificationCenter.default.post(name: .HardRefresh, object: nil)
    }
    
    //MARK: - This will work if your running with entitlements or not
    func jailedInfo() {
        let networkInfo = CTTelephonyNetworkInfo()
        let carrier = networkInfo.subscriberCellularProvider
        
        if let mnc = carrier?.mobileNetworkCode { CellInfo.shared.mnc = Int(mnc)! }
        if let mcc = carrier?.mobileCountryCode { CellInfo.shared.mcc = Int(mcc)! }
        if let name = carrier?.carrierName { CellInfo.shared.name = name }
        if let technology = networkInfo.currentRadioAccessTechnology { CellInfo.shared.jailedtechnology = technology }
    }
    
    //MARK: - Handling the actual info
    @objc func fuckyWucky() {
        guard let cellInfoDictionary = SignalController.sharedMonitor.getTheCellInfo(SignalController.connection) else {
            return
        }
        
        var sex = [Int]()
        for cell in (cellInfoDictionary as! [[String : Any]]) {
            if let cellID = cell["kCTCellMonitorCellId"] as? Int {
                sex.append(cellID)
            }
        }
        
        if (sex.sorted() != CellInfo.shared.cells.sorted()) || CellInfo.shared.cells.count == 0 {
            NotificationCenter.default.post(name: .CellUpdateNotification, object: nil)
        }
    }
    
    @objc func getInfo() {
        guard let cellInfoDictionary = SignalController.sharedMonitor.getTheCellInfo(SignalController.connection) else {
            return
        }
        
        SignalController.shared.cellInfo.removeAll()
        CellInfo.shared.cells.removeAll()
        CellInfo.shared.lat.removeAll()
        CellInfo.shared.lon.removeAll()
        
        for cell in (cellInfoDictionary as! [[String : Any]]) {
            var sex: [String : Any] = [
                :
            ]
            
            switch cell["kCTCellMonitorCellRadioAccessTechnology"] as? String? {
                case "kCTCellMonitorRadioAccessTechnologyLTE": sex["Technology"] = "LTE"
                case "kCTCellMonitorRadioAccessTechnologyUMTS": sex["Technology"] = "UMTS"
                case "kCTCellMonitorRadioAccessTechnologyGSM": sex["Technology"] = "GSM"
                case "kCTCellMonitorRadioAccessTechnologyCDMA1x": sex["Technology"] = "CDMA"
                case "kCTCellMonitorRadioAccessTechnologyCDMAEVDO": sex["Technology"] = "CDMA"
                case "kCTCellMonitorRadioAccessTechnologyTDSCDMA": sex["Technology"] = "CDMA"
                default: break
            }
            
            switch cell["kCTCellMonitorCellType"] as? String {
                case "kCTCellMonitorCellTypeServing": sex["Type"] = "Serving"
                case "kCTCellMonitorCellTypeNeighbor": sex["Type"] = "Neighbour"
                case "kCTCellMonitorCellTypeDetected": sex["Type"] = "Detected"
                default: break
            }
            
            if let bandInfo = cell["kCTCellMonitorBandInfo"] as? Int { sex["Band Info"] = String(bandInfo) }
            if let cellID = cell["kCTCellMonitorCellId"] as? Int { sex["Cell ID"] = String(cellID); CellInfo.shared.cells.append(cellID) }
            if let mcc = cell["kCTCellMonitorMCC"] as? Int { sex["MCC"] = String(mcc) }
            if let mnc = cell["kCTCellMonitorMNC"] as? Int { sex["MNC"] = String(mnc) }
            if let pid = cell["kCTCellMonitorPID"] as? Int { sex["PID"] = String(pid) }
            if let tac = cell["kCTCellMonitorTAC"] as? Int { sex["TAC"] = String(tac) }
            if let uarfcn = cell["kCTCellMonitorUARFCN"] as? Int { sex["UARFCN"] = String(uarfcn) }
    
            SignalController.shared.cellInfo.append(sex)
        }
        
        SignalController.shared.jailedInfo()
        
        let showLTE = UserDefaults.standard.getBoolWithDefault(key: "ShowLTE", defaultValue: true)
        let showGSM = UserDefaults.standard.getBoolWithDefault(key: "ShowGSM", defaultValue: false)
        let showCDMA = UserDefaults.standard.getBoolWithDefault(key: "ShowCDMA", defaultValue: false)
        let showNR = UserDefaults.standard.getBoolWithDefault(key: "ShowNR", defaultValue: true)
        
        for cell in DatabaseManager.shared.cells {
            if ((cell.type == .lte) && (showLTE)) || ((cell.type == .gsm) && (showGSM)) || ((cell.type == .cdma) && (showCDMA)) || (cell.type == .nr && showNR) {
                if CellInfo.shared.cells.contains(cell.cellID) {
                    CellInfo.shared.lat.append(cell.lat)
                    CellInfo.shared.lon.append(cell.lon)
                }
            }
        }
    }
}

class CellInfo {
    static let shared = CellInfo()
    
    var name = ""
    var jailedtechnology = ""
    var mnc = 0
    var mcc = 0
    var lat = [CLLocationDegrees]()
    var lon = [CLLocationDegrees]()
    var cells = [Int]()
}
