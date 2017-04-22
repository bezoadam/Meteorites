//
//  MeteorController.swift
//  Meteorites
//
//  Created by Adam Bezák on 22.4.17.
//  Copyright © 2017 Adam Bezák. All rights reserved.
//

import UIKit
import MapKit

class MeteorController: UIViewController {

    var meteorLocation: CLLocation?
    var mapView: MKMapView!
    var meteor: Meteor? {
        didSet {
            navigationItem.title = meteor?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapKit()
        
    }


    func setupMapKit() {
        let latitude = meteor?.reclat as! NSString
        let longitude = meteor?.reclong as! NSString
        
        mapView = MKMapView()
        
        let leftMargin:CGFloat = 0
        let topMargin:CGFloat = 60
        let mapWidth:CGFloat = view.frame.size.width
        let mapHeight:CGFloat = view.frame.size.height
        
        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
        
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.delegate = self
        mapView.center = view.center
        
        view.addSubview(mapView)
        
        meteorLocation = CLLocation(latitude: latitude.doubleValue, longitude: longitude.doubleValue)
        centerMapOnLocation(location: meteorLocation!)
        
        let meteorAnnotate = MeteorAnnotation(title: (meteor?.name)!, id: (meteor?.id)!, mass: (meteor?.mass)!, date: (meteor?.date)!, coordinate: CLLocationCoordinate2D(latitude: latitude.doubleValue, longitude: longitude.doubleValue))
        mapView.addAnnotation(meteorAnnotate)
    }
    
    let regionRadius: CLLocationDistance = 5000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 10.0, regionRadius * 10.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
}
