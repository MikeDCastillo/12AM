//
//  Comment.swift
//  12AM
//
//  Created by Josh & Erica on 4/11/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import Foundation
import CloudKit

class Comment {
    
    static let textKey = "text"
    static let timestampKey = "timestamp"
    static let postKey = "post"
    
    var text: String
    var timestamp: Date
    var post: Post?
    
    init(text: String, timestamp: Date = Date(), post: Post?) {
        self.text = text
        self.timestamp = timestamp
        self.post = post
    }
    
//    init?(cloudKitRecord: CKRecord) {
//        guard let timestamp
//    }
//    
}
