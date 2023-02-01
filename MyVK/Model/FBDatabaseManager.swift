//
//  FBDatabaseManager.swift
//  MyVK
//
//  Created by Mintimer Kharasov on 16/01/23.
//

import Foundation
import FirebaseDatabase

class FBDatabaseManager {
    
    let dbLink = Database.database().reference()
    
    func addNewUser() {
        dbLink.child("Users").getData { _, snapshot in
            var users: Set<Int> = []
            
            (snapshot?.value as? [Any])?.forEach { userJSON in
                guard let userJSON = userJSON as? [String: Any],
                      let userId = userJSON["userID"] as? Int
                else { return }
                users.insert(userId)
            }
            
            guard !users.contains(Session.instance.userID) else { return }
            
            self.dbLink.child("Users").updateChildValues(["\(users.count)": Session.instance.toAnyObject])
        }
    }
    
    func add(_ group: Group) {
        dbLink.child("Users").getData { error, snapshot in
            var pathForCurrentUser = ""
            guard let value = (snapshot?.value as? [Any]) else { return }
            
            for (index, userJSON) in value.enumerated() {
                guard let userJSON = userJSON as? [String: Any],
                      let userID = userJSON["userID"] as? Int
                else { return }
                if Session.instance.userID == userID {
                    pathForCurrentUser = "Users/\(index)/groups"
                }
            }
            self.dbLink.child(pathForCurrentUser).getData { _, snapshot in
                let index = (snapshot?.value as? [Any])?.count ?? 0
                self.dbLink.child(pathForCurrentUser).updateChildValues(["\(index)": group.toAnyObject])
            }
        }
    }
    
}
