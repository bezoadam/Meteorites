//
//  ViewController.swift
//  Meteorites
//
//  Created by Adam Bezák on 21.4.17.
//  Copyright © 2017 Adam Bezák. All rights reserved.
//

import UIKit
import TRON
import SwiftyJSON
import RealmSwift
import DynamicColor

class ViewController: UITableViewController {
    
    var meteorites : [Meteor]?
    let originalColor = DynamicColor(hexString: "#c0392b")
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Meteorites"
        let manager = DataManager()
//        smanager.deleteAll()
        
        if let results = manager.objects(type: Meteor.self) {
            self.meteorites = Array(results).sorted(by: { $0.mass > $1.mass})
            if (self.meteorites?.count)! > 0 && InternetReachability.isConnectedToNetwork(){
                let oneMeteorLastUpdateTime = Int32((self.meteorites?[0].lastUpdate.timeIntervalSinceNow)!)
                if abs(oneMeteorLastUpdateTime) > 86400 {
                    manager.deleteAll()
                    Service.sharedInstance.fetchData(completion: { (meteorites, err) in
                        let manager = DataManager()
                        
                        for m in meteorites! {
                            manager.add(meteor: m)
                        }
                        self.meteorites = Array(meteorites!).sorted(by: { $0.mass > $1.mass})
                        self.tableView.dataSource = self
                        self.tableView.delegate = self
                        self.tableView.reloadData()
                    })
                }
            }
        }
        
        self.tableView.backgroundColor = originalColor.lighter(amount: 0.5)
        
        if self.meteorites?.count == 0 {
            Service.sharedInstance.fetchData(completion: { (meteorites, err) in
                let manager = DataManager()
                
                for m in meteorites! {
                    manager.add(meteor: m)
                }
                
                self.meteorites = Array(meteorites!).sorted(by: { $0.mass > $1.mass})
                self.tableView.dataSource = self
                self.tableView.delegate = self
                self.tableView.reloadData()
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellId) as? MeteorCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellId)
        }
        
        cell?.textLabel?.text = meteorites?[indexPath.row].name
        cell?.detailTextLabel?.text = (meteorites?[indexPath.row].mass.stringValue)! + " g"
        cell?.backgroundColor = originalColor.lighter(amount: 0.45)
        cell?.selectionStyle = .none
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (meteorites!.count)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMeteor = meteorites?[indexPath.row]
        let vc = MeteorController()
        vc.meteor = selectedMeteor
        vc.meteorites = meteorites
        tableView.deselectRow(at: indexPath, animated: false)
        navigationController?.pushViewController(vc, animated: true)
    }
}


