//
//  User.swift
//  12AM
//
//  Created by Nick Reichard on 4/11/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.


import UIKit
import CloudKit



class User {
    
    static let usernameKey = "username"
    static let emailKey = "email"
    static let appleUserRefKey = "appleUserRef"
    static let recordTypeKey = "User"
    static let imageKey = "image"
    static let typeKey = "User"
    static let blockUserRefKey = "blockUserRef"
    static let accessTokenKey = "acessToken"
    
    var username: String
    var email: String
    var profileImage: UIImage?
    var currentTimeZone: String { return TimeZone.current.identifier }
    var blockUserRefs: [CKReference]? = []
    var blocUsersArray: [User] = []
    var users: [User] = []
    var posts: [Post] = []
    var appleUserRef: CKReference?
    
    // This is your CUSTOM user record's ID
    var cloudKitRecordID: CKRecordID?
    
    // Facebook
    init?(dictionary: [String: Any], blockUserRefs: [CKReference]? = []) {
        //FIXME: - add imageURL
        guard let username = dictionary["name"] as? String,
        let email = dictionary["email"] as? String,
        let profileImage = dictionary["picture"] as? UIImage else { return nil }
        
        self.username = username
        self.email = email
        self.profileImage = profileImage
        self.blockUserRefs = blockUserRefs
    }

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
    init(username: String, email: String, profileImage: UIImage?, appleUserRef: CKReference, blockUserRefs: [CKReference]? = []) {
        self.username = username
        self.profileImage = profileImage
        self.email = email
        self.appleUserRef = appleUserRef
        self.blockUserRefs = blockUserRefs
    }
    

    // FetchLogedInUserRcord - this is for fetching
    init?(cloudKitRecord: CKRecord) {
        guard let username = cloudKitRecord[User.usernameKey] as? String,
            let email = cloudKitRecord[User.emailKey] as? String,
            let appleUserRef = cloudKitRecord[User.appleUserRefKey] as? CKReference
            else { return nil }
        
        self.blockUserRefs = cloudKitRecord[User.blockUserRefKey] as? [CKReference] ?? []
       
        
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
        self.setValue(user.blockUserRefs, forKey: User.blockUserRefKey)
        guard user.profileImage != nil else { return }
        let imageAsset = CKAsset(fileURL: user.temporaryPhotoURL)
        self.setValue(imageAsset, forKey: User.imageKey)
    }
}


