//
//  User.swift
//  ToDoFire
//
//  Created by Давид Михайлов on 10.02.2021.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

struct AppUser {
    let uid: String
    let email: String
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email!
    }
    
}
