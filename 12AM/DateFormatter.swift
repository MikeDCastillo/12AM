//
//  DateFormatter.swift
//  12AM
//
//  Created by Nick Reichard on 6/23/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import Foundation

extension Date {
    
    var formatter: DateFormatter? {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.doesRelativeDateFormatting = true
        return formatter
    }
}
