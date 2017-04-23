//
//  MeteorController.swift
//  Meteorites
//
//  Created by Adam Bezák on 22.4.17.
//  Copyright © 2017 Adam Bezák. All rights reserved.
//

import UIKit
import MapKit
import SideMenu

class MeteorController: UIViewController {

    var meteorLocation: CLLocation?
    var mapView: MKMapView!
    var pointAnnotation:CustomPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    var meteor: Meteor? {
        didSet {
            navigationItem.title = meteor?.name
        }
    }
    
    var meteorites : [Meteor?]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapKit()
        let bookmarksButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.bookmarks, target: self, action: #selector(showAllMeteorites))
        navigationItem.rightBarButtonItem = bookmarksButton
        
        let allMeteoritesVC = allMeteoritesController()
        allMeteoritesVC.meteorites = meteorites
        allMeteoritesVC.parentVC = self
        let menuRightNavigationController = UISideMenuNavigationController(rootViewController: allMeteoritesVC)

        SideMenuManager.menuRightNavigationController = menuRightNavigationController
        SideMenuManager.menuWidth = max(round(min((self.view.frame.width), (self.view.frame.height)) * 0.5), 240)
        
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
    }
    
    func showAllMeteorites() {
        present(SideMenuManager.menuRightNavigationController!, animated: true, completion: nil)
    }

    func reloadRegion() {
        let latitude = meteor?.reclat
        let longitude = meteor?.reclong
        
        meteorLocation = CLLocation(latitude: latitude!, longitude: longitude!)
        centerMapOnLocation(location: meteorLocation!)
    }
    
    func setupMapKit() {
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
    
        reloadRegion()
        
        for i in 1...meteorites.count {
            if let m = meteorites[i - 1]{
                pointAnnotation = CustomPointAnnotation()
                pointAnnotation.pinCustomImageName = "meteor"
                pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: m.reclat, longitude: m.reclong)
                pointAnnotation.title = m.name
                pointAnnotation.subtitle = (m.mass.stringValue) + " g"
                
                pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: "pin")
                mapView.addAnnotation(pinAnnotationView.annotation!)
            }
        }

    }
    
    let regionRadius: CLLocationDistance = 5000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 10.0, regionRadius * 10.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        DispatchQueue.main.async {
            self.mapView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }
    }
}
