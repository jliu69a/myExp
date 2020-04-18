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
    
    let yearRange: Int = 20
    
    let xSeriesSpace: CGFloat = 44
    let notXSeriesSpace: CGFloat = 20
    
    var allMonthsList: [String] = []
    var allYearsList: [String] = []
    
    var totalDaysInMonth: Int = 0
    var monthDayDisplayList: [String] = []
    
    var selectedTopCollectionViewIndex: Int = 0
    
    var lookupExpenseDict: [String: [ExpenseModel]] = [:]
    
    var tempExpensesList: [ExpenseModel] = []
    
    
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
        
        let fromYear: Int = year - self.yearRange
        let toYear: Int = year + self.yearRange
        
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
    
    //MARK: - look up data
    
    func lookupExpensesByDate(date: String) {
        
        ConnectionManager.lookupExpensesByDate(date: date) { (result)->() in
            let dictionary = result as? [String: Any]
            let expenses: [Any]? = dictionary!["data"] as? [Any]
            let expenseData: [AnyObject] = expenses! as [AnyObject]
            self.parseExpenses(data: expenseData)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constant.kCreateLookupExpensesDataNotificatioon), object: nil)
        }
    }
    
    func parseExpenses(data: [AnyObject]) {
        
        self.tempExpensesList.removeAll()
        if (data.count == 0) {
            return
        }
        
        for item in data {
            let eachItem: [String: AnyObject] = item as! [String: AnyObject]
            let model: ExpenseModel = ExpenseModel()
            
            let expIdString: String? = eachItem["id"] as? String
            model.expId = (expIdString! as NSString).integerValue
            
            model.date = eachItem["date"] as? String
            model.time = eachItem["time"] as? String
            
            let paymentIdString: String? = eachItem["payment_id"] as? String
            model.paymentId = (paymentIdString! as NSString).integerValue
            
            let vendorIdString: String? = eachItem["vendor_id"] as? String
            model.vendorId = (vendorIdString! as NSString).integerValue
            
            model.payment = eachItem["payment"] as? String
            model.vendor = eachItem["vendor"] as? String
            model.note = eachItem["note"] as? String
            
            let amountString: String? = eachItem["amount"] as? String
            model.amount = (amountString! as NSString).floatValue
            
            self.tempExpensesList.append(model)
        }
        
        self.parseTempExpensesData()
        //print("-> Look UP : total expense data is = \(self.tempExpensesList) ")
    }

    func parseTempExpensesData() {
        self.lookupExpenseDict.removeAll()
        
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let defaultDate = df.string(from: Date())
        
        for each in self.tempExpensesList {
            
            let date: String = each.date ?? defaultDate
            let displayDate = self.formateExpenseDate(rawDate: date)
            
            var array: [ExpenseModel]? = self.lookupExpenseDict[displayDate]
            if array == nil {
                array = []
            }
            array!.append(each)
            
            self.lookupExpenseDict[displayDate] = array!
        }
        
        self.testingPrint()
    }
    
    func formateExpenseDate(rawDate: String) -> String {
        var displayDate: String = ""
        
        let array = rawDate.components(separatedBy: "-")
        if array.count >= 3 {
            let month: String = array[1]
            let day: String = array[2]
            displayDate = String(format: "%d/%d", Int(month)!, Int(day)!)
        }
        else {
            displayDate = "1/1"
        }
        return displayDate
    }
    
    func testingPrint() {
        for each in self.monthDayDisplayList {
            let array = self.lookupExpenseDict[each] ?? []
            print("> \(each), total = \(array.count)")
        }
    }
    
}
