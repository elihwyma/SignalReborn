//
//  LightControlPopover.swift
//  Shade
//
//  Created by Amy While on 26/10/2020.
//

import UIKit

struct Icon {
    var name: String!
    var appearance: String!
    
    init(_ name: String!, _ appearance: String!) {
        self.name = name
        self.appearance = appearance
    }
}

class AppIconPopover: UIView {
    
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var background: UIControl!
    @IBOutlet weak var tableView: FancyTableView!
    
    private let icons: [Icon] = [
        Icon("PurpleIcon", "Refresh"),
        Icon("SignalReborn", "Original")
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setup()
    }
    
    override func willMove(toSuperview: UIView?) {
        super.willMove(toSuperview: toSuperview)
    }
    
    func setup() {
        if !UIAccessibility.isReduceTransparencyEnabled {
            let blurEffect = UIBlurEffect(style: .regular)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)

            blurEffectView.frame = self.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            self.blurView.addSubview(blurEffectView)
        }
        
        self.blurView.alpha = 0.5
        self.background.addTarget(self, action: #selector(hideView), for: .touchUpInside)
        
        //Removes cells that don't exist
        tableView.tableFooterView = UIView()
        //Disable the scroll indicators
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        //Setting up nessecary stuff
        tableView.dataSource = self
        tableView.delegate = self
        //Disable scrolling if it all fits
        tableView.alwaysBounceVertical = false
        
        tableView.register(UINib(nibName: "AppIconCell", bundle: nil), forCellReuseIdentifier: "AppIconCell")
        
        self.tableView.backgroundColor = .clear
        self.tableView.sectionIndexBackgroundColor = .clear
    }
    
    @objc func hideView() {
        print("Hide has been called")
        NotificationCenter.default.post(name: .HidePopup, object: nil)
    }
}

extension AppIconPopover : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = self.icons[indexPath.row].name!
        if name == "SignalReborn" {
            UIApplication.shared.setAlternateIconName(nil)
            self.tableView.reloadData()
            return
        }
        
        UIApplication.shared.setAlternateIconName(name) { error in
            if error != nil {
                return
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.tableView.reloadData()
    }
}

extension AppIconPopover : UITableViewDataSource {
    
    //This is just meant to be
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.icons.count
    }
    
    //This is what handles all the images and text etc, using the class mainScreenTableCells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "AppIconCell", for: indexPath) as! AppIconCell
        let icon = self.icons[indexPath.row]
        
        let currentImage = UIApplication.shared.alternateIconName
        if (currentImage == icon.name) {
            cell.iconName.text = "\(icon.appearance!) ✓"
        } else { cell.iconName.text = icon.appearance }
        
        if (UIApplication.shared.alternateIconName == nil && icon.name == "SignalReborn") {
            cell.iconName.text = "\(icon.appearance!) ✓"
        }
        
        cell.iconName.sizeToFit()
        cell.iconImage.image = UIImage(named: icon.name)
        cell.colourThings()
     
        return cell
    }

}
