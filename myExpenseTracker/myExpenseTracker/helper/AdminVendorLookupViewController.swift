//
//  AdminVendorLookupViewController.swift
//  myExpenseTracker
//
//  Created by Johnson Liu on 8/6/19.
//  Copyright © 2019 Home Office. All rights reserved.
//

import UIKit

class AdminVendorLookupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //-- base view
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var displayView: UIView!
    
    @IBOutlet weak var selectedYearLabel: UILabel!
    @IBOutlet weak var selectedVendorIdLabel: UILabel!
    
    @IBOutlet weak var changeYearButton: UIButton!
    @IBOutlet weak var changeVendorButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var lookupButton: UIButton!
    @IBOutlet weak var titleYearLabel: UILabel!
    
    //-- display view
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeLookUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    var rowsArray: [ExpenseModel]? = []
    var keysList: [String] = []
    var rowsGroups: [String: [ExpenseModel]]? = [:]
    
    var selectedYear: String = ""
    var selectedVendorId: String = ""
    
    var df:DateFormatter = DateFormatter()
    
    
    //MARK: - init

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideDisplayView()
        self.activityIndicator.stopAnimating()
        
        df.dateFormat = "YYYY"
        self.selectedYear = df.string(from: Date())
        self.selectedYearLabel.text = String(format: "Selected Year : %@", self.selectedYear)
        
        self.selectedVendorId = "0"
        self.selectedVendorIdLabel.text = String(format: "Selected Vendor ID : %@", self.selectedVendorId)
        
        self.tableView.register(UINib(nibName: "ExpenseCell", bundle: nil), forCellReuseIdentifier: "CellId")
        
        self.titleYearLabel.text = ""

        NotificationCenter.default.addObserver(self, selector: #selector(showLookupVendors), name: NSNotification.Name(rawValue: Constant.kVendorLookupWithYearNotification), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.layer.borderColor = UIColor.black.cgColor
        self.tableView.layer.borderWidth = 0.5
        
        self.changeYearButton.layer.cornerRadius = 5
        self.changeVendorButton.layer.cornerRadius = 5
        self.cancelButton.layer.cornerRadius = 5
        self.lookupButton.layer.cornerRadius = 5
        
        self.closeLookUpButton.layer.cornerRadius = 5
    }
    
    //MARK: - IBAction functions
    
    @IBAction func changeYearAction(_ sender: Any) {
        //
    }
    
    @IBAction func changeVendorAction(_ sender: Any) {
        //
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func lookupAction(_ sender: Any) {
        
        self.activityIndicator.startAnimating()
        self.processLookup()
    }
    
    @IBAction func closeLookupAction(_ sender: Any) {
        
        //-- on display view
        self.hideDisplayView()
        
        self.rowsArray!.removeAll()
        self.tableView.reloadData()
    }
    
    //MARK: - table view source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.keysList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let key: String = self.keysList[section]
        let list: [ExpenseModel]? = self.rowsGroups![key]
        return list!.count as Int
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ExpenseCell? = self.tableView.dequeueReusableCell(withIdentifier: "CellId") as? ExpenseCell
        
        let key: String = self.keysList[indexPath.section]
        let list: [ExpenseModel]? = self.rowsGroups![key]
        let data: ExpenseModel = list![indexPath.row]
        
        cell!.cellVendorLabel.text = data.vendor!
        cell!.cellPaymentLabel.text = data.payment!
        cell!.cellNotesLabel.text = data.note!
        cell!.cellTimeLabel.text = String(format: "on: %@, %@", data.date!, data.time!)
        
        let amountText = String(format: "%0.2f", data.amount)
        cell!.cellAmountLabel.text = amountText
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let key: String = self.keysList[section]
        let keyValue: Int = Int(key)!
        let title: String = DataManager.sharedInstance.monthsList[keyValue]
        
        return title
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        view.tintColor = UIColor.black
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.green
    }
    
    //MARK: - table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK: - notifications
    
    @objc func showLookupVendors() {
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.titleYearLabel.text = String(format: "( %@ )", self.selectedYear)
            
            self.rowsArray = DataManager.sharedInstance.lookupExpensesData
            
            self.keysList = DataManager.sharedInstance.lookupTitleList
            self.rowsGroups = DataManager.sharedInstance.lookupExpensesList!
            
            if self.rowsArray == nil {
                self.rowsArray = []
            }
            self.tableView.reloadData()
            
            self.showDisplayView()
        }
    }
    
    //MARK: - vendor lookup
    
    func showDisplayView() {
        self.displayView.isHidden = false
    }
    
    func hideDisplayView() {
        self.displayView.isHidden = true
    }
    
    func processLookup() {
        
        if self.selectedYear.count == 0 {
            df.dateFormat = "YYYY"
            self.selectedYear = df.string(from: Date())
        }
        
        if self.selectedVendorId.count == 0 {
            self.selectedVendorId = "0"
        }
        
        print("- ")
        print("- vendor lookup, year = \(self.selectedYear) ")
        print("- vendor lookup, vendor ID = \(self.selectedVendorId) ")
        print("- ")

        DataManager.sharedInstance.vendorLookup(year: self.selectedYear, vendorId: self.selectedVendorId)
    }
    
}
