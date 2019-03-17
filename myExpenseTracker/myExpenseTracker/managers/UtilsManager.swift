//
//  UtilsManager.swift
//  myExpenseTracker
//
//  Created by Johnson Liu on 3/17/19.
//  Copyright © 2019 Home Office. All rights reserved.
//

import UIKit

class UtilsManager: NSObject {
    
    static let sharedInstance = UtilsManager()
    
    func createCsvFromExpenseData(data: [ExpenseModel]) -> String {
        
        if data.count == 0 {
            return ""
        }
        
        var csvText: String = "id,date,time,vendorId,vendor,paymentId,payment,amount,note\n"
        for each in data {
            let line: String = String(format: "%d,%@,%@,%d,%@,%d,%@,%0.2f,\"%@\"\n", each.expId, each.date!, each.time!, each.vendorId, each.vendor!, each.paymentId, each.payment!, each.amount, each.note!)
            csvText = csvText + line
        }
        
        return csvText
    }
    
    func showAlertMessage(message: String?, title: String?, controller: UIViewController) {
        
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okAction)
        controller.present(alert, animated: true, completion: nil)
    }
    
}
