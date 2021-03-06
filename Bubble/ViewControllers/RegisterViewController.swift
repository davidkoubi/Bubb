//
//  RegisterViewController.swift
//  Bubble
//
//  Created by Pierre on 03/12/2018.
//  Copyright © 2018 Pierre. All rights reserved.
//


import UIKit
import MapKit
import CoreLocation
import Parse

class RegisterViewController : UIViewController {
    
    
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var ConfirmedPasswordTextField: UITextField!
    @IBOutlet fileprivate var RegisterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UsernameTextField.text = ""
        PasswordTextField.text = ""
        //view.backgroundColor = blue_theme
    }
    
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
    
    @IBAction func signUp(_ sender: UIButton) {
        let user = PFUser()
        user.username = UsernameTextField.text
        user.password = PasswordTextField.text
        let sv = UIViewController.displaySpinner(onView: self.view)
        user.signUpInBackground { (success, error) in
            UIViewController.removeSpinner(spinner: sv)
            if success{
                print("Success")
                self.loadHomeScreen()
            }else{
                print("Error")
                if let descrip = error?.localizedDescription{
                    self.displayErrorMessage(message: descrip)
                }
            }
        }
    }
    
    func loadHomeScreen(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let home = storyBoard.instantiateViewController(withIdentifier: "Home") as! GeolViewController
        self.present(home, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let currentUser = PFUser.current()
        if currentUser != nil {
            loadHomeScreen()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ConnectButton(_ sender: Any) {
        
}

}
