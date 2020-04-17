//
//  CalaManager.swift
//  myExpenseTracker
//
//  Created by Johnson Liu on 4/16/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit

class CalaManager: NSObject {
        
    static let sharedInstance = CalaManager()
    
    func checkTotalDays(selectedDate: Date) -> Int {
        
        let date = selectedDate as NSDate
        let cal = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)!
        let days = cal.range(of: .day, in: .month, for: date as Date)
        
        return days.length
    }
}
