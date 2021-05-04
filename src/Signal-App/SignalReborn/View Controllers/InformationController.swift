//
//  SecondViewController.swift
//  SignalReborn
//
//  Created by Amy While on 16/06/2020.
//  Copyright © 2020 Amy While. All rights reserved.
//

import UIKit

class InformationController: UIViewController {
  
    @IBOutlet weak var tableView: UITableView!
    var containerView = UIView()
    var popupView: AppIconPopover = .fromNib()
      
//MARK: - Actually getting the info setup for the table
    
    private let switchesAndSegments: [InfoPageCell] = [
        InfoPageCell(identifier: "SegmentedCell", data:
                        ["prefsName" : "MapType", "notificationName" : "ChangeMapType", "segments" : ["Standard", "Satellite", "Hybrid"], "default" : 0]),
        InfoPageCell(identifier: "SettingsSwitchCell", data:
                        ["prefsName" : "ShowLTE", "cellName" : "Show LTE", "notificationName" : "refreshAnnotations", "default" : true]),
        InfoPageCell(identifier: "SettingsSwitchCell", data:
                        ["prefsName" : "ShowCDMA", "cellName" : "Show CDMA", "notificationName" : "refreshAnnotations", "default" : false]),
        InfoPageCell(identifier: "SettingsSwitchCell", data:
                        ["prefsName" : "ShowGSM", "cellName" : "Show GSM", "notificationName" : "refreshAnnotations", "default" : false]),
        InfoPageCell(identifier: "SettingsSwitchCell", data:
                        ["prefsName" : "HideOtherCarriers", "cellName" : "Hide Other Carriers", "notificationName" : "refreshAnnotations", "default" : true]),
        InfoPageCell(identifier: "SettingsSwitchCell", data:
                        ["prefsName" : "HideMapWatermarks", "cellName" : "Hide Map Watermarks", "notificationName" : "HideMapWatermarks", "default" : true]),
    ]
    
    private let socials: [InfoPageCell] = [
        InfoPageCell(identifier: "SocialCell", data:
                        ["imageName" : "discord", "label" : "Join my Discord", "link" : "https://discord.gg/KNZRvGe"]),
        InfoPageCell(identifier: "SocialCell", data:
                        ["imageName" : "Github", "label" : "View on Github", "link" : "https://github.com/elihwyma/SignalReborn"])
    ]
    
    private let buttons: [InfoPageCell] = [
        InfoPageCell(identifier: "ButtonCell", data:
                        ["buttonName" : "App Icon", "notificationName" : "AppIcon"]),
        InfoPageCell(identifier: "ButtonCell", data:
                        ["buttonName" : "Credits", "notificationName" : "ShowCredits"]),
        InfoPageCell(identifier: "ButtonCell", data:
                        ["buttonName" : "Purge Database", "notificationName" : "PurgeDatabase"])
    ]
    
    private let githubSocials: [InfoPageCell] = [
        InfoPageCell(identifier: "GithubSocial", data: [
            "social": GithubSocial(githubProfile: "elihwyma", author: "Amy")
        ])
    ]
    
    var toShow: [[InfoPageCell]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
    @objc func organiseData() {
        var uwu = [[InfoPageCell]]()
        
        for cell in SignalController.shared.cellInfo {
            let keys = Array(cell.keys).sorted()
            var stinkyOwo = [InfoPageCell]()
            
            for key in keys {
                stinkyOwo.append(InfoPageCell(identifier: "InfoCell", data:
                                                ["descriptionLabel" : key, "specificLabel" : cell[key] as Any]))
            }
            
            uwu.append(stinkyOwo)
        }

        self.toShow = uwu
        self.toShow.append(switchesAndSegments)
        self.toShow.append(socials)
        self.toShow.append(githubSocials)
        self.toShow.append(buttons)
                
        self.tableView.reloadData()
    }
    
    func setup() {
        self.tableView.register(UINib(nibName: "InfoCell", bundle: nil), forCellReuseIdentifier: "InfoCell")
        self.tableView.register(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: "ButtonCell")
        self.tableView.register(UINib(nibName: "SegmentedCell", bundle: nil), forCellReuseIdentifier: "SegmentedCell")
        self.tableView.register(UINib(nibName: "SettingsSwitchCell", bundle: nil), forCellReuseIdentifier: "SettingsSwitchCell")
        self.tableView.register(UINib(nibName: "SocialCell", bundle: nil), forCellReuseIdentifier: "SocialCell")
        
        self.organiseData()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.layer.cornerRadius = 10
        self.tableView.layer.masksToBounds = true
        self.tableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(organiseData), name: .CellUpdateNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showCredits), name: NSNotification.Name(rawValue: "ShowCredits"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(purge), name: NSNotification.Name(rawValue: "PurgeDatabase"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hidePopup), name: .HidePopup, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showPopup), name: NSNotification.Name(rawValue: "AppIcon"), object: nil)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.devModeToggle))
        self.tableView.addGestureRecognizer(longPress)
    }
    
    //MARK: - Popup Shit
    @objc func hidePopup() {
        let deadBounds = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        
        UIView.animate(withDuration: 1.0,
                         delay: 0, usingSpringWithDamping: 1.0,
                         initialSpringVelocity: 1.0,
                         options: .curveEaseInOut, animations: {
                            self.containerView.alpha = 0
                            self.popupView.frame = deadBounds
                         }, completion: { (value: Bool) in
                            self.popupView.removeFromSuperview()
                            self.containerView.removeFromSuperview()
          })
    }

    @objc private func showPopup() {
        self.containerView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        self.containerView.frame = self.view.frame
        self.containerView.alpha = 0
        self.view.addSubview(containerView)

        let deadBounds = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        self.popupView.frame = deadBounds
        self.view.addSubview(popupView)

        UIView.animate(withDuration: 0.5,
                         delay: 0, usingSpringWithDamping: 1.0,
                         initialSpringVelocity: 1.0,
                         options: .curveEaseInOut, animations: {
                            self.containerView.alpha = 0.95
                            self.popupView.frame = self.view.bounds
          }, completion: nil)
    }
    
    @objc func devModeToggle(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            let touchPoint = longPressGestureRecognizer.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let shownCell = self.toShow[indexPath.section][indexPath.row]
                if shownCell.identifier == "SocialCell" {
                    if (shownCell.data["imageName"] as! String) == "TwitterPFP" {
                        let alert = UIAlertController(title: "Developer Mode", message: "Enabling this will enable features that are either broken or unfinished. It will also disable the accuracy filter on cells. Restarting the app will disable this.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Enable", style: .destructive, handler: { action in
                            if !SignalController.shared.devmode {
                                let userInfo: [String : Any] = ["enable" : true]
                                NotificationCenter.default.post(name: .ToggleDevMode, object: nil, userInfo: userInfo)
                            }
                        }))
                        alert.addAction(UIAlertAction(title: "Disable", style: .cancel, handler: nil))
                            if SignalController.shared.devmode {
                                let userInfo: [String : Any] = ["enable" : false]
                                NotificationCenter.default.post(name: .ToggleDevMode, object: nil, userInfo: userInfo)
                            }
                        self.present(alert, animated: true)
                    }
                }
            }
        }
    }
}

extension InformationController {
    @objc func purge() {
        let alert = UIAlertController(title: "Purge Database", message: "Doing this will remove all cached cells. It may take up to 24 hours for cells to start reappearing. The app will restart.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Nope, go back", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            SignalController.sharedRootController.purge()
            fatalError("Database Purged")
        }))
        self.present(alert, animated: true)
    }
    
    @objc func showCredits() {
        self.performSegue(withIdentifier: "transitionToCredits", sender: nil)
    }
}

//MARK: - Table View Cell Shit
extension InformationController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension InformationController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.toShow.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.toShow[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    //This will probably be cleaned up at some point, I don't like it :fr:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if toShow[indexPath.section][indexPath.row].identifier == "SettingsSwitchCell" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchCell", for: indexPath) as! SettingsSwitchCell
            cell.prefsName = toShow[indexPath.section][indexPath.row].data["prefsName"] as! String
            cell.notificationName = toShow[indexPath.section][indexPath.row].data["notificationName"] as! String
            cell.label.text = toShow[indexPath.section][indexPath.row].data["cellName"] as? String
            cell.prefsSwitch.isOn = toShow[indexPath.section][indexPath.row].data["default"] as! Bool
            cell.setup()
            return cell
        } else if toShow[indexPath.section][indexPath.row].identifier == "SegmentedCell" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SegmentedCell", for: indexPath) as! SegmentedCell
            cell.prefsName = toShow[indexPath.section][indexPath.row].data["prefsName"] as! String
            cell.notificationName = toShow[indexPath.section][indexPath.row].data["notificationName"] as! String
            cell.segments = toShow[indexPath.section][indexPath.row].data["segments"] as! [String]
            cell.defaultValue = toShow[indexPath.section][indexPath.row].data["default"] as! Int
            cell.setup()
            return cell
        } else if toShow[indexPath.section][indexPath.row].identifier == "ButtonCell" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonCell
            cell.notificationName = toShow[indexPath.section][indexPath.row].data["notificationName"] as! String
            cell.buttonName = toShow[indexPath.section][indexPath.row].data["buttonName"] as! String
            cell.setup()
            return cell
        } else if toShow[indexPath.section][indexPath.row].identifier == "InfoCell" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoCell
            cell.descriptionLabel.text = toShow[indexPath.section][indexPath.row].data["descriptionLabel"] as? String
            cell.specificLabel.text = toShow[indexPath.section][indexPath.row].data["specificLabel"] as? String
            cell.setup()
            return cell
        } else if toShow[indexPath.section][indexPath.row].identifier == "SocialCell" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SocialCell", for: indexPath) as! SocialCell
            cell.labelText = toShow[indexPath.section][indexPath.row].data["label"] as! String
            cell.imageName = toShow[indexPath.section][indexPath.row].data["imageName"] as! String
            cell.link = toShow[indexPath.section][indexPath.row].data["link"] as! String
            cell.setup()
            return cell
        } else if toShow[indexPath.section][indexPath.row].identifier == "GithubSocial" {
            let cell = GithubSocialCell()
            cell.social = toShow[indexPath.section][indexPath.row].data["social"] as? GithubSocial
            return cell
        }
        
        return UITableViewCell()
    }
}

struct InfoPageCell {
    var identifier: String!
    var data: [String : Any]!
}

