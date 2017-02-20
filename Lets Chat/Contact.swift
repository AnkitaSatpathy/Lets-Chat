//
//  Contact.swift
//  Lets Chat
//
//  Created by Ankita Satpathy on 10/02/17.
//  Copyright © 2017 Ankita Satpathy. All rights reserved.
//

import Foundation

class Contact {
    
    private var _name = ""
    private var _id = ""
    
    init(id: String , name: String) {
        _id = id
        _name = name
    }
    
    var name : String {
        get {
            return _name
        }
    }
    
    var id:String {
        return _id
    }
}
