//
//  StartViewController.swift
//  Bubble
//
//  Created by Nathan koubi on 04/12/2018.
//  Copyright © 2018 Developer. All rights reserved.
//
import UIKit

class StartViewController : UIViewController{
    @IBAction func LoginButtonPressed(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "LoginViewController", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
}
