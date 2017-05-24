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
    let originalTime = Date()
    var secondsTillOne: TimeInterval {
        return oneAM.timeIntervalSince(originalTime) - 10
    }
    
    // for testing make this next line ... var isMidnight: Bool? = false
    var isMidnight: Bool?
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

    /// Returns the amount of hours from another date
    func hours(to date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: self, to: date).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(to date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: self, to: date).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(to date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: self, to: date).second ?? 0
    }
    
    var oneAM: Date? {
        return Calendar.current.date(bySetting: .hour, value: 1, of: Date())
    }
    var midnight: Date? {
        return Calendar.current.date(bySetting: .hour, value: 0, of: Date())
    }
    
    var isInMidnightHour: Bool {
        return Calendar.current.component(Calendar.Component.hour, from: self) == 0
    }
    
    var timeTillString: String {
        let dateInQuestion = isInMidnightHour ? oneAM : midnight
        guard let date = dateInQuestion else { return "NEVER" }
        let hoursTill = hours(to: date)
        let hoursAsMinutes = hoursTill * 60
        let minutesTill = minutes(to: date) - hoursAsMinutes
        let minutesAsSeconds = minutesTill * 60
        let secondsTill = seconds(to: date) - (hoursAsMinutes * 60 + minutesAsSeconds)
        
        let midnightString = isInMidnightHour ? "1AM" : "Midnight"
        var displayString = "Time to \(midnightString): "
        if hoursTill > 0 {
            displayString += "\(hoursTill)h"
        }
        if minutesTill > 0 {
            displayString += " \(minutesTill)m"
        }
        if secondsTill > 0 {
            displayString += " \(secondsTill)s"
        }
        
        return displayString
    }
    
}

extension NSNotification.Name {
    static let didEnterMidnightHour = NSNotification.Name("midnightEntered")
    static let didExitMidnightHour = NSNotification.Name("midnightExited")
}
