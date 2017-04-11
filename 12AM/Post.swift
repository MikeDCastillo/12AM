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

class Post {
    
    static let typeKey = "Post"
    static let photoDataKey = "photoData"
    static let timestampKey = "timestamp"
    
    let photoData: Data?
    let timestamp: Date
    var comments: [Comment]
    
    var photo: UIImage? {
        guard let photoData = self.photoData else { return nil }
        return UIImage(data: photoData)
    }
    
    init(photoData: Data?, timestamp: Date = Date(), comments: [Comment] = []){
        self.photoData = photoData
        self.timestamp = timestamp
        self.comments = comments
    }
    
    //MARK: - CloudKit
    
    var recordType: String {
        return Post.typeKey
    }
    
    var cloudKitRecordID: CKRecordID?
    
    convenience required init?(record: CKRecord) {
        guard let timestamp = record.creationDate,
        let photoData = try? Data(contentsOf: photoAsset.fileURL)
    }
    
    
    
}
