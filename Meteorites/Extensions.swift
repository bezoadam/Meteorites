//
//  Extensions.swift
//  Meteorites
//
//  Created by Adam Bezák on 22.4.17.
//  Copyright © 2017 Adam Bezák. All rights reserved.
//

import UIKit
import MapKit

extension Int {
    var stringValue:String {
        return "\(self)"
    }
}

extension MeteorController: MKMapViewDelegate {
    
    // 1
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? MeteorAnnotation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView { // 2
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                let btn = UIButton(type: .detailDisclosure)
                view.rightCalloutAccessoryView = btn as UIView
            }
            return view
        }
        return nil
    }
}
