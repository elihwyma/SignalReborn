//
//  FancyTableView.swift
//  SignalReborn
//
//  Created by Amy While on 15/11/2020.
//  Copyright © 2020 Amy While. All rights reserved.
//

import UIKit

class FancyTableView: UITableView {

    var maxHeight: CGFloat = UIScreen.main.bounds.size.height
      
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
      
    override var intrinsicContentSize: CGSize {
        let height = min(contentSize.height, maxHeight)
        return CGSize(width: contentSize.width, height: height)
    }

}
