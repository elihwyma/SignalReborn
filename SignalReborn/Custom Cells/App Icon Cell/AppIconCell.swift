//
//  appIconCell.swift
//  dra1n
//
//  Created by Amy While on 14/08/2020.
//

import UIKit

class AppIconCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.colourThings()
    }
    
    @IBInspectable weak var minHeight: NSNumber! = 75
       
   override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
       let size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
       guard let minHeight = minHeight else { return size }
       return CGSize(width: size.width, height: max(size.height, (minHeight as! CGFloat)))
   }
    
    func colourThings() {
        self.backgroundColor = .clear
  
        self.iconImage.layer.cornerRadius = 15
        self.iconImage.layer.masksToBounds = true
    }

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var iconName: UILabel!
    
}
