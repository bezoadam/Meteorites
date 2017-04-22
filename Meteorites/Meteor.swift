//
//  Meteor.swift
//  Meteorites
//
//  Created by Adam Bezák on 21.4.17.
//  Copyright © 2017 Adam Bezák. All rights reserved.
//

import UIKit
import RealmSwift
import MapKit

class Meteor: Object {
    dynamic var name = ""
    dynamic var nametype = ""
    dynamic var fall = ""
    dynamic var reclat = 0.0
    dynamic var id = 0
    dynamic var reclong = 0.0
    dynamic var date =  Date()
    dynamic var mass = 0
    dynamic var recclass = ""
    dynamic var lastUpdate = NSDate()
}
