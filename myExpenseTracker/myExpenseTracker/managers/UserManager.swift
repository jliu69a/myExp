//
//  UserManager.swift
//  myExpenseTracker
//
//  Created by Johnson Liu on 3/17/19.
//  Copyright © 2019 Home Office. All rights reserved.
//

import UIKit

final class UserManager: NSObject {
    
    static let sharedInstance = UserManager()
    
    var userId: String? = ""
    var userName: String? = ""
    var password: String? = ""
}
