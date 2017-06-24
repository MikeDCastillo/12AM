//
//  Task+Convenience.swift
//  12AM
//
//  Created by Nick Reichard on 6/23/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import Foundation
import CoreData

extension Like {
    
    @discardableResult convenience init(name: String, context: NSManagedObjectContext = Stack.context) {
        
        self.init(context: context)
        
        self.name = name
        self.isLiked = false
    }
}
