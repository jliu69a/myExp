//
//  ExpenseModel.swift
//  myExpenseTracker
//
//  Created by Johnson Liu on 3/17/19.
//  Copyright © 2019 Home Office. All rights reserved.
//

import UIKit

class ExpenseModel: NSObject {
    
    var expId: Int = 0
    var date: String? = ""
    var time: String? = ""
    var vendor: String? = ""
    var vendorId: Int = 0
    var payment: String? = ""
    var paymentId: Int = 0
    var amount: Float = 0
    var note: String? = ""
}
