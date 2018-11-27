//
//  BubbleMessage.swift
//  Bubble
//
//  Created by Developer on 19/11/2018.
//  Copyright © 2018 Developer. All rights reserved.
//

import Foundation

struct BubbleMessage {
    
   // var id : Int
    let title: String
    var message: String
    var author: String
    var nbview: Int
    //var imageURL : String
    var latitude: Double
    var longitude : Double
    var radius : Double
    
    
    init(title: String,message: String,author: String, latitude :Double,longitude :Double, radius:Double ){
     
        self.title = title
        self.message = message
        self.latitude = latitude
        self.longitude = longitude
        self.radius = radius
        self.author = author
        self.nbview = 0
    }
    
    
}
