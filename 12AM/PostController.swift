//
//  PostController.swift
//  12AM
//
//  Created by Josh & Erica on 4/12/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

extension PostController {
    static let PostChangeNotified = Notification.Name("PostChangeNotified")
    static let PostCommentsChangedNotification = Notification.Name("PostCommentsChangedNotification")
}

// Could post equal everything posted between current.timeintervalsince1970 rounded down to the nearest hour andcurrent.timeintervalsince1970 rounded up to the nearest hour?

class PostController {
    
    //MARK: - Variables
    
    static let sharedController = PostController()
    
    var posts = [Post]()
    
    var filteredPosts: [Post] {
        
        return self.posts.sorted(by: { $0.0.timestamp > $0.1.timestamp } )
    }
    
    var comments = [Comment]()
    
    var sortedPost: [Post] {
        return posts.sorted(by: { return $0.timestamp.compare($1.timestamp) == .orderedDescending })
    }
    
    var cloudKitManager = CloudKitManager()
    
    var isSyncing: Bool = false
    
    //MARK: - CRUD
    
    // Create Post Function
    func createPost(image: UIImage, caption: String, completion: @escaping ((Post?) -> Void)) {
        // Sets image property of jpeg
        guard let data = UIImageJPEGRepresentation(image, 1),
            let currentUser = UserController.shared.currentUser, let currentUserRecordID = currentUser.cloudKitRecordID
            else { return }
        let ownerReference = CKReference(recordID: currentUserRecordID, action: .none)
        let post = Post(photoData: data, text: caption, owner: currentUser, ownerReference: ownerReference)
        
        // Adds post to first cell
        posts.insert(post, at: 0)
        
        let record = CKRecord(post)
        
        // Saves post to CloudKit or gives error
        cloudKitManager.saveRecord(record) { (record, error) in
            
            if let error = error {
                print("Error saving new post to CloudKit: \(error.localizedDescription)")
            }
            
            guard let record = record
                else { return }
            
            post.cloudKitRecordID = record.recordID
            completion(post)
        }
    }
    
    
    // Add Comments to posts function
    func addComment(post: Post, commentText: String, completion: @escaping ((Comment) -> Void) = { _ in }) -> Comment {
        let comment = Comment(text: commentText, post: post)
        post.comments.append(comment)
        
        cloudKitManager.saveRecord(CKRecord(comment)) { (record, error) in
            if let error = error {
                print("Error saving new comment in CloudKit: \(error)")
            }
            comment.cloudKitRecordID = record?.recordID
            completion(comment)
        }
        
        DispatchQueue.main.async {
            let nc = NotificationCenter.default
            nc.post(name: PostController.PostCommentsChangedNotification, object: post)
        }
        return comment
    }
    
    //MARK: -Synced functions that will help grab records synced in CloudKit. Saves on data and time.
    
    // Check for specified post and comments
    private func recordsOf(type: String) -> [CloudKitSyncable] {
        switch type {
        case "Post":
            return posts.flatMap { $0 as CloudKitSyncable }
        case "Comment":
            return comments.flatMap { $0 as CloudKitSyncable }
        default:
            return []
        }
    }
    
    // Checking to see if those posts have synced or not
    func syncedRecords(ofType type: String) -> [CloudKitSyncable] {
        return recordsOf(type: type).filter { $0.isSynced }
    }
    
    func unsyncedRecords(ofType type: String) -> [CloudKitSyncable] {
        return recordsOf(type: type).filter { !$0.isSynced }
    }
    
    
    // Fetching new post only. Say there are 1,000 posts and 500 are on the phone and 500 are in CloudKit, using the above functions will help retriee only the 500 not on the phone saving data and time
    func fetchNewRecords(ofType type: String, completion: @escaping (() -> Void) = { _ in }) {
        
        var referencesToExclude = [CKReference]()
        let midnight = TimeTracker.shared.midnight.timeIntervalSince1970
        let midnightDate = NSDate(timeIntervalSince1970: midnight)
        let oneAM = TimeTracker.shared.midnight.timeIntervalSince1970 + 3600
        let oneAMDate = NSDate(timeIntervalSince1970: oneAM)
        
        referencesToExclude = self.syncedRecords(ofType: type).flatMap {$0.cloudKitReference}
        var predicate = NSPredicate(format: "NOT(recordID IN %@)", argumentArray: [referencesToExclude])
//        if referencesToExclude.isEmpty {
//            if type == "Post" {
//                let startingTimePredicate = NSPredicate(format: "timestamp > %@", midnightDate)
//                let endingTimePredicate = NSPredicate(format: "timestamp < %@", oneAMDate)
//                
//                predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [startingTimePredicate, endingTimePredicate])
//            } else {
                predicate = NSPredicate(value: true)
//            }
        
//        }
        
        cloudKitManager.fetchRecordsWithType(type, predicate: predicate, recordFetchedBlock: nil) { (records, error) in
            guard let records = records else { return }
            switch type {
            case User.typeKey:
                let users = records.flatMap { User(cloudKitRecord: $0) }
                UserController.shared.users = users
                completion()
            case Post.typeKey:
                let posts = records.flatMap { Post(record: $0) }
                self.posts = posts
                completion()
            case Comment.typeKey:
                let comments = records.flatMap { Comment(record: $0) }
                self.comments = comments
                completion()
            default:
                return
            }
        }
    }
    
    func fetchAllPosts(completion: @escaping (() -> Void)) {
        self.fetchNewRecords(ofType: Post.typeKey) {
            completion()
        }
    }
    
    func performFullSync(completion: @escaping (() -> Void) = { _ in }) {
        guard !isSyncing
            else { completion()
                return
        }
        
        isSyncing = true
        
        self.fetchNewRecords(ofType: User.typeKey) {
            
            self.fetchNewRecords(ofType: Post.typeKey) {
                
                self.fetchNewRecords(ofType: Comment.typeKey) {
                    
                    self.isSyncing = false
                    completion()
                }
            }
        }
    }
    
    func requestFullSync(_ completion: (() -> Void)? = nil) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        self.performFullSync {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            completion?()
        }
    }
    
    // this is if we decide to delete all records at 1AM, even from cloudKit, call this in the TimeTracker.didExitMidnightHour
    //    func deleteAllPostsAt1AM() {
    //        cloudKitManager.deleteRecordsWithID(posts) { (posts, _: [CKRecord], error) in
    //            if error = error {
    //                print("Error Deleting all posts at 1AM \(#file) \(#function)")
    //            }
    //            if posts = posts {
    //                posts.removeAll()
    //            }
    //        }
    //    }
}
