//
//  FeaturesTableViewController.swift
//  FilmRolls
//
//  Created by Mike on 7/27/23.
//

import UIKit

class FeaturesTableViewController: UITableViewController {
    
    
    var features:[[String]]!
    
    init(features: [[String]]!) {
        self.features = features
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "FeatureTableViewCell", bundle: nil), forCellReuseIdentifier: "featureCell")
        tableView.allowsSelection = false
    }

    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return features.count
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "featureCell", for: indexPath) as! FeatureTableViewCell

        if indexPath.row < 4 {
            cell.featureTitle.text = features[indexPath.row][0]
            cell.featureText.text = features[indexPath.row][1]
        } else {
            cell.featureDescription.text = features[indexPath.row][0]
        }
        
        return cell
    }
}

