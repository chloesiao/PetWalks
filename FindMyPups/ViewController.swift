//
//  ViewController.swift
//  FindMyPups
//
//  Created by iD Student on 8/8/17.
//  Copyright © 2017 iD Tech. All rights reserved.
//

import UIKit
import CoreLocation
import Cluster
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    var pointsOfInterest: [MKPointAnnotation] = []
    var foursquareDataSource: LocationDataStore?
    let locationManager : CLLocationManager = CLLocationManager()
    var location : CLLocationCoordinate2D?
    @IBOutlet weak var userLocation: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    var nearString : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        let clusterManager = ClusterManager()
        let annotation = Annotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 40.7128, longitude: 74.0059)
        
        //Change later so that it can add markers to the different locations 
        annotation.type = .color(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1) , radius: 5)
        
//        var annotationsTestData = []
        
//                locationManager = CLLocationManager()
                locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
                
                
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
        if let location = self.locationManager.location {
            self.location = location.coordinate
        } else {
            location = CLLocationCoordinate2D(latitude: -27.104671, longitude:  -109.360481)
            let annotationEaster = Annotation()
            annotationEaster.coordinate = location!
            
            //Change later so that it can add markers to the different locations
            annotationEaster.type = .color(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1) , radius: 5)
            mapView.addAnnotation(annotationEaster as MKAnnotation)

        }
                print(location)
                print("just printed location")
                
                self.startingMapAtMyLocation(coordinate: location)
                addFoursquareAnnotations() { count in
                    DispatchQueue.main.async {
                        if self.pointsOfInterest.isEmpty {
                            print("oops")
                        } else {
                            for pin in self.pointsOfInterest{
                                self.mapView.addAnnotation(pin)
                            }
                        }
                    }
        }
                
            }

        
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? ClusterAnnotation {
            guard let type = annotation.type else { return nil }
            let identifier = "Lebanon, Kentucky"
            nearString = identifier
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if view == nil {
                view = ClusterAnnotationView(annotation: annotation, reuseIdentifier: identifier, type: type)
            } else {
                view?.annotation = annotation
            }
            return view
            
        }
        return nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }
        // Do any additional setup after loading the view, typically from a nib.
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }
    
    func startingMapAtMyLocation(coordinate : CLLocationCoordinate2D?){
        if let coordinate = coordinate{
            mapView.camera.centerCoordinate = coordinate
            var region = MKCoordinateRegionMake(coordinate, MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
            region.center = coordinate
            mapView.setRegion(region, animated: true)
        }
        mapView.showsUserLocation = true
    }
    


    
    func addFoursquareAnnotations(_ completion: @escaping (_ count: Int) -> ()) {
        
        pointsOfInterest.removeAll()
        
        foursquareDataSource = LocationDataStore()
        
        guard let foursquareDataSource = foursquareDataSource else {
            return
        }
        
        foursquareDataSource.fetchLocationsFromFoursquareWithCompletion(nearString) { success in
            if success {
                for location in foursquareDataSource.foursquareData {
                    print(location)
                    let pin : MKPointAnnotation = MKPointAnnotation()
                    pin.coordinate = CLLocationCoordinate2D(latitude: location.placeLatitude, longitude: location.placeLongitude)
                    pin.title = location.placeName
                    pin.subtitle = location.placeAddress
                    self.pointsOfInterest.append(pin)}
            }
            completion(self.pointsOfInterest.count)
        }
    }

}


