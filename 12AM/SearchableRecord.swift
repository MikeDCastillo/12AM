//
//  SearchableRecord.swift
//  12AM
//
//  Created by Nick Reichard on 4/14/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import Foundation

protocol SearchableRecord {
    func matches(searchTerm: String) -> Bool
}
