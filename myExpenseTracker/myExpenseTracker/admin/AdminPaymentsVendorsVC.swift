//
//  AdminPaymentsVendorsVC.swift
//  MyExps
//
//  Created by Johnson Liu on 1/22/19.
//  Copyright © 2019 Home Office. All rights reserved.
//

import UIKit

class AdminPaymentsVendorsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //@IBOutlet weak var titleBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var titleLabe: UILabel!
    @IBOutlet weak var addNewButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var rowsList: [PAndVModel] = []
    var isForVendor: Bool = false
    var selectedModel: PAndVModel? = nil
    
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "PAndVCell", bundle: nil), forCellReuseIdentifier: "CellId")
        
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishUpdate), name: NSNotification.Name(rawValue: Constant.kChangePaymentDataNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishUpdate), name: NSNotification.Name(rawValue: Constant.kChangeVendorDateNotification), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.layer.borderColor = UIColor.black.cgColor
        self.tableView.layer.borderWidth = 0.5
        
        self.addNewButton.layer.cornerRadius = 5
        
        if isForVendor {
            self.titleLabe.text = "Vendor"
        }
        else {
            self.titleLabe.text = "Payment"
        }
        self.refreshData()
        
        self.selectedModel = nil
    }
    
    //MARK: - IB actions
    
    @IBAction func gobackAction(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func addNewButton(_ sender: Any) {
        self.changeModel(isNew: true)
    }
    
    //MARK: - table view source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if self.isForVendor {
            return DataManager.sharedInstance.vendorGroupKeys!.count
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.isForVendor {
            let key: String = DataManager.sharedInstance.vendorGroupKeys![section]
            var list: [PAndVModel]? = DataManager.sharedInstance.vendorGroups![key]
            if list == nil {
                list = []
            }
            return list!.count
        }
        else {
            return self.rowsList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var model: PAndVModel? = nil
        
        if self.isForVendor {
            let key: String = DataManager.sharedInstance.vendorGroupKeys![indexPath.section]
            var list: [PAndVModel]? = DataManager.sharedInstance.vendorGroups![key]
            if list == nil {
                list = []
            }
            model = list![indexPath.row]
        }
        else {
            model = self.rowsList[indexPath.row]
        }
        
        let cell: PAndVCell? = self.tableView.dequeueReusableCell(withIdentifier: "CellId") as? PAndVCell
        
        cell!.nameLabel.text = model!.pvName
        cell!.idLabel.text = model!.pvId
        
        var nameColorCode: Int = -1
        var idColorCode: Int = -1
        
        if self.isForVendor {
            nameColorCode = DisplayManager.sharedInstance.vendorNameColorCode
            idColorCode = DisplayManager.sharedInstance.vendorIdColorCode
        }
        else {
            nameColorCode = DisplayManager.sharedInstance.paymentNameColorCode
            idColorCode = DisplayManager.sharedInstance.paymentIdColorCode
        }
        
        let nameData: [String: AnyObject] = DisplayManager.sharedInstance.colorsData[nameColorCode]
        cell!.nameLabel.textColor = nameData["color"] as? UIColor
        
        let idData: [String: AnyObject] = DisplayManager.sharedInstance.colorsData[idColorCode]
        cell!.idLabel.textColor = idData["color"] as? UIColor
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if self.isForVendor {
            return 30
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if self.isForVendor {
            return DataManager.sharedInstance.vendorGroupKeys![section]
        }
        else {
            return nil
        }
    }
    
    //MARK: - table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        if self.isForVendor {
            let key: String = DataManager.sharedInstance.vendorGroupKeys![indexPath.section]
            var list: [PAndVModel]? = DataManager.sharedInstance.vendorGroups![key]
            if list == nil {
                list = []
            }
            self.selectedModel = list![indexPath.row]
        }
        else {
            self.selectedModel = self.rowsList[indexPath.row]
        }
        
        let alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let editAction: UIAlertAction = UIAlertAction(title: "Edit", style: UIAlertAction.Style.default) { (action) in
            self.changeModel(isNew: false)
        }
        
        let deleteAction: UIAlertAction = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default) { (action) in
            self.confirmToDelete()
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - change payment & vendor
    
    func changeModel(isNew: Bool) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "admin", bundle: nil)
        let vc: AdminPVEditViewController? = storyboard.instantiateViewController(withIdentifier: "AdminPVEditViewController") as? AdminPVEditViewController
        vc!.isForVendor = self.isForVendor

        if isNew {
            vc!.selectedModel = nil
        }
        else {
            vc!.selectedModel = self.selectedModel
        }
        self.navigationController!.pushViewController(vc!, animated: true)
    }
    
    func confirmToDelete() {
        
        var title: String = ""
        if self.isForVendor {
            title = String(format: "Do you want to delete the vendor \"%@\"?", self.selectedModel!.pvName!)
        }
        else {
            title = String(format: "Do you want to delete the payment type \"%@\"?", self.selectedModel!.pvName!)
        }
        
        let alert: UIAlertController = UIAlertController(title: title, message: nil, preferredStyle: UIAlertController.Style.alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        let okAction: UIAlertAction = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default) { (action) in
            self.deleteModel()
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteModel() {
        
        let idValue: String = self.selectedModel!.pvId!
        let nameValue: String = self.selectedModel!.pvName!
        
        if self.isForVendor {
            if Reachability.isConnectedToNetwork() {
                
                //-- HTTP POST, with query string
                //DataManager.sharedInstance.changeVendor(id: idValue, name: nameValue, isForEdit: "0")
                
                //-- HTTP POST, with Json data
                DataManager.sharedInstance.changeJsonVendor(id: idValue, name: nameValue, isForEdit: "0")
            }
            else {
                AlertManager.showAlert(title: UserManager.sharedInstance.noInternetAlertTitle, message: UserManager.sharedInstance.noInternetAlertMessage, controller: self)
            }
        }
        else {
            if Reachability.isConnectedToNetwork() {
                
                //-- HTTP POST, with query string
                //DataManager.sharedInstance.changePayment(id: idValue, name: nameValue, isForEdit: "0")
                
                //-- HTTP POST, with Json data
                DataManager.sharedInstance.changeJsonPayment(id: idValue, name: nameValue, isForEdit: "0")
            }
            else {
                AlertManager.showAlert(title: UserManager.sharedInstance.noInternetAlertTitle, message: UserManager.sharedInstance.noInternetAlertMessage, controller: self)
            }
        }
    }
    
    func refreshData() {
        
        if isForVendor {
            self.rowsList = DataManager.sharedInstance.vendorsData!
        }
        else {
            self.rowsList = DataManager.sharedInstance.paymentsData!
        }
        self.tableView.reloadData()
    }
    
    //MARK: - notification
    
    @objc func didFinishUpdate() {
        
        DispatchQueue.main.async {
            self.refreshData()
        }
    }
    
}
