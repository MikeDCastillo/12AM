//
//  UserController.swift
//  12AM
//
//  Created by Nick Reichard on 4/12/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class UserController {
    
    static let shared = UserController()
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    var users: [User] = []
    var appleUserRecordID: CKRecordID?
    
    let currentUserWasSentNotification = Notification.Name("currentUserWasSet")
    
    // More eefficiten when you want to find a user
    var currentUser: User? {
        didSet {
            NotificationCenter.default.post(name: currentUserWasSentNotification, object: self)
        }
    }
    
    // MARK: - CRUD
    func createUserWith(userName: String, email: String, profileImage: UIImage?, appleUserRef: CKReference) {
        let user = User(username: userName, email: email, profileImage: profileImage , appleUserRef: appleUserRef)
        let userRecord = CKRecord(user: user) // Makeing a record of our model from our extension3
        
        publicDB.save(userRecord) { (record, error) in
            if let error = error { print(error.localizedDescription) }
            self.users.append(user)
        }
    }
    
    func updateCurrentUser(username: String, email: String, profileImage: UIImage?, appleUserRef: CKReference) {
        guard let currentUser = currentUser, let profileImage = profileImage else { return }
        
        DispatchQueue.main.async {
            currentUser.username = username
            currentUser.email = email
            currentUser.profileImage = profileImage
        }
    }
}
