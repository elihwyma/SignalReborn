//
//  creditViewController.swift
//  SignalReborn
//
//  Created by Charlie While on 05/07/2020.
//  Copyright © 2020 Charlie While. All rights reserved.
//

import UIKit

class creditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return credits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let infoCell = tableView.dequeueReusableCell(withIdentifier: "creditsCell", for: indexPath) as! creditsCell

        infoCell.titleLabel.text = credits[indexPath.row].creditNames
        infoCell.detailLabel.text = credits[indexPath.row].reason
        
        return infoCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.open(URL(string: credits[indexPath.row].socialLinks)!)
    }

    private let credits = [
        Credit(creditNames: "Alpha", reason: "Making the icon", socialLinks: "https://twitter.com/Kutarin_"),
        Credit(creditNames: "SQLite.swift", reason: "Handling databases", socialLinks: "https://github.com/stephencelis/SQLite.swift")
    ]

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.layer.cornerRadius = 10
        self.tableView.isScrollEnabled = false
        self.tableView.tableFooterView = UIView()

    }
}

struct Credit {
    let creditNames: String!
    let reason: String!
    let socialLinks: String!
}
