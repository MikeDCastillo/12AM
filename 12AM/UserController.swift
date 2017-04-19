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
import FBSDKLoginKit

class UserController {
    
    static let shared = UserController()
    
    let publicDB = CKContainer.default().publicCloudDatabase
    let privateDB = CKContainer.default().privateCloudDatabase
    
    var users: [User] = []
    var appleUserRecordID: CKRecordID?
    
    let currentUserWasSentNotification = Notification.Name("currentUserWasSet")
    
    // More efficient when you want to find a user
    var currentUser: User? {
        didSet {
            NotificationCenter.default.post(name: currentUserWasSentNotification, object: self)
        }
    }
    
    // MARK: - CRUD
    
    func createUserWithLogIn(userName: String, email: String, profileImage: UIImage?, password: String, facebookToken: FBSDKAccessToken?, completion: @escaping (User?) -> Void) {
        CKContainer.default().fetchUserRecordID { recordId, error in
            guard let recordId = recordId, error == nil else {
                print("Error creating recordId \(String(describing: error?.localizedDescription))"); return }
            self.appleUserRecordID = recordId
            
            let appleUserRef = CKReference(recordID: recordId, action: .deleteSelf)
            let user = User(username: userName, email: email, profileImage: profileImage, appleUserRef: appleUserRef, password: password, facebookToken: nil)
            let userRecord = CKRecord(user: user)
            
            self.publicDB.save(userRecord) { (record, error) in
               if let record = record, error == nil {
                guard let currentUser = User(cloudKitRecord: record) else { print("Error parsing record into user"); return }
                self.currentUser = currentUser
                completion(currentUser)
                
                
                // TODO: Fix Me
                self.saveUserToPrivateDatabase(userRecord: record, password: password, completion: { 
                    self.privateDB.save(userRecord, completionHandler: { (record, error) in
                        if let record = record, error == nil {
                            guard let currentUser = User(cloudKitRecord: record) else {print("Error saving to private DB"); return}
                            self.currentUser = currentUser
                            completion(currentUser)
                        }
                    })
                })
                
                print("Success")
               } else {
                print( "Error saving user record:\(String(describing: error?.localizedDescription))")
                }
            }
        }
    }
    
    func createUserWithFacebook(userName: String, email: String, profileImage: UIImage?, password: String?, facebookToken: FBSDKAccessToken, completion: @escaping (User?) -> Void) {
        CKContainer.default().fetchUserRecordID { recordId, error in
            guard let recordId = recordId, error == nil else {
                print("Error creating recordId \(String(describing: error?.localizedDescription))"); return }
            self.appleUserRecordID = recordId
            
            let appleUserRef = CKReference(recordID: recordId, action: .deleteSelf)
            let user = User(username: userName, email: email, profileImage: profileImage, appleUserRef: appleUserRef, password: password, facebookToken: nil)
            let userRecord = CKRecord(user: user)
            
            self.publicDB.save(userRecord) { (record, error) in
                if let record = record, error == nil {
                    guard let currentUser = User(cloudKitRecord: record) else { print("Error parsing record into user"); return }
                    self.currentUser = currentUser
                    completion(currentUser)
                    print("Success")
                } else {
                    print( "Error saving user record:\(String(describing: error?.localizedDescription))")
                }
            }
        }
    }

    func saveUserToPrivateDatabase(userRecord: CKRecord, password: String, completion: () -> Void) {
        
    }
    
    func updateCurrentUser(username: String, email: String, profileImage: UIImage?, completion: @escaping (User?) -> Void) {
        guard let currentUser = currentUser, let profileImage = profileImage else { return }
        
        DispatchQueue.main.async {
            currentUser.username = username
            currentUser.email = email
            currentUser.profileImage = profileImage
        }
    }
    
    func checkForEsistingUserWith(username: String, completion: @escaping (Bool) -> Void) {
        let predicate = NSPredicate(format: "username == %@", username)
        
        let query = CKQuery(recordType: username, predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if records?.count == 0 {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    // MARK: - Validate Email Address
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return  returnValue
    }
}


