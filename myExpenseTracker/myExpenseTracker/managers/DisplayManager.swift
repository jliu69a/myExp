//
//  DisplayManager.swift
//  myExpenseTracker
//
//  Created by Johnson Liu on 3/17/19.
//  Copyright © 2019 Home Office. All rights reserved.
//

import UIKit

class DisplayManager: NSObject {
    
    static let sharedInstance = DisplayManager()
    
    var selectedDate: Date = Date()
    
    let beginYear: Int = 1950
    let endYear: Int = 2050
    var monthsList: [String] = []
    var yearsList: [String] = []
    
    let veryLightGray: UIColor = UIColor.init(red: (249.0/255.0), green: CGFloat(249.0/255.0), blue: (249.0/255.0), alpha: 1.0)
    
    let colorsData: [[String: AnyObject]] = [["name":"Black" as AnyObject, "color":UIColor.black],
                                             ["name":"Light Gray" as AnyObject, "color":UIColor.lightGray],
                                             ["name":"Dark Gray" as AnyObject, "color":UIColor.darkGray],
                                             ["name":"Blue" as AnyObject, "color": UIColor.blue],
                                             ["name":"Brown" as AnyObject, "color":UIColor.brown],
                                             ["name":"Cyan" as AnyObject, "color":UIColor.cyan],
                                             ["name":"Green" as AnyObject, "color":UIColor.green],
                                             ["name":"Magenta" as AnyObject, "color":UIColor.magenta],
                                             ["name":"Orange" as AnyObject, "color":UIColor.orange],
                                             ["name":"Purple" as AnyObject, "color":UIColor.purple],
                                             ["name":"Red" as AnyObject, "color":UIColor.red],
                                             ["name":"Yellow" as AnyObject, "color":UIColor.yellow],
                                             ["name":"White" as AnyObject, "color":UIColor.white],
                                             ["name":"Clear" as AnyObject, "color":UIColor.clear]
    ]
    
    var paymentNameColorCode: Int = 0
    var paymentIdColorCode: Int = 1
    
    var vendorNameColorCode: Int = 0
    var vendorIdColorCode: Int = 1
    
    var paymentNameColor: UIColor = UIColor.black
    var paymentIdColor: UIColor = UIColor.gray
    
    var vendorNameColor: UIColor = UIColor.black
    var vendorIdColor: UIColor = UIColor.gray
    
    var backBarButtonItem: UIButton = UIButton(type: UIButton.ButtonType.custom)
    var moreBarButtonItem: UIButton = UIButton(type: UIButton.ButtonType.custom)
    
    var adminList: [[String: AnyObject]] = []
    
    
    func createBackButton() {
        
        self.backBarButtonItem.setImage(UIImage(named: "myExp_back.png"), for: UIControl.State.normal)
        self.backBarButtonItem.setImage(UIImage(named: "myExp_back.png"), for: UIControl.State.highlighted)
        self.backBarButtonItem.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
    }
    
    func createMoreButton() {
        
        self.moreBarButtonItem.setImage(UIImage(named: "myExp_more.png"), for: UIControl.State.normal)
        self.moreBarButtonItem.setImage(UIImage(named: "myExp_more.png"), for: UIControl.State.highlighted)
        self.moreBarButtonItem.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
    }
    
    func createAdminList() {
        
        let coreList: [AnyObject] = ["Change Color" as AnyObject, "Edit Payments" as AnyObject, "Edit Vendors" as AnyObject, "Monthly Report" as AnyObject, "Annual Report" as AnyObject]
        let coreData: [String: AnyObject] = ["Expense": coreList as AnyObject]
        self.adminList.append(coreData)
        
        let miscList: [AnyObject] = ["Location Check" as AnyObject, "BlueTooth Connect" as AnyObject]
        let miscData: [String: AnyObject] = ["Misc": miscList as AnyObject]
        self.adminList.append(miscData)
    }
    
    func createYearsAndMonths() {
        
        self.monthsList.removeAll()
        self.monthsList = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        
        self.yearsList.removeAll()
        for eachYear in self.beginYear...self.endYear {
            let yearText: String = String(format: "%d", eachYear)
            self.yearsList.append(yearText)
        }
    }
    
}
