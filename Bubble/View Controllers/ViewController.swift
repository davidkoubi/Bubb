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
        //manager.distanceFilter = 100              Permet d'actualiser la carte tous les 100m
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
        
       
        createBubble()
    }
    
    let address:[[String]] = [["Boris","37.33024596","-122.0279578","200.0","Ceci est un message - 1"],["Naked","37.33024947","-122.0273368","20.0","Ceci est un message - 1"],["Test","37.32475245" ,"-122.02135932","180.0","Ceci est un message - 1"]]
    
    let user = Users(name: "Admin", email: "Admin@gmail.com")
    
    func removeBubble(_ name : String){
        let list = user.allView
        
        for code in list{
            if(name == code.title){
            let title = code.title
            let coordinate = CLLocationCoordinate2DMake(code.latitude,code.longitude)
            let regionRadius = code.radius
            
            let regioncircle = CLCircularRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude,longitude: coordinate.longitude), radius: regionRadius, identifier: title)
            manager.startMonitoring(for: regioncircle)
            
            let Bubble = MKPointAnnotation()
            Bubble.coordinate = coordinate;
            Bubble.title = "\(title)";
            user.removeToview(code)
            mapView.removeAnnotation(Bubble)
                
            }
        }
    }
    
    func addBubble(_ name : String){
        for code in address {
            let title = code[0]
            
            if(title == name){
                //creation de la list
                let regionRadius = Double(code[3])!
                let message = code[4]
                let author = code[0]
                
                let bubbleview = BubbleMessage(title: title, message: message, author: author, latitude:Double(code[1])!, longitude: Double(code[2])!, radius: regionRadius)
                
                //creation list
                user.addToView(bubbleview)
            
            }
        
        }
        
    }
    func createBubble(){
        //lecture list
        let list = user.allView
        
        for code in list{
            
        let title = code.title
        let coordinate = CLLocationCoordinate2DMake(code.latitude,code.longitude)
        let regionRadius = code.radius
            
        let regioncircle = CLCircularRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude,longitude: coordinate.longitude), radius: regionRadius, identifier: title)
        manager.startMonitoring(for: regioncircle)
        
        let Bubble = MKPointAnnotation()
        Bubble.coordinate = coordinate;
        Bubble.title = "\(title)";
        mapView.addAnnotation(Bubble)
         
        }
        
        //Vérification des radius
        // let circle = MKCircle(center: coordinate, radius: regionRadius)
        // MapViewMKMapView.add(circle)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.strokeColor = UIColor.red
        circleRenderer.lineWidth = 1.0
        return circleRenderer
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        removeBubble(region.identifier)
        print("exit \(region.identifier)")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        //Init les point autour de lui
        addBubble(region.identifier)
        print("enter \(region.identifier)")
    }
    
    @IBAction func ButtonAction(_ sender: UIButton) {
        print(user.allView)
    }
}

