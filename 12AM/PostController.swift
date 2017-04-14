//
//  PostController.swift
//  12AM
//
//  Created by Josh & Erica on 4/12/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

/* 
 Check for later use:
 1. checkCloudKitAvailability
*/

import Foundation
import UIKit
import CloudKit

extension PostController {
    static let PostChangeNotified = Notification.Name("PostChangeNotified")
    static let PostCommentsChangedNotification = Notification.Name("PostCommentsChangedNotification")
}

class PostController {
    
    //MARK: - Variables
    
    static let sharedController = PostController()
    
    var posts = [Post]() {
        didSet {
            DispatchQueue.main.async {
                let nc = NotificationCenter.default
                nc.post(name: PostController.PostCommentsChangedNotification, object: self)
            }
        }
    }
    
    var comments: [Comment] {
        return posts.flatMap { $0.comments }
    }
    
    var sortedPost: [Post] {
        return posts.sorted(by: { return $0.timestamp.compare($1.timestamp) == .orderedDescending })
    }
    
    var cloudKitManager = CloudKitManager()
    
    var isSyncing: Bool = false
    
    init() {
        cloudKitManager = CloudKitManager()
        performFullSync()
    }
    
    
    //MARK: - CRUD
    
    // Create Post Function
    func createPost(image: UIImage, caption: String, completion: ((Post) -> Void)? = nil) {
        
        // Sets image property of jpeg
        guard let data = UIImageJPEGRepresentation(image, 1.0) else { return }
        let post = Post(photoData: data)
        
        // Adds post to first cell
        posts.insert(post, at: 0)
        
        // Saves post to CloudKit or gives error
        cloudKitManager.saveRecord(CKRecord(post)) { (record, error) in
            guard let record = record else { return }
            post.cloudKitRecordID = record.recordID
            if let error = error {
                print("Error saving new post to CloudKit: \(error)")
            }
            completion?(post)
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
        var predicate: NSPredicate
        
        referencesToExclude = self.syncedRecords(ofType: type).flatMap {$0.cloudKitReference}
        predicate = NSPredicate(format: "NOT(recordID IN %@)", argumentArray: [referencesToExclude])
        if referencesToExclude.isEmpty {
            predicate = NSPredicate(value: true)
        }
        
        cloudKitManager.fetchRecordsWithType(type, predicate: predicate, recordFetchedBlock: { (record) in
            switch type {
            case Post.typeKey:
                if let post = Post(record: record) {
                    self.posts.append(post)
                }
            case Comment.typeKey:
                guard let postReference = record[Comment.postKey] as? CKReference,
                    let comment = Comment(record: record) else { return }
                let matchingPost = PostController.sharedController.posts.filter({$0.cloudKitRecordID == postReference.recordID}).first
                matchingPost?.comments.append(comment)
            default:
                return
            }
            
        }) { (records, error) in
            if let error = error {
                print("Error fetching CloudKit records")
            }
            completion()
        }
        
    }
    
    func performFullSync(completion: @escaping (() -> Void) = { _ in }) {
        
        guard !isSyncing else {
            completion()
            return
        }
        
        isSyncing = true
    }
    
    
    
    
    
}
