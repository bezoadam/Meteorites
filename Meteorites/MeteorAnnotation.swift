//
//  MeteorAnnotation.swift
//  Meteorites
//
//  Created by Adam Bezák on 22.4.17.
//  Copyright © 2017 Adam Bezák. All rights reserved.
//

import UIKit
import MapKit

class MeteorAnnotation: NSObject, MKAnnotation {
    let title: String?
    let id: Int
    let mass: Int
    let date: Date
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, id: Int, mass: Int, date: Date, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.id = id
        self.mass = mass
        self.date = date
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return title
    }
}
