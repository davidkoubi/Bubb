//
//  GeolViewController.swift
//  Bubble
//
//  Created by Pierre on 03/12/2018.
//  Copyright © 2018 Pierre. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Parse

class GeolViewController: UIViewController , CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let manager = CLLocationManager()
    var selectedAnnotation: MKAnnotation?
    
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        //manager.distanceFilter = 100
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        mapView.delegate = self
        
        displayUserBubble()
        //displaySeenBubble()
        monitoringRegions()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let location = locations[0]
    
        let span : MKCoordinateSpan = MKCoordinateSpan.init(latitudeDelta:0.01, longitudeDelta:0.01)
        
        let myLocation :CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
       
        let region :MKCoordinateRegion = MKCoordinateRegion.init(center:myLocation, span:span)
        
        mapView.setRegion(region, animated: true)
       
        self.mapView.showsUserLocation = true
    }
    
    func removeBubble(_ region : CLRegion){
        
        if let region = region as? CLCircularRegion
        {
            let bubble = MKPointAnnotation()
            bubble.coordinate = region.center
            bubble.title = region.identifier
        
            mapView.removeAnnotation(bubble)
        }
    }
    
    func addBubble(_ region : CLRegion){
        
        if let region = region as? CLCircularRegion
        {
            let bubble = MKPointAnnotation()
            bubble.coordinate = region.center
            bubble.title = region.identifier
        
            mapView.addAnnotation(bubble)
            let circle = MKCircle(center: region.center, radius: region.radius)
            mapView.addOverlay(circle)
        }
    }
    
    func displayUserBubble()
    {
        let user = PFUser.current()
        let query = PFQuery(className:"Bubble")
        query.whereKey("UserId", equalTo:user?.objectId)
        query.findObjectsInBackground { (objects: [PFObject]?, error:Error?) in
            
            if let err = error
            {
                print(err.localizedDescription)
            }
            else if let userBubble = objects
            {
                print("Displaying users bubb. Totat: \(userBubble.count)")
                
                if(userBubble.count != 0)
                {
                    for bubble in userBubble
                    {
                        print(bubble.object(forKey: "Title") as! String)
                        
                        let title = bubble.object(forKey: "Title") as! String
                        let coordinate = CLLocationCoordinate2DMake(bubble.object(forKey: "Latitude") as! CLLocationDegrees, bubble.object(forKey: "Longitude") as! CLLocationDegrees)
                        
                        let regionRadius = bubble.object(forKey: "Area") as! CLLocationDistance
                        
                        let regioncircle = CLCircularRegion(center: CLLocationCoordinate2D(latitude: bubble.object(forKey: "Latitude") as! CLLocationDegrees, longitude: bubble.object(forKey: "Longitude") as! CLLocationDegrees), radius: regionRadius, identifier: title)
                        
                        //self.manager.startMonitoring(for: regioncircle)
                        
                        let mapBubble = MKPointAnnotation()
                        mapBubble.coordinate = coordinate
                        mapBubble.title = title
                        mapBubble.subtitle = bubble.object(forKey: "Message") as! String
                        self.mapView.addAnnotation(mapBubble)
                        let circle = MKCircle(center: coordinate, radius: regionRadius)
                        self.mapView.addOverlay(circle)
                    
                    }
                }
            }
        }
    }
    
    
    
    func monitoringRegions()
    {
        let user = PFUser.current()
        let query = PFQuery(className:"Bubble")
        query.whereKey("UserId", notEqualTo:user?.objectId)
        query.findObjectsInBackground { (objects: [PFObject]?, error:Error?) in
            
            if let err = error
            {
                print(err.localizedDescription)
            }
            else if let bubbles = objects
            {
                print("Monitoring for regions. Totat: \(bubbles.count)")
                
                if(bubbles.count != 0)
                {
                    for bubble in bubbles
                    {
                        print(bubble.object(forKey: "Title") as! String)
                        
                        let title = bubble.object(forKey: "Title") as! String
                        
                        let regionRadius = bubble.object(forKey: "Area") as! CLLocationDistance
                        
                        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: bubble.object(forKey: "Latitude") as! CLLocationDegrees, longitude: bubble.object(forKey: "Longitude") as! CLLocationDegrees), radius: regionRadius, identifier: title)
                        
                        region.notifyOnEntry = true
                        region.notifyOnExit = true
                        self.manager.startMonitoring(for: region)
                        
                    }
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.strokeColor = UIColor.red
        circleRenderer.lineWidth = 1.0
        return circleRenderer
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        selectedAnnotation = view.annotation as? MKPointAnnotation
    }
    
   func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        removeBubble(region)
        print("exit \(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        //Init les point autour de lui
        addBubble(region)
        print("enter \(region.identifier)")
    }
    
    @IBAction func Add(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let addBubble = storyBoard.instantiateViewController(withIdentifier: "AddBubb") as! AddBubbViewController
        self.present(addBubble, animated: true, completion: nil)
    }
    
    @IBAction func View(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let bubbleDetails = storyBoard.instantiateViewController(withIdentifier: "BubbleDetails") as! BubbleDetailsViewController
        
        if selectedAnnotation == nil { return }
        
        bubbleDetails.bubbleTitle = selectedAnnotation?.title as! String
        bubbleDetails.bubbleMessage = selectedAnnotation?.subtitle as! String
            
        self.present(bubbleDetails, animated: true, completion: nil)
    }
}

/*
 func displaySeenBubble()
 {
 let user = PFUser.current()
 let query = PFQuery(className:"BubbleView")
 query.whereKey("UserId", equalTo:user?.objectId)
 query.findObjectsInBackground { (objects: [PFObject]?, error:Error?) in
 
 if let err = error
 {
 print(err.localizedDescription)
 }
 else if let bubbleViews = objects
 {
 if(bubbleViews.count != 0)
 {
 for bubbleView in bubbleViews
 {
 let query = PFQuery(className:"Bubble")
 query.whereKey("objectId", equalTo:bubbleView.object(forKey: "BubbleId") as! String)
 query.findObjectsInBackground { (objects: [PFObject]?, error:Error?) in
 
 if let err = error
 {
 print(err.localizedDescription)
 }
 else if let seenBubble = objects
 {
 print("Displaying seen bubb. Totat: \(seenBubble.count)")
 
 if(seenBubble.count != 0)
 {
 for bubble in seenBubble
 {
 print(bubble.object(forKey: "Title") as! String)
 
 let title = bubble.object(forKey: "Title") as! String
 let coordinate = CLLocationCoordinate2DMake(bubble.object(forKey: "Latitude") as! CLLocationDegrees, bubble.object(forKey: "Longitude") as! CLLocationDegrees)
 
 let regionRadius = bubble.object(forKey: "Area") as! CLLocationDistance
 
 let regioncircle = CLCircularRegion(center: CLLocationCoordinate2D(latitude: bubble.object(forKey: "Latitude") as! CLLocationDegrees, longitude: bubble.object(forKey: "Longitude") as! CLLocationDegrees), radius: regionRadius, identifier: title)
 
 self.manager.startMonitoring(for: regioncircle)
 
 let mapBubble = MKPointAnnotation()
 mapBubble.coordinate = coordinate
 mapBubble.title = title
 self.mapView.addAnnotation(mapBubble)
 let circle = MKCircle(center: coordinate, radius: regionRadius)
 self.mapView.addOverlay(circle)
 }
 }
 }
 }
 }
 }
 }
 }
 }
 */
