//
//  allMeteoritesController.swift
//  Meteorites
//
//  Created by Adam Bezák on 23.4.17.
//  Copyright © 2017 Adam Bezák. All rights reserved.
//

import UIKit
import DynamicColor

class allMeteoritesController: UITableViewController {

    let cellId = "cellId"
    let originalColor = DynamicColor(hexString: "#c0392b")
    var meteorites: [Meteor?]!
    weak var parentVC : MeteorController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        navigationController?.navigationBar.isTranslucent = false
        tableView.backgroundColor = originalColor.lighter(amount: 0.5)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return meteorites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let meteor = meteorites?[indexPath.row] {
            var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellId) as? MeteorCell
            if cell == nil {
                cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellId)
            }
            
            cell?.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 17)
            cell?.textLabel?.text = meteor.name
            cell?.detailTextLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 10)
            cell?.detailTextLabel?.text = (meteor.mass.stringValue) + " g"
            cell?.backgroundColor = originalColor.lighter(amount: 0.45)
            cell?.selectionStyle = .none
            return cell!
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMeteor = meteorites?[indexPath.row]
        parentVC?.meteor = selectedMeteor
        parentVC?.reloadRegion()
        dismiss(animated: true, completion: nil)
    }
}
