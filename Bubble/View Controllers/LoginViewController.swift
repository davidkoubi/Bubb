//
//  LoginViewController.swift
//  Bubble
//
//  Created by Nathan koubi on 04/12/2018.
//  Copyright © 2018 Developer. All rights reserved.
//

import Foundation
import UIKit
import Parse

class LoginViewController : UIViewController {
    
    @IBOutlet fileprivate var SigninUsernameField: UITextField!
    @IBOutlet fileprivate var SigninPasswordField: UITextField!
    @IBOutlet fileprivate var LoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        SigninUsernameField.text = ""
        SigninPasswordField.text = ""
        view.backgroundColor = blue_theme
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        let sv = UIViewController.displaySpinner(onView: self.view)
        PFUser.logInWithUsername(inBackground: SigninUsernameField.text!, password: SigninPasswordField.text!) { (user, error) in
            UIViewController.removeSpinner(spinner: sv)
            if user != nil {
                self.loadHomeScreen()
            }else{
                if let descrip = error?.localizedDescription{
                    self.displayErrorMessage(message: (descrip))
                }
            }
        }
    }
    
    func loadHomeScreen(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loggedInViewController = storyBoard.instantiateViewController(withIdentifier: "LoggedInViewController") as! LoggedInViewController
        self.present(loggedInViewController, animated: true, completion: nil)
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
}
