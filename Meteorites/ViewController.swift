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

class ViewController: UITableViewController {
    
    var meteorites : [Meteor]!
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Meteorites"
        let manager = DataManager()
        let results = manager.objects(type: Meteor.self)
//        .sort(by: { $0.meetingDate.compare($1.meetingDate) == .orderedAscending})
        meteorites = Array(results!).sorted(by: { $0.mass > $1.mass})
//        manager.deleteAll()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
//        self.tableView.register(MeteorCell.self, forCellReuseIdentifier: cellId)
        
        if meteorites?.count == 0 {
            Service.sharedInstance.fetchData(completion: { (meteorites) in
                self.meteorites = meteorites
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellId) as? MeteorCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellId)
        }
        
        cell?.textLabel?.text = meteorites?[indexPath.row].name
        cell?.detailTextLabel?.text = meteorites?[indexPath.row].mass.stringValue
        cell?.selectionStyle = .none
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (meteorites?.count)!
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension Int {
    var stringValue:String {
        return "\(self)"
    }
}
