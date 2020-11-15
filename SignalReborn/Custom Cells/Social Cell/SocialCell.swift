//
//  SocialCell.swift
//  SignalReborn
//
//  Created by Amy While on 03/10/2020.
//  Copyright © 2020 Amy While. All rights reserved.
//

import UIKit

class SocialCell: UITableViewCell {
    
    var imageName = ""
    var labelText = ""
    var link = ""
    
    //imageView is already taken by a TableCell, comprimise
    @IBOutlet weak var imageViewView: UIImageView!
    @IBOutlet weak var buttonControl: UIControl!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @objc func openUrl() {
        if !link.isEmpty {
            UIApplication.shared.open(URL(string: link)!)
        }
    }

    func setup() {
        label.text = labelText
        buttonControl.addTarget(self, action: #selector(openUrl), for: .touchUpInside)
        
        if let image = UIImage(named: imageName) {
            self.imageViewView.image = image
        } else {
            if let url = URL(string: "https://github.com/\(imageName).png") {
                DispatchQueue.global(qos: .utility).async {
                    do {
                        let image = UIImage(data: try Data(contentsOf: url))
                        if image != nil {
                            DispatchQueue.main.async {
                                self.imageViewView.image = image
                            }
                        }
                    } catch {
                        return
                    }
                }
            }
        }
    }
}
