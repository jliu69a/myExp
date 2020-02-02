//
//  DataHandlingManager.swift
//  myExpenseTracker
//
//  Created by Johnson Liu on 2/2/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import PromiseKit


class DataHandlingManager: NSObject {
    
    func dataFromUrlPromise(url: String, isForPost: Bool, param: Parameters?, header:HTTPHeaders?) -> Promise<JSON> {
        return Promise {
            seal in
            
            let manager: Connect2Manager = Connect2Manager()
            manager.jsonDataFromUrl(url: url, isPostRequest: isForPost, apiParameters: param, apiHeader: header) { (result)->() in
                seal.fulfill(result)
            }
        }
    }
    
}
