//
//  AdminExpensesLookupViewController.swift
//  myExpenseTracker
//
//  Created by Johnson Liu on 4/15/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit

class AdminExpensesLookupViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePickerView: UIPickerView!
    
    var selectedMonthIndex: Int = 0
    var selectedYearIndex: Int = 0
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DL_DataManager.sharedInstance.generateAllYears()
        DL_DataManager.sharedInstance.generateAllMonths()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.datePickerView.layer.borderColor = UIColor.black.cgColor
        self.datePickerView.layer.borderWidth = 0.5
        
        self.toCurrentMonthAndYear()
    }
    
    //MARK: - IB actions
    
    @IBAction func gobackAction(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func toCurrentDateAction(_ sender: Any) {
        self.toCurrentMonthAndYear()
    }

    @IBAction func showDataAction(_ sender: Any) {
        
        let queryDateString = self.queryDate()
        print("> ")
        print("> SQL query date : \(queryDateString) ")
        
        let yearText = DL_DataManager.sharedInstance.allYearsList[self.selectedYearIndex]
        let yearValue = Int(yearText)!
        let monthValue = self.selectedMonthIndex + 1
        DL_DataManager.sharedInstance.generateMonthsAndDaysDisplay(year: yearValue, month: monthValue)
        print("> all days = \(DL_DataManager.sharedInstance.monthDayDisplayList)")
        print("> ")
        
        let storyboard = UIStoryboard(name: "admin", bundle: nil)
        let vc: AdminExpenseDetailsViewController? = storyboard.instantiateViewController(withIdentifier: "AdminExpenseDetailsViewController") as? AdminExpenseDetailsViewController
        //vc!.selectedMonth = self.selectedMonthIndex + 1
        //vc!.maxSize = DL_DataManager.sharedInstance.totalDaysInMonth
        self.navigationController!.pushViewController(vc!, animated: true)
        
    }
    
    //MARK: - picker view source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return DL_DataManager.sharedInstance.allMonthsList.count
        }
        else {
            return DL_DataManager.sharedInstance.allYearsList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var titleText: String = ""
        
        if component == 0 {
            titleText = DL_DataManager.sharedInstance.allMonthsList[row]
        }
        else {
            titleText = DL_DataManager.sharedInstance.allYearsList[row]
        }
        
        return titleText
    }
    
    //MARK: - picker view delegate
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            self.selectedMonthIndex = row
        }
        else {
            self.selectedYearIndex = row
        }
        self.displayDate()
        self.showTotalDays()
    }
    
    //MARK: - helpers
    
    func toCurrentMonthAndYear() {
        
        let rightNow = Date()
        let df = DateFormatter()
        df.dateFormat = "MM"
        let currentMonth = Int(df.string(from: rightNow))!
        
        self.selectedMonthIndex = currentMonth - 1
        self.datePickerView.selectRow(self.selectedMonthIndex, inComponent: 0, animated: true)
        
        self.selectedYearIndex = DL_DataManager.sharedInstance.yearRange
        self.datePickerView.selectRow(self.selectedYearIndex, inComponent: 1, animated: true)
        
        self.displayDate()
        self.showTotalDays()
    }
    
    func displayDate() {
        
        let year = DL_DataManager.sharedInstance.allYearsList[self.selectedYearIndex]
        let month = DL_DataManager.sharedInstance.allMonthsList[self.selectedMonthIndex]
        self.dateLabel.text = String(format: "%@, %@", month, year)
    }
    
    func showTotalDays() {
        
        let yearText = DL_DataManager.sharedInstance.allYearsList[self.selectedYearIndex]
        let yearValue = Int(yearText)!
        let monthValue = self.selectedMonthIndex + 1

        let selectedDate = DL_DataManager.sharedInstance.convertToDate(year: yearValue, month: monthValue)
        DL_DataManager.sharedInstance.totalDaysInMonth = CalaManager.sharedInstance.checkTotalDays(selectedDate: selectedDate)
        print("-> total days = \(DL_DataManager.sharedInstance.totalDaysInMonth) | date : \(selectedDate) ")
    }
    
    func queryDate() -> String {
        
        let year = DL_DataManager.sharedInstance.allYearsList[self.selectedYearIndex]
        let month = String(format: "%0.2d", (self.selectedMonthIndex + 1))
        return String(format: "%@-%@", year, month)
    }
    
}
