//
//  BubbleMessage.swift
//  Bubble
//
//  Created by Developer on 19/11/2018.
//  Copyright © 2018 Developer. All rights reserved.
//

import Foundation

struct BubbleMessage {
    
    let title: String
    var message: String
    var author: Users
    var nbview: Int
    var imageURL : String
    // var Localisation: ???
    
    
    init(title: String,message: String,author: Users, imageURL: String) {
        
        self.title = title
        self.message = message
        self.imageURL = imageURL
        self.author = author
        self.nbview = 0
    }
    
    
}
