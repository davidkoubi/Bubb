//
//  ViewController.swift
//  Bubble
//
//  Created by Pierre on 03/12/2018.
//  Copyright © 2018 Pierre. All rights reserved.
//
import UIKit
import MapKit
import CoreLocation
import Parse
import Foundation

class LoginViewController: UIViewController{
    func displayErrorMessage(message:String) {
        let alertView = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
        }
        alertView.addAction(OKAction)
        if let presenter = alertView.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }
        self.present(alertView, animated: true, completion:nil)
    }
    
    func loadLoginScreen(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func logoutOfApp(_ sender: UIButton) {
        let sv = UIViewController.displaySpinner(onView: self.view)
        PFUser.logOutInBackground { (error: Error?) in
            UIViewController.removeSpinner(spinner: sv)
            if (error == nil){
                self.loadLoginScreen()
            }else{
                if let descrip = error?.localizedDescription{
                    self.displayErrorMessage(message: descrip)
                }else{
                    self.displayErrorMessage(message: "error logging out")
                }
                
            }
        }
    }
}

