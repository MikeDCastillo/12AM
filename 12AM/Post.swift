//
//  Post.swift
//  12AM
//
//  Created by Josh & Erica on 4/11/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class Post: CloudKitSyncable {
    
    static let typeKey = "Post"
    static let photoDataKey = "photoData"
    static let timestampKey = "timestamp"
    static let textKey = "text"
    
    let photoData: Data?
    let timestamp: Date
    let text: String
    var comments: [Comment]
    
    var photo: UIImage? {
        guard let photoData = self.photoData else { return nil }
        return UIImage(data: photoData)
    }
    
    init(photoData: Data?, timestamp: Date = Date(), text: String, comments: [Comment] = []){
        self.photoData = photoData
        self.timestamp = timestamp
        self.text = text
        self.comments = comments
    }
    
    //MARK: - CloudKit
    
    var recordType: String {
        return Post.typeKey
    }
    
    var cloudKitRecordID: CKRecordID?
    
    convenience required init?(record: CKRecord) {
        guard let timestamp = record.creationDate,
        let photoAsset = record[Post.photoDataKey] as? CKAsset,
        let text = record[Post.textKey] as? String,
        let photoData = try? Data(contentsOf: photoAsset.fileURL) else { return nil }
        
        self.init(photoData: photoData, timestamp: timestamp, text: text)
        
        cloudKitRecordID = record.recordID
    }
    
    
    //MARK: - Photo computed property
    
    fileprivate var temporaryPhotoURL: URL {
        
        let temporaryDirectory = NSTemporaryDirectory()
        let temporaryDirectoryURL = URL(fileURLWithPath: temporaryDirectory)
        let fileURL = temporaryDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathComponent("jpg")
        
        try? photoData?.write(to: fileURL, options: .atomic)
        
        return fileURL
    }
    
}

extension CKRecord {
    
    convenience init(_ post: Post) {
        let recordID = CKRecordID(recordName: UUID().uuidString)
        self.init(recordType: post.recordType, recordID: recordID)
        self[Post.textKey] = post.text as CKRecordValue?
        self[Post.timestampKey] = post.timestamp as CKRecordValue?
        self[Post.photoDataKey] = CKAsset(fileURL: post.temporaryPhotoURL)
    }
}


