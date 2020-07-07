//
//  AdminSelectDatesViewController.swift
//  myExpenseTracker
//
//  Created by Johnson Liu on 6/10/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit


protocol AdminSelectDatesViewControllerDelegate: AnyObject {
    
    func closePage()
    func selectedDate(dateString: String)
}


class AdminSelectDatesViewController: UIViewController {
    
    var isForYearsOnly: Bool = false
    
    weak var delegate: AdminSelectDatesViewControllerDelegate?
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //MARK: IB actions
    
    @IBAction func cancelAction(_ sender: Any) {
        self.delegate?.closePage()
    }
    
    @IBAction func selectDateAction(_ sender: Any) {
        self.delegate?.selectedDate(dateString: "")
    }
    
    
}
