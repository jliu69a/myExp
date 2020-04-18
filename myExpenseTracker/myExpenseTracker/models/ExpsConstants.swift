//
//  ExpsConstants.swift
//  myExpenseTracker
//
//  Created by Johnson Liu on 3/17/19.
//  Copyright © 2019 Home Office. All rights reserved.
//

import UIKit


struct Constant {
    static let kInitialDataLoadedNotification: String = "Initial_Data_Loaded_Notification"
    static let kChangeExpensesDataNotification: String = "Change_Expenses_Data_Notification"
    
    static let kRefreshBackendDataNotification: String = "Refresh_Backend_Data_Notification"
    
    static let kChangePaymentDataNotification: String = "Change_Payment_Data_Notification"
    static let kChangeVendorDateNotification: String = "Change_Vendor_Date_Notification"
    
    static let kPaymentsAndVendorsReportNotification: String = "Payments_And_Vendors_Report_Notification"
    
    static let kExportMonthAndYearDataNotification: String = "Export_Month_And_Year_Data_Notification"
    
    static let kLocationCheckFullAddressNotification: String = "Location_Check_Full_Address_Notification"
    
    static let kVendorLookupWithYearNotification: String = "Vendor_Lookup_With_Year_Notification"
    
    static let kCreateLookupExpensesDataNotificatioon: String = "Create_Lookup_Expenses_Data_Notificatioon"
    
    static let kUserDefaultPaymentNameColorCodeKey: String = "User_Default_Payment_Name_Color_Code_Key"
    static let kUserDefaultPaymentIdColorCodeKey: String = "User_Default_Payment_Id_Color_Code_Key"
    
    static let kUserDefaultVendorNameColorCodeKey: String = "User_Default_Vendor_Name_Color_Code_Key"
    static let kUserDefaultVendortIdColorCodeKey: String = "User_Default_Vendor_Id_Color_Code_Key"
    
    static let kPaymentNameColorIndex: Int = 1
    static let kPaymentIdColorIndex: Int = 2
    static let kVendorNameColorIndex: Int = 3
    static let kVendorIdColorIndex: Int = 4
}


class ExpsConstants: NSObject {
    //
}
