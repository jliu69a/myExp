//
//  DataManager.swift
//  myExpenseTracker
//
//  Created by Johnson Liu on 3/17/19.
//  Copyright © 2019 Home Office. All rights reserved.
//

import UIKit
import MapKit

class DataManager: NSObject {
    
    static let sharedInstance = DataManager()
    
    var paymentsData: [PAndVModel]? = []
    var vendorsData: [PAndVModel]? = []
    var expensesData: [ExpenseModel]? = []
    var top10Data: [PAndVModel]? = []
    
    var exportsList: [ExpenseModel]? = []
    
    var vendorGroups: [String: [PAndVModel]]? = [:]
    var vendorGroupKeys: [String]? = []
    var vendorTop10GroupKeys: [String]? = []
    
    var paymentReportData: [ReportModel] = []
    var vendorReportData: [ReportModel] = []
    var reportDate: Date = Date()
    var reportDateTitle: String = ""
    var isReportForMonthly: Bool = false
    
    var locationFullAddress: String = ""
    var locationStreet: String = ""
    var locationCity: String = ""
    var locationState: String = ""
    var locationZipcode: String = ""
    
    var totalReportValue: Float = 0
    
    var currentDate: Date = Date()
    
    //MARK: - initial data
    
    func loadInitialData() {
        
        ConnectionManager.loadInitialDataWithCallBack { (result)->() in
            let dictionary = result as? [String: Any]
            
            let expenses: [Any]? = dictionary!["expense"] as? [Any]
            let payments: [Any]? = dictionary!["payment"] as? [Any]
            let vendors: [Any]? = dictionary!["vendor"] as? [Any]
            let top10: [Any]? = dictionary!["top10"] as? [Any]
            
            let paymentsData: [AnyObject] = payments! as [AnyObject]
            self.parsePayments(data: paymentsData)
            
            let vendorsData: [AnyObject] = vendors! as [AnyObject]
            self.parseVendors(data: vendorsData)
            
            let expenseData: [AnyObject] = expenses! as [AnyObject]
            self.parseExpenses(data: expenseData)
            
            let top10Data: [AnyObject] = top10! as [AnyObject]
            self.parseTop10(data: top10Data)
            
            //-- grouping vendors
            self.groupingVendors(data: self.vendorsData!)
            
            self.testingPrint()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constant.kInitialDataLoadedNotification), object: nil)
        }
    }
    
    //MARK: - change expense
    
    func changeExpenseData(data: ExpenseModel, isForEdit: Bool) {
        
        ConnectionManager.saveExpenseData(data: data, isForEdit: isForEdit) { (result)->() in
            let dictionary = result as? [String: Any]
            let expenses: [Any]? = dictionary!["data"] as? [Any]
            let expenseData: [AnyObject] = expenses! as [AnyObject]
            self.parseExpenses(data: expenseData)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constant.kChangeExpensesDataNotification), object: nil)
        }
    }
    
    func changeExpenseJsonData(data: ExpenseModel, isForEdit: Bool) {
        
        //-- send out HTTP POST request, with JSON data
        //-- use Alamofire Framework
        
        ConnectionManager.saveExpenseJsonData(data: data, isForEdit: isForEdit) { (result)->() in
            let dictionary = result as? [String: Any]
            let expenses: [Any]? = dictionary!["data"] as? [Any]
            let expenseData: [AnyObject] = expenses! as [AnyObject]
            self.parseExpenses(data: expenseData)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constant.kChangeExpensesDataNotification), object: nil)
        }
    }
    
    //MARK: - expenses on date
    
    func expensesOnDate(date: String) {
        
        ConnectionManager.loadExpensesOnDate(date: date) { (result)->() in
            let dictionary = result as? [String: Any]
            let expenses: [Any]? = dictionary!["data"] as? [Any]
            let expenseData: [AnyObject] = expenses! as [AnyObject]
            self.parseExpenses(data: expenseData)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constant.kChangeExpensesDataNotification), object: nil)
        }
    }
    
    //MARK: - payments & vendors
    
    func changePayment(id: String, name: String, isForEdit: String) {
        
        ConnectionManager.savePayment(id: id, name: name, isForEdit: isForEdit) { (result)->() in
            let dictionary = result as? [String: Any]
            let payments: [Any]? = dictionary!["data"] as? [Any]
            let paymentData: [AnyObject] = payments! as [AnyObject]
            self.parsePayments(data: paymentData)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constant.kChangePaymentDataNotification), object: nil)
        }
    }
    
    func changeJsonPayment(id: String, name: String, isForEdit: String) {
        
        ConnectionManager.saveJsonPayment(id: id, name: name, isForEdit: isForEdit) { (result)->() in
            let dictionary = result as? [String: Any]
            let payments: [Any]? = dictionary!["data"] as? [Any]
            let paymentData: [AnyObject] = payments! as [AnyObject]
            self.parsePayments(data: paymentData)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constant.kChangePaymentDataNotification), object: nil)
        }
    }

    func changeVendor(id: String, name: String, isForEdit: String) {
        
        ConnectionManager.saveVendor(id: id, name: name, isForEdit: isForEdit) { (result)->() in
            let dictionary = result as? [String: Any]
            let vendors: [Any]? = dictionary!["data"] as? [Any]
            let vendorData: [AnyObject] = vendors! as [AnyObject]
            self.parseVendors(data: vendorData)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constant.kChangeVendorDateNotification), object: nil)
        }
    }
    
    func changeJsonVendor(id: String, name: String, isForEdit: String) {
        
        ConnectionManager.saveJsonVendor(id: id, name: name, isForEdit: isForEdit) { (result)->() in
            let dictionary = result as? [String: Any]
            
            let vendors: [Any]? = dictionary!["vendor"] as? [Any]
            let top10: [Any]? = dictionary!["top10"] as? [Any]
            
            let vendorsData: [AnyObject] = vendors! as [AnyObject]
            self.parseVendors(data: vendorsData)
            
            let top10Data: [AnyObject] = top10! as [AnyObject]
            self.parseTop10(data: top10Data)
            
            //-- grouping vendors
            self.groupingVendors(data: self.vendorsData!)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constant.kChangeVendorDateNotification), object: nil)
        }
    }
    
    //MARK: - reports
    
    func createReports(month: String, year: String, isForAnnual: Bool) {
        
        ConnectionManager.loadReports(month: month, year: year, isForAnnual: isForAnnual) { (result)->() in
            let dictionary = result as? [String: Any]
            
            let payments: [Any]? = dictionary!["paymentTotal"] as? [Any]
            let paymentsData: [AnyObject] = payments! as [AnyObject]
            
            let vendors: [Any]? = dictionary!["vendorTotal"] as? [Any]
            let vendorsData: [AnyObject] = vendors! as [AnyObject]
            
            print("> create report, payment total = \(paymentsData.count) ")
            print("> create report, vendor  total = \(vendorsData.count) ")
            
            self.parseReportsData(payments: paymentsData, vendors: vendorsData)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constant.kPaymentsAndVendorsReportNotification), object: nil)
        }
    }
    
    //MARK: - export
    
    func exportData(month: String, year: String, isMonthly: Bool) {
        
        ConnectionManager.exportData(month: month, year: year, isMonthly: isMonthly) { (result)->() in
            let dictionary = result as? [String: Any]
            
            let exports: [Any]? = dictionary!["data"] as? [Any]
            let exportData: [AnyObject] = exports! as [AnyObject]
            self.parseForExport(data: exportData)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constant.kExportMonthAndYearDataNotification), object: nil)
        }
    }
    
    //MARK: - location check
    
    func checkDeviceLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        let bingKey: String = "AgI7h-mtdF8r44YBbOZUA9GGu2Zjvi72gENPJNa3ZcUiVEaRfEn38KKR_zvmqsZk"
        
        ConnectionManager.checkLocation(latitude: latitude, longitude: longitude, bingKey: bingKey) { (result)->() in
            let dictionary = result as? [String: Any]
            self.parseLocations(data: dictionary!)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constant.kLocationCheckFullAddressNotification), object: nil)
        }
    }
    
    //MARK: - data parsing
    
    func parsePayments(data: [AnyObject]) {
        
        self.paymentsData!.removeAll()
        if data.count == 0 {
            return
        }
        
        for item in data {
            let eachItem: [String: AnyObject] = item as! [String: AnyObject]
            let model: PAndVModel = PAndVModel()
            model.pvId = eachItem["id"] as? String
            model.pvName = eachItem["payment"] as? String
            self.paymentsData!.append(model)
        }
    }
    
    func parseVendors(data: [AnyObject]) {
        
        self.vendorsData!.removeAll()
        if data.count == 0 {
            return
        }
        
        for item in data {
            let eachItem: [String: AnyObject] = item as! [String: AnyObject]
            let model: PAndVModel = PAndVModel()
            model.pvId = eachItem["id"] as? String
            model.pvName = eachItem["vendor"] as? String
            self.vendorsData!.append(model)
        }
    }
    
    func parseTop10(data: [AnyObject]) {
        
        self.top10Data!.removeAll()
        if data.count == 0 {
            return
        }
        
        for item in data {
            let eachItem: [String: AnyObject] = item as! [String: AnyObject]
            let model: PAndVModel = PAndVModel()
            model.pvId = eachItem["id"] as? String
            model.pvName = eachItem["vendor"] as? String
            self.top10Data!.append(model)
        }
    }
    
    func parseExpenses(data: [AnyObject]) {
        
        self.expensesData!.removeAll()
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
            
            self.expensesData!.append(model)
        }
        print("-> total expense data = \(self.expensesData!.count) ")
    }
    
    func groupingVendors(data: [PAndVModel]) {
        
        if data.count == 0 {
            return
        }
        self.vendorGroups!.removeAll()
        
        let range: NSRange = NSRange(location: 0, length: 1)
        let letters: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        
        for item in data {
            let name: String = item.pvName!
            let firstLetter: String = (name as NSString).substring(with: range)
            
            var upperCaseFirstLetter = (firstLetter as NSString).uppercased
            if !(letters as NSString).contains(upperCaseFirstLetter) {
                upperCaseFirstLetter = "#"
            }
            
            if !self.vendorGroupKeys!.contains(upperCaseFirstLetter) {
                self.vendorGroupKeys!.append(upperCaseFirstLetter)
            }
            
            var list: [PAndVModel]? = self.vendorGroups![upperCaseFirstLetter]
            
            if list == nil {
                list = []
            }
            list!.append(item)
            self.vendorGroups![upperCaseFirstLetter] = list!
        }
        
        //-- add in top 10 vendors
        self.vendorTop10GroupKeys = self.vendorGroupKeys!
        let top10Title: String = "Top 10"
        self.vendorTop10GroupKeys?.insert(top10Title, at: 0)
        self.vendorGroups![top10Title] = self.top10Data!
    }
    
    func parseReportsData(payments:[AnyObject], vendors:[AnyObject]) {
        
        if payments.count == 0 || vendors.count == 0 {
            return
        }
        
        //-- payments
        self.paymentReportData.removeAll()
        for item in payments {
            let list: [String: AnyObject] = item as! [String: AnyObject]
            
            var name: String? = list["payment"] as? String
            if name == nil {
                name = ""
            }
            
            var amount: String? = list["totalAmount"] as? String
            if amount == nil {
                amount = "0"
            }
            
            let model: ReportModel = ReportModel()
            model.name = name!
            
            let value: Float = (amount! as NSString).floatValue
            model.value = String(format: "%0.2f", value)
            self.paymentReportData.append(model)
        }
        
        //-- vendors
        self.totalReportValue = 0
        self.vendorReportData.removeAll()
        for item in vendors {
            let list: [String: AnyObject] = item as! [String: AnyObject]
            
            var name: String? = list["vendor"] as? String
            if name == nil {
                name = ""
            }
            
            var amount: String? = list["totalAmount"] as? String
            if amount == nil {
                amount = "0"
            }
            
            let model: ReportModel = ReportModel()
            model.name = name!
            
            let value: Float = (amount! as NSString).floatValue
            model.value = String(format: "%0.2f", value)
            self.totalReportValue += value
            self.vendorReportData.append(model)
        }
    }
    
    func parseLocations(data: [String: Any]) {
        
        let resourceSets: [AnyObject]? = data["resourceSets"] as? [AnyObject]
        if resourceSets == nil || resourceSets!.count == 0 {
            return
        }
        
        let resources1: [String: AnyObject]? = resourceSets![0] as? [String: AnyObject]
        let itemsList2: [AnyObject]? = resources1!["resources"] as? [AnyObject]
        if itemsList2 == nil || itemsList2!.count == 0 {
            return
        }
        
        let resources2: [String: AnyObject]? = itemsList2![0] as? [String: AnyObject]
        let address: [String: AnyObject]? = resources2!["address"] as? [String: AnyObject]
        if address == nil || address!.count == 0 {
            return
        }
        
        self.locationStreet = (address!["addressLine"] as? String) ?? ""
        self.locationCity = (address!["locality"] as? String) ?? ""
        self.locationState = (address!["adminDistrict"] as? String) ?? ""
        self.locationZipcode = (address!["postalCode"] as? String) ?? ""
        self.locationFullAddress = (address!["formattedAddress"] as? String) ?? ""
    }
    
    func parseForExport(data: [AnyObject]) {
        
        self.exportsList!.removeAll()
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
            
            self.exportsList!.append(model)
        }
        print("-> export data size = \(self.exportsList!.count) ")
    }
    
    
    
    //MARK: - testing
    
    func testingPrint() {
        
        //-- testing only
        print("- ")
        print("- total payments = \(self.paymentsData!.count) ")
        print("- total vendors  = \(self.vendorsData!.count) ")
        print("- total expenses = \(self.expensesData!.count) ")
        print("- total top 10 = \(self.top10Data!.count) ")
        print("- ")
    }
}
