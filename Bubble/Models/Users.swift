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
    
    var allView: [BubbleMessage] {
        return View
    }
}
