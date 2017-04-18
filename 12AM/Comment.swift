//
//  Comment.swift
//  12AM
//
//  Created by Josh & Erica on 4/11/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import Foundation
import CloudKit

class Comment: CloudKitSyncable {
    
    static let typeKey = "Comment"
    static let textKey = "text"
    static let timestampKey = "timestamp"
    static let postKey = "post"
    
    var text: String
    var timestamp: String
    var post: Post?
    var owner: User?
    var ownerReference: CKReference?
    
    init(text: String, timestamp: String = Date().description(with: Locale.current), post: Post?) {
        self.text = text
        self.timestamp = timestamp
        self.post = post
    }
    
    
    var recordType: String {
        return Comment.typeKey
    }
    
    var cloudKitRecordID: CKRecordID?
    
    convenience required init?(record: CKRecord) {
        guard let timestamp = record.creationDate?.description(with: Locale.current),
            let text = record[Comment.textKey] as? String else { return nil }
        
        self.init(text: text, timestamp: timestamp, post: nil)
        
        cloudKitRecordID = record.recordID
    }
    
    // SearchableRecord Delegate function. 
    func matches(searchTerm: String) -> Bool {
        return text.contains(searchTerm)
    }
}

extension CKRecord {
    
    convenience init(_ comment: Comment) {
        guard let post = comment.post else {
            fatalError("Comment does not have a Post relationship")
        }
        let postRecordID = post.cloudKitRecordID ?? CKRecord(post).recordID
        let recordID = CKRecordID(recordName: UUID().uuidString)
        
        self.init(recordType: comment.recordType, recordID: recordID)
        self[Comment.timestampKey] = comment.timestamp as CKRecordValue?
        self[Comment.textKey] = comment.text as CKRecordValue?
        self[Comment.postKey] = CKReference(recordID: postRecordID, action: .deleteSelf)
        guard let owner = post.owner, let ownerRecordID = owner.cloudKitRecordID else { return }
        self["ownerRef"] = CKReference(recordID: ownerRecordID, action: .none)

    }
}
