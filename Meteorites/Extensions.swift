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

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        let customPointAnnotation = annotation as! CustomPointAnnotation
        annotationView?.image = UIImage(named: customPointAnnotation.pinCustomImageName)
        
        return annotationView
    }
}

protocol OptionalType {
    associatedtype Wrapped
    func map<U>(_ f: (Wrapped) throws -> U) rethrows -> U?
}

extension Optional: OptionalType {}

extension Sequence where Iterator.Element: OptionalType {
    func removeNils() -> [Iterator.Element.Wrapped] {
        var result: [Iterator.Element.Wrapped] = []
        for element in self {
            if let element = element.map({ $0 }) {
                result.append(element)
            }
        }
        return result
    }
}
