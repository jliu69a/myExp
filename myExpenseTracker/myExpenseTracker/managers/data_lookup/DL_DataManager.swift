//
//  DL_DataManager.swift
//  myExpenseTracker
//
//  Created by Johnson Liu on 4/8/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit

class DL_DataManager: NSObject {
    
    static let sharedInstance = DL_DataManager()
    
    
    var allMonthsList: [String] = []
    var allYearsList: [String] = []
    
    var totalDaysInMonth: Int = 0
    var monthDayDisplayList: [String] = []
    
    var lookupExpenseDict: [String: [ExpenseModel]] = [:]
    
    
    //MARK: - actions
    
    func currentYearAndMonth() -> [String] {
        let rightNow: Date = Date()
        
        let df = DateFormatter()
        df.dateFormat = "yyyy"
        let year: String = df.string(from: rightNow)
        
        df.dateFormat = "MM"
        let month: String = df.string(from: rightNow)
        
        return [year, month]
    }
    
    func convertToDate(year: Int, month: Int) -> Date {
        
        let dateText: String = String(format: "%d-%0.2d", year, month)
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM"
        let date: Date = df.date(from: dateText)!
        
        return date
    }
    
    //MARK: - picker data
    
    func generateAllMonths() {
        self.allMonthsList = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    }
    
    func generateAllYears() {
        
        let currentDate: [String] = self.currentYearAndMonth()
        let year: Int = Int(currentDate[0])!
        
        let rangeSize: Int = 20
        let fromYear: Int = year - rangeSize
        let toYear: Int = year + rangeSize
        
        self.allYearsList.removeAll()
        for each in fromYear...toYear {
            let eachYear = "\(each)"
            self.allYearsList.append(eachYear)
        }
    }
    
    //MARK: - collection view data
    
    func generateMonthsAndDaysDisplay(year: Int, month: Int) {
        
        let selectedDate: Date = self.convertToDate(year: year, month: month)
        self.totalDaysInMonth = self.getTotalDaysInMonth(selectedDate: selectedDate)
        
        self.monthDayDisplayList.removeAll()
        for eachDay in 1...self.totalDaysInMonth {
            let display: String = String(format: "%d/%d", month, eachDay)
            self.monthDayDisplayList.append(display)
        }
    }
    
    func getTotalDaysInMonth(selectedDate: Date) -> Int {
        
        let date = selectedDate as NSDate
        let cal = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)!
        let days = cal.range(of: .day, in: .month, for: date as Date)
        
        return days.length
    }
    
    func lookupInitialData() {
        
        if self.monthDayDisplayList.count == 0 {
            return
        }
        
        let emptyList: [ExpenseModel] = []
        self.lookupExpenseDict.removeAll()
        
        for each in 0..<self.monthDayDisplayList.count {
            let displayDay: String = self.monthDayDisplayList[each]
            self.lookupExpenseDict[displayDay] = emptyList
        }
    }
    
}
