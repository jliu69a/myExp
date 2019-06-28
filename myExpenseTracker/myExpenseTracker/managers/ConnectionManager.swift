//
//  ConnectionManager.swift
//  myExpenseTracker
//
//  Created by Johnson Liu on 3/17/19.
//  Copyright © 2019 Home Office. All rights reserved.
//

import UIKit
import MapKit
import Alamofire


class ConnectionManager: NSObject {
    
    static let folder: String = "prod" //production use
    
    //MARK: - initial data
    
    class func loadInitialDataWithCallBack(completion: @escaping (_ json: Any) -> Void) {
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let dateText = df.string(from: Date())
        
        let urlString = String(format: "http://www.mysohoplace.com/php_hdb/php_GL/%@/init_data.php?date=%@", folder, dateText)
        let url = URL(string: urlString)!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            completion(json!)
        }
        task.resume()
    }
    
    //MARK: - expenses
    
    class func saveExpenseData(data: ExpenseModel, isForEdit: Bool, completion: @escaping (_ json: Any) -> Void) {
        
        //-- isEdit values, insert : -1
        //-- isEdit values, delete : 0
        //-- isEdit values, update : xxx
        
        var isEdit: String = ""
        
        if isForEdit {
            isEdit = "xxx"
        }
        else if data.expId <= 0 {
            isEdit = "-1"
        }
        else {
            isEdit = "0"
        }
        
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let currentDateText: String = df.string(from: DisplayManager.sharedInstance.selectedDate)
        
        let idText: String = String(format: "%d", data.expId)
        let vendorIdText: String = String(format: "%d", data.vendorId)
        let paymentIdText: String = String(format: "%d", data.paymentId)
        let amountText: String = String(format: "%0.2f", data.amount)
        
        print("-> raw data, amount = '\(data.amount)' ")
        print("-> raw data, notes = '\(data.note!)' ")
        
        var notes: NSString = data.note! as NSString
        notes = notes.replacingOccurrences(of: "&", with: "%26") as NSString
        notes = notes.replacingOccurrences(of: " ", with: "%20") as NSString
        
        let dataText: String = String(format: "id=%@&date=%@&time=%@&vendorid=%@&paymentid=%@&amount=%@&note=%@&isedit=%@&current=%@", idText, data.date!, data.time!, vendorIdText, paymentIdText, amountText, notes as String, isEdit, currentDateText)
        
        print("> ")
        print("> add/edit, dataText = '\(dataText)' ")
        print("> ")
        
        let urlString = String(format: "http://www.mysohoplace.com/php_hdb/php_GL/%@/edit_expenses.php", folder)
        let url: URL = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = dataText.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            completion(json!)
        }
        task.resume()
    }
    
    class func saveExpenseJsonData(data: ExpenseModel, isForEdit: Bool, completion: @escaping (_ json: Any) -> Void) {
        
        //-- isEdit values, insert : -1
        //-- isEdit values, delete : 0
        //-- isEdit values, update : xxx
        
        //-- HTTP POST, with JSON data.  use Alamofire Framework
        
        var isEdit: String = ""
        
        if isForEdit {
            isEdit = "xxx"
        }
        else if data.expId <= 0 {
            isEdit = "-1"
        }
        else {
            isEdit = "0"
        }
        
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let currentDateText: String = df.string(from: DisplayManager.sharedInstance.selectedDate)
        
        let idText: String = String(format: "%d", data.expId)
        let vendorIdText: String = String(format: "%d", data.vendorId)
        let paymentIdText: String = String(format: "%d", data.paymentId)
        let amountText: String = String(format: "%0.2f", data.amount)
        
        print("-> raw data, with JSON, amount = '\(data.amount)' ")
        print("-> raw data, with JSON, notes = '\(data.note!)' ")
        
        let parameters: [String: Any] = ["id": (idText as Any), "date": (data.date! as Any), "time": (data.time! as Any), "vendorid": (vendorIdText as Any), "paymentid": (paymentIdText as Any), "amount": (amountText as Any), "note": (data.note! as Any), "isedit": (isEdit as Any), "current": (currentDateText as Any)]
        
        let urlString = String(format: "http://www.mysohoplace.com/php_hdb/php_GL/%@/edit_expenses.php", folder)
        let url: URL = URL(string: urlString)!
        
        print("> ")
        print("> add/edit, with JSON, dataText = '\(parameters)' ")
        print("> ")
        
        Alamofire.request(url, method: HTTPMethod.post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil).validate().responseJSON { response in
            guard response.result.isSuccess else {
                print("Error while fetching remote rooms: \(String(describing: response.result.error))")
                completion("")
                return
            }
            
            let responseData: [String: Any]? = response.result.value as? [String: Any]
            if responseData == nil {
                completion("")
                print("- ")
                print("- response data : Null ")
                print("- ")
                return
            }
            
            print("- ")
            print("- response data : \(responseData!) ")
            print("- ")
            completion(responseData!)
        }
    }
    
    class func loadExpensesOnDate(date: String, completion: @escaping (_ json: Any) -> Void) {
        
        let urlString = String(format: "http://www.mysohoplace.com/php_hdb/php_GL/%@/expenses.php?date=%@", folder, date)
        let url = URL(string: urlString)!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            completion(json!)
        }
        task.resume()
    }
    
    //MARK: - payments & vendors
    
    class func savePayment(id: String, name: String, isForEdit: String, completion: @escaping (_ json: Any) -> Void) {
        
        let dataText: String = String(format: "id=%@&name=%@&edit=%@", id, name, isForEdit)
        
        let urlString = String(format: "http://www.mysohoplace.com/php_hdb/php_GL/%@/change_payment.php", folder)
        let url: URL = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = dataText.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            completion(json!)
        }
        task.resume()
    }
    
    class func saveJsonPayment(id: String, name: String, isForEdit: String, completion: @escaping (_ json: Any) -> Void) {
        
        let urlString = String(format: "http://www.mysohoplace.com/php_hdb/php_GL/%@/change_payment.php", folder)
        let url: URL = URL(string: urlString)!
        
        let parameters: [String: Any] = ["id": (id as Any), "name": (name as Any), "edit": (isForEdit as Any)]
        
        Alamofire.request(url, method: HTTPMethod.post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil).validate().responseJSON { response in
            guard response.result.isSuccess else {
                print("Error while fetching remote rooms: \(String(describing: response.result.error))")
                completion("")
                return
            }
            
            let responseData: [String: Any]? = response.result.value as? [String: Any]
            if responseData == nil {
                completion("")
                return
            }
            
            completion(responseData!)
        }
    }
    
    class func saveVendor(id: String, name: String, isForEdit: String, completion: @escaping (_ json: Any) -> Void) {
        
        let dataText: String = String(format: "id=%@&name=%@&edit=%@", id, name, isForEdit)
        
        let urlString = String(format: "http://www.mysohoplace.com/php_hdb/php_GL/%@/change_vendor.php", folder)
        let url: URL = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = dataText.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            completion(json!)
        }
        task.resume()
    }
    
    class func saveJsonVendor(id: String, name: String, isForEdit: String, completion: @escaping (_ json: Any) -> Void) {
        
        let urlString = String(format: "http://www.mysohoplace.com/php_hdb/php_GL/%@/change_vendor.php", folder)
        let url: URL = URL(string: urlString)!
        
        let parameters: [String: Any] = ["id": (id as Any), "name": (name as Any), "edit": (isForEdit as Any)]
        
        Alamofire.request(url, method: HTTPMethod.post, parameters: parameters, encoding: URLEncoding.httpBody, headers: nil).validate().responseJSON { response in
            guard response.result.isSuccess else {
                print("Error while fetching remote rooms: \(String(describing: response.result.error))")
                completion("")
                return
            }
            
            let responseData: [String: Any]? = response.result.value as? [String: Any]
            if responseData == nil {
                completion("")
                return
            }
            
            completion(responseData!)
        }
    }
    
    //MARK: - reports
    
    class func loadReports(month: String, year: String, isForAnnual: Bool, completion: @escaping (_ json: Any) -> Void) {
        
        let df: DateFormatter = DateFormatter()
        var monthText: String = month
        var yearText: String = year
        
        if monthText.count == 0 {
            df.dateFormat = "MM"
            monthText = df.string(from: Date())
        }
        if yearText.count == 0 {
            df.dateFormat = "yyyy"
            yearText = df.string(from: Date())
        }
        
        var yearMonth1: String = String(format: "%@-%@-", yearText, monthText)
        var yearMonth2: String = String(format: "%@/%d/", yearText, Int(monthText)!)
        if isForAnnual {
            yearMonth1 = String(format: "%@-", yearText)
            yearMonth2 = String(format: "%@/", yearText)
        }
        
        let urlString = String(format: "http://www.mysohoplace.com/php_hdb/php_GL/%@/reports.php?monthyear1=%@&monthyear2=%@", folder, yearMonth1, yearMonth2)
        let url = URL(string: urlString)!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            completion(json!)
        }
        task.resume()
    }
    
    //MARK: - location check
    
    class func checkLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, bingKey: String, completion: @escaping (_ json: Any) -> Void) {
        
        let latitudeValue: Double = latitude as Double
        let longitudeValue: Double = longitude as Double
        
        let urlString: String = String(format: "http://dev.virtualearth.net/REST/v1/Locations/%f,%f?o=json&key=%@", latitudeValue, longitudeValue, bingKey)
        let url = URL(string: urlString)!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            completion(json!)
        }
        task.resume()
    }
    
    //MARK: - export
    
    class func exportData(month: String, year: String, isMonthly: Bool, completion: @escaping (_ json: Any) -> Void) {
        
        let isMonthlyText: String = isMonthly ? "1" : "0"
        let urlString = String(format: "http://www.mysohoplace.com/php_hdb/php_GL/%@/expense_export.php?year=%@&month=%@&ismonthly=%@", folder, year, month, isMonthlyText)
        let url = URL(string: urlString)!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            completion(json!)
        }
        task.resume()
    }
    
}
