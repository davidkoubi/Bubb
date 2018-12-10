//
//  AddBubbViewController.swift
//  Bubble
//
//  Created by Pierre on 09/12/2018.
//  Copyright © 2018 Pierre. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import Parse

class AddBubbViewController: UIViewController , CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    @IBOutlet weak var areaSlider: UISlider!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTextField.text = ""
        titleTextField.text = ""
        areaSlider.value = 1;
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
    }
    
    @IBAction func Back(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let home = storyBoard.instantiateViewController(withIdentifier: "Home") as! GeolViewController
        self.present(home, animated: true, completion: nil)
    }
    
    @IBAction func AddBubble(_ sender: Any) {
        
        let user = PFUser.current()
        if(messageTextField.text == "" || titleTextField.text == "" || user == nil) { return }
        
        var bubble = PFObject(className:"Bubble")
        bubble["Title"] = titleTextField.text
        bubble["Message"] = messageTextField.text
        bubble["UserId"] = user?.objectId
        bubble["Area"] = areaSlider.value
        bubble["Longitude"] = manager.location?.coordinate.longitude
        bubble["Latitude"] = manager.location?.coordinate.latitude
        
        bubble.saveInBackground { (success, error) in
            if success{
                print("Success")
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let home = storyBoard.instantiateViewController(withIdentifier: "Home") as! GeolViewController
                self.present(home, animated: true, completion: nil)
                
            }else{
                if let description = error?.localizedDescription{
                    print(description)
                }
            }
        }
        
        
    }
}
