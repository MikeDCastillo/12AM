//
//  User.swift
//  12AM
//
//  Created by Nick Reichard on 4/11/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
// 

import Foundation
import UIKit
import CloudKit

class User {
    
    static let usernameKey = "username"
    static let emailKey = "email"
    static let appleUserRefKey = "appleUserRef"
    static let recordTypeKey = "User"
    static let imageKey = "image"
    static let typeKey = "Photo"
    
    var username: String
    var email: String
    var profileImage: UIImage?
    var currentTimeZone: String { return TimeZone.current.identifier }

    // This is the reference to the default Apple 'Users' record ID
    let appleUserRef: CKReference
    
    // This is your CUSTOM user record's ID
    var cloudKitRecordID: CKRecordID?
    
    var imageData: Data? {
        guard let image = profileImage, let imageData = UIImageJPEGRepresentation(image, 1.0) else { return nil }
        return imageData
    }
    
    fileprivate var temporaryPhotoURL: URL {
        
        // Must write to temporary direcory to be able to pass image file path url to CKAsset 
        let temporaryDirectory = NSTemporaryDirectory()
        let temporaryDirectoryURL = URL(fileURLWithPath: temporaryDirectory)
        let fileURL = temporaryDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
        
        try? imageData?.write(to: fileURL, options: [.atomic])
     
        return fileURL
    }
    
    // Sign up page. Exists locally - its a new user that doesn't exist yet.
    // To create a instace from a new user
    init(username: String, email: String, profileImage: UIImage?, appleUserRef: CKReference) {
        self.username = username
        self.profileImage = profileImage
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

// So it won't create a new copy or duplicate. // Saving up to cloudKit
extension CKRecord {
    
    convenience init(user: User) {
        
        // check the record id.
        let recordID = user.cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        self.init(recordType: User.recordTypeKey, recordID: recordID)
        self.setValue(user.username, forKey: User.usernameKey)
        self.setValue(user.email, forKey: User.emailKey)
        self.setValue(user.appleUserRef, forKey: User.appleUserRefKey)
        
        guard user.profileImage != nil else { return }
        let imageAsset = CKAsset(fileURL: user.temporaryPhotoURL)
        self.setValue(imageAsset, forKey: User.imageKey)
    }
}


