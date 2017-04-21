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
    
    var meteorites : [Meteor]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let manager = DataManager()
        let results = manager.objects(type: Meteor.self)
        meteorites = Array(results!)
        manager.deleteAll()
        if meteorites?.count == 0 {
            Service.sharedInstance.fetchData(completion: { (meteorites) in
                self.meteorites = meteorites
                print(self.meteorites?.count)
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

