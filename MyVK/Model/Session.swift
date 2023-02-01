//
//  Session.swift
//  MyVK
//
//  Created by Минтимер Харасов on 08.01.2023.
//

import Foundation

class Session {
    static let instance = Session()
    
    private init() { }
    
    var token: String = ""
    var userID: Int = 0
    
    var toAnyObject: Any {
        ["userID": userID]
    }
}
