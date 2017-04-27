//
//  Post.swift
//  12AM
//
//  Created by Josh "Big JDawg" McDonald on 4/12/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
// git test

import Foundation
import UIKit
import CloudKit

class Post: CloudKitSyncable {
    
    static let typeKey = "Post"
    static let photoDataKey = "photoData"
    static let timestampKey = "timestamp"
    static let textKey = "text"
    static let ownerKey = "owner"
    static let ownerReferenceKey = "ownerRef"
    
    let photoData: Data?
    let timestamp: Date
    var comments: [Comment]
    let text: String
    var owner: User?
    var ownerReference: CKReference
    
    var photo: UIImage? {
        guard let photoData = self.photoData else { return nil }
        return UIImage(data: photoData)
    }
    
    init(photoData: Data?, timestamp: Date = Date(), text: String, comments: [Comment] = [], owner: User, ownerReference: CKReference) {
        self.photoData = photoData
        self.timestamp = timestamp
        self.text = text
        self.comments = comments.sorted(by: { $0.timestamp > $1.timestamp })
        self.owner = owner
        self.ownerReference = ownerReference
    }
    
    //MARK: - CloudKit
    
    var recordType: String {
        return Post.typeKey
    }
    
    var cloudKitRecordID: CKRecordID?
    
    init?(record: CKRecord) {
        guard let timestamp = record[Post.timestampKey] as? Date,
            let text = record[Post.textKey] as? String,
            let photoAsset = record[Post.photoDataKey] as? CKAsset,
            let photoData = try? Data(contentsOf: photoAsset.fileURL),
            let ownerReference = record[Post.ownerReferenceKey] as? CKReference else { return nil }
        
        self.photoData = photoData
        self.timestamp = timestamp
        self.text = text
        self.ownerReference = ownerReference
        self.cloudKitRecordID = record.recordID
        self.comments = []
    }
    
    //MARK: - Photo computed property
    
    fileprivate var temporaryPhotoURL: URL {
        
        let temporaryDirectory = NSTemporaryDirectory()
        let temporaryDirectoryURL = URL(fileURLWithPath: temporaryDirectory)
        let fileURL = temporaryDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
        
        try? photoData?.write(to: fileURL, options: .atomic)
        
        return fileURL
    }
    var cloudKitReference: CKReference?
}

extension CKRecord {
    
    convenience init(_ post: Post) {
        let recordID = CKRecordID(recordName: UUID().uuidString)
        self.init(recordType: post.recordType, recordID: recordID)
        self[Post.textKey] = post.text as CKRecordValue
        self[Post.timestampKey] = post.timestamp as NSDate
        self[Post.photoDataKey] = CKAsset(fileURL: post.temporaryPhotoURL)
        guard let owner = post.owner,
            let ownerRecordID = owner.cloudKitRecordID
            else { return }
        self[Post.ownerReferenceKey] = CKReference(recordID: ownerRecordID, action: .none)
    }
}

