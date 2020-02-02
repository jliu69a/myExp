//
//  Connect2Manager.swift
//  myExpenseTracker
//
//  Created by Johnson Liu on 2/2/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import PromiseKit


class Connect2Manager: NSObject {
    
    func jsonDataFromUrl(url: String, isPostRequest: Bool, apiParameters: Parameters?, apiHeader: HTTPHeaders?, complete: @escaping (_ reviews: JSON) -> ()) {
        
        var selectedMethod: HTTPMethod = HTTPMethod.get
        var selectedParameters: Parameters? = nil
        var selectedHeaders: HTTPHeaders? = nil
        
        if isPostRequest {
            selectedMethod = HTTPMethod.post
            if apiParameters != nil {
                selectedParameters = apiParameters!
            }
            if selectedHeaders != nil {
                selectedHeaders = apiHeader!
            }
        }
        
        Alamofire.request(url, method: selectedMethod, parameters: selectedParameters, encoding: JSONEncoding.default, headers: selectedHeaders).responseJSON { response in
            
            guard response.result.error == nil else {
                let error: JSON = JSON.init(parseJSON: "{\"error\": \(response.result.error!)}")
                complete(error)
                return
            }
            
            if let value = response.result.value {
                let swiftyJsonVar = JSON(value)
                complete(swiftyJsonVar)
            }
            else {
                let error: JSON = JSON.init(parseJSON: "{\"error\": \"Error occured while trying to parse data.\"}")
                complete(error)
            }
        }
    }
    
}
