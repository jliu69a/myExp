//
//  EditExpensesViewController.swift
//  MyExps
//
//  Created by Johnson Liu on 1/18/19.
//  Copyright © 2019 Home Office. All rights reserved.
//

import UIKit
import Foundation


class EditExpensesViewController: UIViewController, UITextFieldDelegate, ChangeDateViewControllerDelegate, PaymentsVendorsViewControllerDelegate {
    
    //@IBOutlet weak var titleBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    
    @IBOutlet weak var priceTextLabel: UILabel!
    
    @IBOutlet weak var selectPaymentButton: UIButton!
    @IBOutlet weak var selectVendorButton: UIButton!
    @IBOutlet weak var changeDateButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var backBarButtonItem: UIBarButtonItem!  //-- unlinked
    
    var changeDateVC: ChangeDateViewController? = nil
    var selectedModel: ExpenseModel? = nil
    
    var selectedDate: Date = Date()
    var selectedPayment: PAndVModel? = nil
    var selectedVendor: PAndVModel? = nil
    
    var isDataChanged: Bool = false
    var amountData: String = ""
    
    weak var parentVC: ExpenseHomeViewController? = nil
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.selectedModel == nil {
            self.amountData = "0.00"
            //self.titleBarButtonItem.title = "Add"
            self.titleLabel.text = "Add"
            self.priceTextLabel.text = self.amountData
            self.priceTextField.text = ""
        }
        else {
            //self.titleBarButtonItem.title = "Edit"
            self.titleLabel.text = "Edit"
            self.showExistingData()
        }
        
        self.selectedDate = DisplayManager.sharedInstance.selectedDate
        self.showDate(date: self.selectedDate)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.priceTextField.addTarget(self, action: #selector(changedPrice), for: UIControl.Event.editingChanged)
        
        self.selectPaymentButton.layer.cornerRadius = 5
        self.selectVendorButton.layer.cornerRadius = 5
        self.changeDateButton.layer.cornerRadius = 5
        self.saveButton.layer.cornerRadius = 5
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: - IB actions
    
    @IBAction func gobackAction(_ sender: Any) {
        
        if self.isDataChanged {
            
            let alert: UIAlertController = UIAlertController(title: "Your haven't saved your data.  Do you want to exit?", message: nil, preferredStyle: UIAlertController.Style.alert)
            
            let okAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action) in
                self.dismissKeyboards()
                self.navigationController!.popViewController(animated: true)
            }
            
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
        else {
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    @IBAction func selectPaymentAction(_ sender: Any) {
        self.dismissKeyboards()
        
        let storyboard: UIStoryboard = UIStoryboard.init(name: "pandv", bundle: nil)
        let vc: PaymentsVendorsViewController? = storyboard.instantiateViewController(withIdentifier: "PaymentsVendorsViewController") as? PaymentsVendorsViewController
        vc!.delegate = self
        vc!.isForPayments = true
        self.navigationController!.pushViewController(vc!, animated: true)
    }
    
    @IBAction func selectVendorAction(_ sender: Any) {
        self.dismissKeyboards()
        
        let storyboard: UIStoryboard = UIStoryboard.init(name: "pandv", bundle: nil)
        let vc: PaymentsVendorsViewController? = storyboard.instantiateViewController(withIdentifier: "PaymentsVendorsViewController") as? PaymentsVendorsViewController
        vc!.delegate = self
        vc!.isForPayments = false
        self.navigationController!.pushViewController(vc!, animated: true)
    }
    
    @IBAction func changeDateAction(_ sender: Any) {
        self.dismissKeyboards()
        
        let storyboard: UIStoryboard = UIStoryboard.init(name: "expenseHome", bundle: nil)
        self.changeDateVC = storyboard.instantiateViewController(withIdentifier: "ChangeDateViewController") as? ChangeDateViewController
        self.changeDateVC!.delegate = self
        
        self.changeDateVC!.currentDate = Date()
        if self.selectedModel != nil {
            let df: DateFormatter = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            self.changeDateVC!.currentDate = df.date(from: self.selectedModel!.date!)!
        }
        
        self.present(self.changeDateVC!, animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
        //-- save data here
        self.dismissKeyboards()
        
        if self.selectedPayment == nil || self.selectedVendor == nil {
            UtilsManager.sharedInstance.showAlertMessage(message: nil, title: "The payment and vendor data are required.", controller: self)
            return
        }
        
        if !self.isDataChanged {
            self.navigationController!.popViewController(animated: true)
            return
        }
        
        self.parentVC!.showProcessIndicator()
        self.prepareData()
        self.navigationController!.popViewController(animated: true)
    }
    
    //MARK: - display data
    
    func showExistingData() {
        
        let amountValue: Float = self.selectedModel!.amount
        self.amountData = String(format: "%0.2f", amountValue)
        self.priceTextLabel.text = self.amountData
        self.priceTextField.text = String(format: "%0.0f", (amountValue * 100.0))
        
        self.notesTextField.text = self.selectedModel!.note!
        
        self.changeDateButton.setTitle(self.selectedModel!.date!, for: UIControl.State.normal)
        self.changeDateButton.setTitle(self.selectedModel!.date!, for: UIControl.State.highlighted)
        
        //-- payment
        let paymentId: String = String(format: "%d", self.selectedModel!.paymentId)
        for item in DataManager.sharedInstance.paymentsData! {
            if paymentId == item.pvId! {
                self.selectedPayment = item
                break
            }
        }
        self.showSelectedPayment()
        
        //-- vendor
        let vendorId: String = String(format: "%d", self.selectedModel!.vendorId)
        for item in DataManager.sharedInstance.vendorsData! {
            if vendorId == item.pvId! {
                self.selectedVendor = item
                break
            }
        }
        self.showSelectedVendor()
    }
    
    func showSelectedPayment() {
        
        let name: String = String(format: "%@ (%@)", self.selectedPayment!.pvName!, self.selectedPayment!.pvId!)
        self.selectPaymentButton.setTitle(name, for: UIControl.State.normal)
        self.selectPaymentButton.setTitle(name, for: UIControl.State.highlighted)
        print("-> selected payment: \(self.selectedPayment!.pvName!), id = \(self.selectedPayment!.pvId!) ")
    }
    
    func showSelectedVendor() {
        
        let name: String = String(format: "%@ (%@)", self.selectedVendor!.pvName!, self.selectedVendor!.pvId!)
        self.selectVendorButton.setTitle(name, for: UIControl.State.normal)
        self.selectVendorButton.setTitle(name, for: UIControl.State.highlighted)
        print("-> selected vendor: \(self.selectedVendor!.pvName!), id = \(self.selectedVendor!.pvId!) ")
    }
    
    //MARK: - utils
    
    func dismissKeyboards() {
        
        self.priceTextField.resignFirstResponder()
        self.notesTextField.resignFirstResponder()
    }
    
    @objc func changedPrice() {
        
        let priceValue: Float = fabsf((self.priceTextField.text! as NSString).floatValue / 100.0)
        self.amountData = String(format: "%0.2f", priceValue)
        self.priceTextLabel.text = self.amountData
        self.isDataChanged = true
    }
    
    func showDate(date: Date) {
        
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        
        self.changeDateButton.setTitle(df.string(from: date), for: UIControl.State.normal)
        self.changeDateButton.setTitle(df.string(from: date), for: UIControl.State.highlighted)
    }
    
    func prepareData() {
        
        var isForEdit: Bool = true
        if self.selectedModel == nil {
            self.selectedModel = ExpenseModel()
            self.selectedModel!.expId = -1
            isForEdit = false
        }
        
        let rightNow: Date = Date()
        
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let dateText: String = df.string(from: self.selectedDate)
        
        df.dateFormat = "HH:mm:ss"
        let timeText: String = df.string(from: rightNow)
        
        self.selectedModel!.date = dateText
        self.selectedModel!.time = timeText
        
        self.selectedModel!.vendor = self.selectedVendor!.pvName!
        self.selectedModel!.vendorId = (self.selectedVendor!.pvId! as NSString).integerValue
        
        self.selectedModel!.payment = self.selectedPayment!.pvName!
        self.selectedModel!.paymentId = (self.selectedPayment!.pvId! as NSString).integerValue
        
        self.selectedModel!.amount = (self.amountData as NSString).floatValue
        self.selectedModel!.note = self.notesTextField.text ?? ""
        
        //-- call API here
        if Reachability.isConnectedToNetwork() {
            DataManager.sharedInstance.changeExpenseJsonData(data: self.selectedModel!, isForEdit: isForEdit)
        }
        else {
            AlertManager.showAlert(title: UserManager.sharedInstance.noInternetAlertTitle, message: UserManager.sharedInstance.noInternetAlertMessage, controller: self)
        }
    }
    
    //MARK: - text field delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.dismissKeyboards()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.priceTextField {
            
            //-- allow back space
            if string.count == 0 {
                return true
            }
            
            let priceValue: Int? = Int(string)
            if priceValue == nil {
                return false
            }
            else {
                return true
            }
        }
        
        self.isDataChanged = true
        return true
    }
    
    //MARK: - change date delegate
    
    func cancelSelectDate() {
        self.closeChangeDateView()
    }
    
    func selectNewDate(date: Date) {
        
        self.selectedDate = date
        self.showDate(date: self.selectedDate)
        self.closeChangeDateView()
        self.isDataChanged = true
        
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        self.changeDateButton.setTitle(df.string(from: self.selectedDate), for: UIControl.State.normal)
        self.changeDateButton.setTitle(df.string(from: self.selectedDate), for: UIControl.State.highlighted)
    }
    
    func closeChangeDateView() {
        
        if self.changeDateVC != nil {
            self.changeDateVC!.dismiss(animated: true, completion: nil)
            self.changeDateVC = nil
        }
    }
    
    //MARK: - payments & vendors
    
    func didSelectItem(item: PAndVModel, isForPayments: Bool) {
        
        if isForPayments {
            self.selectedPayment = item
            self.showSelectedPayment()
        }
        else {
            self.selectedVendor = item
            self.showSelectedVendor()
        }
        self.isDataChanged = true
    }
    
}
