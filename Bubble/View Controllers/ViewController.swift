//
//  ViewController.swift
//  Bubble
//
//  Created by Developer on 19/11/2018.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController , CLLocationManagerDelegate, MKMapViewDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    let manager = CLLocationManager()
    
   
    override func viewDidLoad() {
      
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 100
       //manager.requestWhenInUseAuthorization()
       manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        // Do any additional setup after loading the view, typically from a nib.
        
        mapView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        super.viewDidLoad()
        //Select current location
        let location = locations[0]
        //Select precision
        let span : MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        //Create current location
        let myLocation :CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        //Create region
        let region :MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        
        //print(location.coordinate.latitude, location.coordinate.longitude)
        
        //Set up region our map with map sliding
        mapView.setRegion(region, animated: true)
        //Show User on map
        self.mapView.showsUserLocation = true
        
        //Init les point autour de lui
        //addBubble()
        
    }
    
    let address:[[String]] = [["Boris","37.33024596","-122.0279578","200.0"],["Naked","37.33024947","-122.0273368","20.0"],["Test","37.32475245" ,"-122.02135932","180.0"]]
    
    func addBubble(_ name : String){
        
        for code in address {
            let title = code[0]
            
            
            if(title == name){
                let coordinate = CLLocationCoordinate2DMake(Double(code[1])!,Double(code[2])!)
                let regionRadius = Double(code[3])!
                let regioncircle = CLCircularRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude,longitude: coordinate.longitude), radius: regionRadius, identifier: title)
            
            manager.startMonitoring(for: regioncircle)
            
            let Bubble = MKPointAnnotation()
            Bubble.coordinate = coordinate;
            Bubble.title = "\(title)";
            mapView.addAnnotation(Bubble)
                
                //Vérification des radius
                // let circle = MKCircle(center: coordinate, radius: regionRadius)
                // MapViewMKMapView.add(circle)
            }
            
          
        
        }
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.strokeColor = UIColor.red
        circleRenderer.lineWidth = 1.0
        return circleRenderer
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        print("exit \(region.identifier)")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        //Init les point autour de lui
        addBubble(region.identifier)
        print("enter \(region.identifier)")
    }
}

