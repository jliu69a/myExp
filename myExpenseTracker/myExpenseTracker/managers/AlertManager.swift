//
//  AlertManager.swift
//  myExpenseTracker
//
//  Created by Johnson Liu on 5/19/19.
//  Copyright © 2019 Home Office. All rights reserved.
//

import UIKit

class AlertManager: NSObject {
    
    class func showAlert(title: String, message: String, controller: UIViewController) {
        
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okAction)
        controller.present(alert, animated: true, completion: nil)
    }
}
