//
//  AdminReportDateViewController.swift
//  MyExps
//
//  Created by Johnson Liu on 1/22/19.
//  Copyright © 2019 Home Office. All rights reserved.
//

import UIKit

class AdminReportDateViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var selectionPicker: UIPickerView!
    @IBOutlet weak var titleLabel: UILabel!
    
    weak var parentVC: AdminHomeViewController? = nil
    
    var isForMonthly: Bool = false
    var isForDataExport: Bool = false
    
    var selectedDate: Date = Date()
    
    var currentMonthIndex: Int = 0
    var currentYearIndex: Int = 0
    
    var selectedMonthIndex: Int = 0
    var selectedYearIndex: Int = 0
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentMonthAndYear()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.selectButton.layer.cornerRadius = 5
        self.cancelButton.layer.cornerRadius = 5
        
        if self.isForMonthly {
            self.titleLabel.text = "For Monthly"
        }
        else {
            self.titleLabel.text = "For Annually"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.isForMonthly {
            self.selectionPicker.selectRow(self.currentMonthIndex, inComponent: 0, animated: true)
            self.selectedMonthIndex = self.currentMonthIndex
            
            self.selectionPicker.selectRow(self.currentYearIndex, inComponent: 1, animated: true)
            self.selectedYearIndex = self.currentYearIndex
        }
        else {
            self.selectionPicker.selectRow(self.currentYearIndex, inComponent: 0, animated: true)
            self.selectedYearIndex = self.currentYearIndex
        }
    }
    
    //MARK: - IB action
    
    @IBAction func selectAction(_ sender: Any) {
        
        let selectedMonth: String = String(format: "%02d", (self.selectedMonthIndex + 1))
        let selectedYear: String = DisplayManager.sharedInstance.yearsList[self.selectedYearIndex]
        
        if self.isForDataExport {
            
            DataManager.sharedInstance.exportData(month: selectedMonth, year: selectedYear, isMonthly: self.isForMonthly)
        }
        else {
            
            let newDateString: String = String(format: "%@/%@/01", selectedYear, selectedMonth)
            let df: DateFormatter = DateFormatter()
            df.dateFormat = "yyyy/MM/dd"
            DataManager.sharedInstance.reportDate = df.date(from: newDateString)!
            DataManager.sharedInstance.isReportForMonthly = self.isForMonthly
            
            print("-> reports, month : '\(selectedMonth)' ")
            print("-> reports, year  : '\(selectedYear)' ")
            
            DataManager.sharedInstance.createReports(month: selectedMonth, year: selectedYear, isForAnnual: !self.isForMonthly)
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.parentVC!.closeDateSelection()
    }
    
    //MARK: - picker data source
    
    func currentMonthAndYear() {
        
        let rightNow: Date = Date()
        let df: DateFormatter = DateFormatter()
        
        df.dateFormat = "yyyy"
        let yearText: String = df.string(from: rightNow)
        if DisplayManager.sharedInstance.yearsList.contains(yearText) {
            self.currentYearIndex = DisplayManager.sharedInstance.yearsList.firstIndex(of: yearText)!
        }
        else {
            self.currentYearIndex = 0
        }
        
        df.dateFormat = "MMMM"
        let monthText: String = df.string(from: rightNow)
        if DisplayManager.sharedInstance.monthsList.contains(monthText) {
            self.currentMonthIndex = DisplayManager.sharedInstance.monthsList.firstIndex(of: monthText)!
        }
        else {
            self.currentMonthIndex = 0
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        if self.isForMonthly {
            return 2
        }
        else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if self.isForMonthly {
            if component == 0 {
                return DisplayManager.sharedInstance.monthsList.count
            }
            else {
                return DisplayManager.sharedInstance.yearsList.count
            }
        }
        else {
            return DisplayManager.sharedInstance.yearsList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if self.isForMonthly {
            if component == 0 {
                return DisplayManager.sharedInstance.monthsList[row]
            }
            else {
                return DisplayManager.sharedInstance.yearsList[row]
            }
        }
        else {
            return DisplayManager.sharedInstance.yearsList[row]
        }
    }
    
    //MARK: - picker delegate
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if self.isForMonthly {
            if component == 0 {
                self.selectedMonthIndex = row
            }
            else {
                self.selectedYearIndex = row
            }
        }
        else {
            self.selectedMonthIndex = 0
            self.selectedYearIndex = row
        }
    }
    
}
