//
//  AdminPVEditViewController.swift
//  MyExps
//
//  Created by Johnson Liu on 1/22/19.
//  Copyright © 2019 Home Office. All rights reserved.
//

import UIKit

class AdminPVEditViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var idValueLabel: UILabel!
    @IBOutlet weak var nameValueTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var isForVendor: Bool = false
    var selectedModel: PAndVModel? = nil
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishUpdate), name: NSNotification.Name(rawValue: Constant.kChangePaymentDataNotification), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(didFinishUpdate), name: NSNotification.Name(rawValue: Constant.kChangeVendorDateNotification), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.saveButton.layer.cornerRadius = 5
        
        if self.isForVendor {
            self.titleLabel.text = "Vendor"
        }
        else {
            self.titleLabel.text = "Payment"
        }
        
        if self.selectedModel == nil {
            self.idValueLabel!.text = "ID: n/a"
            self.nameValueTextField.text = nil
            
            self.saveButton.setTitle("Create New", for: UIControl.State.normal)
            self.saveButton.setTitle("Create New", for: UIControl.State.highlighted)
        }
        else {
            self.idValueLabel!.text = String(format: "ID: %@", self.selectedModel!.pvId!)
            self.nameValueTextField.text = self.selectedModel!.pvName!
            
            self.saveButton.setTitle("Save Changes", for: UIControl.State.normal)
            self.saveButton.setTitle("Save Changes", for: UIControl.State.highlighted)
        }
    }
    
    //MARK: - IB action
    
    @IBAction func gobackAction(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
        if self.nameValueTextField.text == nil || self.nameValueTextField.text!.count == 0 {
            UtilsManager.sharedInstance.showAlertMessage(message: nil, title: "The name cannot be blank.", controller: self)
            return
        }
        self.clearKeyboard()
        
        var idValue: String = "-1"
        var isForEdit: String = "0"
        if self.selectedModel != nil {
            idValue = self.selectedModel!.pvId!
            isForEdit = "1"
        }
        
        let nameValue: String = self.nameValueTextField.text!
        
        if self.isForVendor {
            DataManager.sharedInstance.changeVendor(id: idValue, name: nameValue, isForEdit: isForEdit)
        }
        else {
            DataManager.sharedInstance.changePayment(id: idValue, name: nameValue, isForEdit: isForEdit)
        }
    }
    
    //MARK: - text field delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.clearKeyboard()
        return true
    }
    
    //MARK: - notification
    
    @objc func didFinishUpdate() {
        
        DispatchQueue.main.async {
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    //MARK: - local functions
    
    func clearKeyboard() {
        self.nameValueTextField.resignFirstResponder()
    }
}
