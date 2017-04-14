//
//  CloudKitSyncable.swift
//  12AM
//
//  Created by Josh "McAbs" McDonald on 4/12/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import Foundation
import CloudKit

protocol CloudKitSyncable {
    
    init?(record: CKRecord)
    
    var cloudKitRecordID: CKRecordID? { get set }
    var recordType: String { get }
}

extension CloudKitSyncable {
    
    var isSynced: Bool {
        return cloudKitRecordID != nil
    }
    
    var cloudKitReference: CKReference? {
        
        guard let recordID = cloudKitRecordID else { return nil }
        
        return CKReference(recordID: recordID, action: .deleteSelf)
    }
}
