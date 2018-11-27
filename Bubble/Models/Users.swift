//
//  Users.swift
//  Bubble
//
//  Created by Developer on 19/11/2018.
//  Copyright © 2018 Developer. All rights reserved.
//

import Foundation

class Users {
    //var id: Int
    var name: String
    var mail: String
    private var View: [BubbleMessage]
    
    init(name: String, email: String, view: [BubbleMessage] = []) {
        self.name = name
        self.mail = email
        self.View = view
    }
    
    func addToView(_ view: BubbleMessage) {
        View.append(view)
    }
    
    func removeToview(_ view: BubbleMessage){
        var t : Int = 0
        for bub in View{
            if(bub.title == view.title){
                View.remove(at: t)
            }
            t += 1
        }
    }
    var allView: [BubbleMessage] {
        return View
    }
    
}
