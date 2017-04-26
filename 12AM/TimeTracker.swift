//
//  12AMTimer.swift
//  12AM
//
//  Created by Michael Castillo on 4/18/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import Foundation

class TimeTracker {
    
    static let shared = TimeTracker()
    let oneAM = Calendar.current.date(bySetting: .hour, value: 1, of: Date())!
    let midnight = Calendar.current.date(bySetting: .hour, value: 0, of: Date())!
    let originalNow = Date()
    var secondsTillOne: TimeInterval {
        return oneAM.timeIntervalSince(originalNow) - 10
    }
    
    // for testing make this next line ... var isMidnight: Bool? = false
    var isMidnight: Bool? = true
    {
        didSet {
            guard let isMidnight = isMidnight, isMidnight != oldValue else { return }
            let notificationName: Notification.Name = isMidnight ? .didEnterMidnightHour : .didExitMidnightHour
            NotificationCenter.default.post(name: notificationName, object: nil)
        }
    }
    
    init() {
        startTimer()
    }
    
    func startTimer() {
        Timer.every(1.second) {
            self.isMidnight = Date().isInMidnightHour
            
        }
    }
    
}

extension Date {
    
    var isInMidnightHour: Bool {
        return Calendar.current.component(Calendar.Component.hour, from: self) == 0
    }
    
}

extension NSNotification.Name {
    static let didEnterMidnightHour = NSNotification.Name("midnightEntered")
    static let didExitMidnightHour = NSNotification.Name("midnightExited")
}
