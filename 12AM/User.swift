//
//  User.swift
//  12AM
//
//  Created by Nick Reichard on 4/11/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import Foundation
import CloudKit

class User {
    
    static let usernameKey = "username"
    static let emailKey = "email"
    static let appleUserRefKey = "appleUserRef"
    static let recordTypeKey = "User"
    
    var username: String
    var email: String
    
    
    // This is the reference to the default Apple 'Users' record ID
    let appleUserRef: CKReference
    
    // This is your CUSTOM user record's ID
    var cloudKitRecordID: CKRecordID?
    
    // Sign up page. Exists locally - its a new user that doesn't exist yet.
    // To create a instace from a new user
    init(username: String, email: String, age: String, appleUserRef: CKReference) {
        self.username = username
        self.email = email
        self.appleUserRef = appleUserRef
    }
    
    // FetchLogedInUserRcord - this is for fetching
    init?(cloudKitRecord: CKRecord) {
        guard let username = cloudKitRecord[User.usernameKey] as? String,
            let email = cloudKitRecord[User.emailKey] as? String,
            let appleUserRef = cloudKitRecord[User.appleUserRefKey] as? CKReference else { return nil }
        
        self.username = username
        self.email = email
        
        self.appleUserRef = appleUserRef
        self.cloudKitRecordID = cloudKitRecord.recordID
    }
}

// So it won't create a new copy or duplicate
// Saving up to cloudKit

extension CKRecord {
    
    // Apple gave us this CKRecord. The extension alows ups to add things on to it. More costomized!!! Awesome!!!
    //cunck of clay. like objective - C
    // When you want to add something to the original object
    convenience init(user: User) {
        
        // check the record id.
        let recordID = user.cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        self.init(recordType: User.recordTypeKey, recordID: recordID)
        self.setValue(user.username, forKey: User.usernameKey)
        self.setValue(user.email, forKey: User.emailKey)
        self.setValue(user.appleUserRef, forKey: User.appleUserRefKey)
        
    }
}
