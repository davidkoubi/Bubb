//
//  BubbleDetailsViewController.swift
//  Bubble
//
//  Created by Pierre on 09/12/2018.
//  Copyright © 2018 Pierre. All rights reserved.
//

import Foundation
import UIKit

class BubbleDetailsViewController : UIViewController {
    
    var bubbleTitle: String = ""
    var bubbleMessage: String = ""
    
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBAction func Back(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let home = storyBoard.instantiateViewController(withIdentifier: "Home") as! GeolViewController
        self.present(home, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTitle.text = bubbleTitle
        labelMessage.text = bubbleMessage
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
