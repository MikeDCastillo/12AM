//
//  ViewController.swift
//  12AM
//
//  Created by Michael Castillo on 4/18/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {

    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    let userCalendar = Calendar.current
    let userCalenderTimeZone = Calendar.current.timeZone
    
    var hourTimer = Timer()
    var minutesTimer = Timer()
    var secondsTimer = Timer()
  


}
