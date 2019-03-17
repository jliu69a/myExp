//
//  ChangeDateViewController.swift
//  MyExps
//
//  Created by Johnson Liu on 1/15/19.
//  Copyright © 2019 Home Office. All rights reserved.
//

import UIKit


protocol ChangeDateViewControllerDelegate: AnyObject {
    
    func cancelSelectDate()
    func selectNewDate(date: Date)
}


class ChangeDateViewController: UIViewController {
    
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var selectButton: UIButton!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    weak var delegate: ChangeDateViewControllerDelegate?
    
    var currentDate: Date = Date()
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        self.datePicker.date = self.currentDate
        
        self.todayButton.layer.cornerRadius = 5
        self.cancelButton.layer.cornerRadius = 5
        self.selectButton.layer.cornerRadius = 5
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: - IB actions
    
    @IBAction func setToTodayAction(_ sender: Any) {
        self.datePicker.date = Date()
        self.delegate!.selectNewDate(date: self.datePicker.date)
    }
    
    @IBAction func cancelDateSelectAction(_ sender: Any) {
        self.delegate!.cancelSelectDate()
    }
    
    @IBAction func selectPickerDateAction(_ sender: Any) {
        self.delegate!.selectNewDate(date: self.datePicker.date)
    }
}
