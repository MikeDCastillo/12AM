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
    
    var appleUserRecordID: CKRecordID?
    var blockUserRef: [CKReference]? = []
    var users: [User] = []
    var dict : [String : AnyObject]?
    // More efficient when you want to find a user
    var currentUser: User?
    
    let currentUserWasSentNotification = Notification.Name("currentUserWasSet")
    
    // MARK: - CRUD
    
    func fetchCurrentUser(completion: @escaping (User?) -> Void) {
        CKContainer.default().fetchUserRecordID { (appleUserRecordID, error) in
            if let error = error { print("Error fetching user: \(error.localizedDescription)") }
            guard let appleUserRecordID = appleUserRecordID else { return }
            let appleUserRef = CKReference(recordID: appleUserRecordID, action: .none)
            let predicate = NSPredicate(format: "appleUserRef == %@", appleUserRef)
            let query = CKQuery(recordType: "User", predicate: predicate)
            
            CloudKitManager.shared.publicDatabase.perform(query, inZoneWith: nil, completionHandler: { (records, error) in
                if let error = error { print(" Cannot perform query user record\(error.localizedDescription)")}
                
                guard let records = records else { return }
                let users = records.flatMap { User(cloudKitRecord: $0)}
                let user = users.first
                self.currentUser = user
                print("Fetched loged in user")
                completion(user)
            })
        }
    }
    
    func createUser(with userName: String, email: String, profileImage: UIImage?, blockedUserRef: [CKReference]? = [], completion: @escaping (User?) -> Void) {
        CKContainer.default().fetchUserRecordID { recordId, error in
            guard let recordId = recordId, error == nil else {
                print("Error creating recordId \(String(describing: error?.localizedDescription))"); return }
            self.appleUserRecordID = recordId
            let appleUserRef = CKReference(recordID: recordId, action: .deleteSelf)
            guard let blockUserRef = self.blockUserRef else { return }
            
            let user = User(username: userName, email: email, profileImage: profileImage, appleUserRef: appleUserRef, blockUserRefs: blockUserRef)
            let userRecord = CKRecord(user: user)
            
            self.publicDB.save(userRecord) { (record, error) in
                if let record = record, error == nil {
                    let currentUser = User(cloudKitRecord: record)
                    self.currentUser = currentUser
                    completion(currentUser)
                    
                    print("Success creating user")
                } else {
                    print( "Error saving user record:\(String(describing: error?.localizedDescription))")
                }
            }
        }
    }
    
    func createUserWithFacebook(userName: String, email: String, profileImage: UIImage?, blockedUser: [CKReference?] = [], completion: @escaping (User?) -> Void) {
        CKContainer.default().fetchUserRecordID { recordId, error in
            guard let recordId = recordId, error == nil else {
                print("Error creating recordId \(String(describing: error?.localizedDescription))"); return }
            self.appleUserRecordID = recordId
            
            let appleUserRef = CKReference(recordID: recordId, action: .deleteSelf)
            guard let blockUserRef = self.blockUserRef else { return }
            let user = User(username: userName, email: email, profileImage: profileImage, appleUserRef: appleUserRef, blockUserRefs: blockUserRef)
            let userRecord = CKRecord(user: user)
            
            self.publicDB.save(userRecord) { (record, error) in
                if let record = record, error == nil {
                    guard let currentUser = User(cloudKitRecord: record) else { print("Error parsing record into user with facebook"); return }
                    self.currentUser = currentUser
                    completion(currentUser)
                    print("Success")
                } else {
                    print( "Error saving user record:\(String(describing: error?.localizedDescription))")
                }
            }
        }
    }
    
    func blockUser(userToBlock: CKReference, completion: @escaping () -> Void) {
        self.currentUser?.blockUserRefs?.append(userToBlock)
        guard let currentUser = currentUser else { return }
        let record = CKRecord(user: currentUser)
        
        CloudKitManager.shared.modifyRecords([record], perRecordCompletion: nil) { (records, error) in
            if let error = error {
                print("Error modifying record for blocked user \(error.localizedDescription)")
            } else {
                completion()
            }
        }
    }
    
    // MARK: - TODO: - Set up private DB for blocked users
    func saveUserToPrivateDatabase(userRecord: CKRecord, password: String, completion: () -> Void) {
        
    }
    
    func updateCurrentUser(username: String, email: String, profileImage: UIImage?, completion: @escaping (User?) -> Void) {
        guard let currentUser = currentUser else { return }
        DispatchQueue.main.async {
            currentUser.username = username
            currentUser.email = email
            currentUser.profileImage = profileImage
        }
        completion(currentUser)
    }
    
    static func modifyRecord(updatedRecord: CKRecord ,recordIdToModify: CKRecordID ) {
        
        let operation = CKModifyRecordsOperation(recordsToSave: [updatedRecord], recordIDsToDelete: [recordIdToModify])
        
        operation.savePolicy = .changedKeys
        operation.queuePriority = .high
        operation.qualityOfService = .userInteractive
        
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    func updateCurrentUser2(user: User, completion: @escaping() -> Void) {
        let record = CKRecord(user: user)
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        CloudKitManager.shared.publicDatabase.add(operation)
        completion()
    }
    
    func updateUserInCloudKit(completion: @escaping () -> Void) {
        guard let currentUser = currentUser else { completion(); print("Cannot update currentUser in CK"); return }
        
        let record = CKRecord(user: currentUser)
        var records: [CKRecord] = []
        records.append(record)
        
        CloudKitManager.shared.modifyRecords(records, perRecordCompletion: nil) { (records, error) in
            if let error = error {
                print("Cannot modify user record \(error.localizedDescription)")
                completion(); return
            }
            completion()
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
}
