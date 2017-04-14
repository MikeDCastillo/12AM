//
//  PostExtension.swift
//  12AM
//
//  Created by Nick Reichard on 4/14/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import Foundation

extension Post: SearchableRecord {
    
    func matches(searchTerm: String) -> Bool {
        let matchedComments = comments.filter { $0.matches(searchTerm: searchTerm) }
        return !matchedComments.isEmpty
    }
}
