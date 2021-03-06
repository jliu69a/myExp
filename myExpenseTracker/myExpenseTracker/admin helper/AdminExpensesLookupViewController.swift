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
    
    @IBOutlet weak var toCurrentDateButton: UIButton!
    @IBOutlet weak var showDataButton: UIButton!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var selectedMonthIndex: Int = 0
    var selectedYearIndex: Int = 0
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DL_DataManager.sharedInstance.generateAllYears()
        DL_DataManager.sharedInstance.generateAllMonths()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didGenerateExpensesLookupData), name: NSNotification.Name(rawValue: Constant.kCreateLookupExpensesDataNotificatioon), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.activityIndicator.stopAnimating()
        
        self.datePickerView.layer.borderColor = UIColor.black.cgColor
        self.datePickerView.layer.borderWidth = 0.5
        
        self.toCurrentDateButton.layer.cornerRadius = 5
        self.showDataButton.layer.cornerRadius = 5
        
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
        
        let yearText = DL_DataManager.sharedInstance.allYearsList[self.selectedYearIndex]
        
        let monthValue = self.selectedMonthIndex + 1
        let monthText = String(format: "%0.2d", monthValue)
        print("> ")
        print("> year  : '\(yearText)' ")
        print("> month : '\(monthText)' ")
        print("> ")
        self.getLookupData(yearText: yearText, monthText: monthText)
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
    
    //MARK: - lookup data
    
    func getLookupData(yearText: String, monthText: String) {
        self.activityIndicator.startAnimating()
        
        DL_DataManager.sharedInstance.generateAllMonths()
        DL_DataManager.sharedInstance.generateAllYears()
        print("> ")
        print("> all months : \(DL_DataManager.sharedInstance.allMonthsList) ")
        print("> all years  : \(DL_DataManager.sharedInstance.allYearsList) ")
        print("> ")
        let dateString = String(format: "%@-%@", yearText, monthText)
        
        let yearValue: Int = Int(yearText)!
        let monthValue: Int = Int(monthText)!
        
        DL_DataManager.sharedInstance.generateMonthsAndDaysDisplay(year: yearValue, month: monthValue)
        print("- ")
        print("- total days in month = \(DL_DataManager.sharedInstance.totalDaysInMonth) ")
        print("- display list : \(DL_DataManager.sharedInstance.monthDayDisplayList) ")
        print("- ")
        
        DL_DataManager.sharedInstance.lookupInitialData()
        print("> ")
        print("> all expenses items : \(DL_DataManager.sharedInstance.lookupExpenseDict) ")
        print("> ")
        
        DL_DataManager.sharedInstance.lookupExpensesByDate(date: dateString)
    }
    
    //MARK: - lookup notifications
    
    @objc func didGenerateExpensesLookupData() {
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            
            let storyboard = UIStoryboard(name: "adminELookup", bundle: nil)
            let vc: AdminExpenseDetailsViewController? = storyboard.instantiateViewController(withIdentifier: "AdminExpenseDetailsViewController") as? AdminExpenseDetailsViewController
            DL_DataManager.sharedInstance.selectedTopCollectionViewIndex = 0
            self.navigationController!.pushViewController(vc!, animated: true)
        }
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
