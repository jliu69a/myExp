//
//  ExpenseHomeViewController.swift
//  MyExps
//
//  Created by Johnson Liu on 1/14/19.
//  Copyright © 2019 Home Office. All rights reserved.
//

import UIKit

class ExpenseHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ChangeDateViewControllerDelegate {
    
    @IBOutlet weak var displayDateLabel: UILabel!
    @IBOutlet weak var displayAmountLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var rowsArray:[ExpenseModel]? = []
    
    var changeDateVC: ChangeDateViewController? = nil
    var selectedExpenseItem: ExpenseModel? = nil
    
    var editExpenseVC: EditExpensesViewController? = nil
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DisplayManager.sharedInstance.createBackButton()
        DisplayManager.sharedInstance.createMoreButton()
        DisplayManager.sharedInstance.createYearsAndMonths()
        
        //-- initial
        DataManager.sharedInstance.loadInitialData()
        self.activityIndicator.startAnimating()
        DisplayManager.sharedInstance.selectedDate = Date()
        
        //-- color codes
        var paymentNameColorCode: String? = UserDefaults.standard.object(forKey: Constant.kUserDefaultPaymentNameColorCodeKey) as? String
        if paymentNameColorCode == nil || paymentNameColorCode!.count == 0 {
            paymentNameColorCode = "0"
        }
        DisplayManager.sharedInstance.paymentNameColorCode = Int(paymentNameColorCode!)!
        
        var paymentIdColorCode: String? = UserDefaults.standard.object(forKey: Constant.kUserDefaultPaymentIdColorCodeKey) as? String
        if paymentIdColorCode == nil || paymentIdColorCode!.count == 0 {
            paymentIdColorCode = "1"
        }
        DisplayManager.sharedInstance.paymentIdColorCode = Int(paymentIdColorCode!)!
        
        var vendorNameColorCode: String? = UserDefaults.standard.object(forKey: Constant.kUserDefaultVendorNameColorCodeKey) as? String
        if vendorNameColorCode == nil || vendorNameColorCode!.count == 0 {
            vendorNameColorCode = "0"
        }
        DisplayManager.sharedInstance.vendorNameColorCode = Int(vendorNameColorCode!)!
        
        var vendorIdColorCode: String? = UserDefaults.standard.object(forKey: Constant.kUserDefaultVendortIdColorCodeKey) as? String
        if vendorIdColorCode == nil || vendorIdColorCode!.count == 0 {
            vendorIdColorCode = "1"
        }
        DisplayManager.sharedInstance.vendorIdColorCode = Int(vendorIdColorCode!)!
        
        
        //-- table view
        self.tableView.layer.borderColor = UIColor.black.cgColor
        self.tableView.layer.borderWidth = 0.5
        self.tableView.register(UINib(nibName: "ExpenseCell", bundle: nil), forCellReuseIdentifier: "CellId")
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadExpenses), name: NSNotification.Name(rawValue: Constant.kInitialDataLoadedNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishChangingData), name: NSNotification.Name(rawValue: Constant.kChangeExpensesDataNotification), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //-- login page, not used
        /*
        let userName: String? = UserManager.sharedInstance.userName
        if (userName!.count == 0) {
            let storyboard: UIStoryboard = UIStoryboard.init(name: "loginRegister", bundle: nil)
            let vc: LoginRegisterViewController? = storyboard.instantiateViewController(withIdentifier: "LoginRegisterViewController") as? LoginRegisterViewController
            self.present(vc!, animated: true, completion: nil)
        }
        */
        
        self.showDate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: - IBAction
    
    @IBAction func showMoreAction(_ sender: Any) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "admin", bundle: nil)
        let vc: AdminHomeViewController? = storyboard.instantiateViewController(withIdentifier: "AdminHomeViewController") as? AdminHomeViewController
        self.navigationController!.pushViewController(vc!, animated: true)
    }
    
    @IBAction func changeDateAction(_ sender: Any) {
        
        let storyboard: UIStoryboard = UIStoryboard.init(name: "expenseHome", bundle: nil)
        self.changeDateVC = storyboard.instantiateViewController(withIdentifier: "ChangeDateViewController") as? ChangeDateViewController
        self.changeDateVC!.delegate = self
        self.changeDateVC!.currentDate = DisplayManager.sharedInstance.selectedDate
        
        self.view.addSubview(self.changeDateVC!.view)
        self.addChild(self.changeDateVC!)
    }
    
    @IBAction func addNewAction(_ sender: Any) {
        
        print("-> to add new ...")
        let storyboard: UIStoryboard = UIStoryboard(name: "expenseHome", bundle: nil)
        self.editExpenseVC = storyboard.instantiateViewController(withIdentifier: "EditExpensesViewController") as? EditExpensesViewController
        self.editExpenseVC!.selectedModel = nil
        self.editExpenseVC!.parentVC = self
        self.navigationController!.pushViewController(self.editExpenseVC!, animated: true)
    }
    
    //MARK: - titles data
    
    func showDate() {
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd, EEE"
        self.displayDateLabel.text = df.string(from: DisplayManager.sharedInstance.selectedDate)
    }
    
    func showExpensesTotal() {
        
        var totalAmount: Float = 0
        for item in DataManager.sharedInstance.expensesData! {
            totalAmount += item.amount
        }
        self.displayAmountLabel.text = String(format: "Total($): %0.2f", totalAmount)
    }
    
    //MARK: - notification
    
    @objc func reloadExpenses() {
        
        DispatchQueue.main.async {
            self.rowsArray = DataManager.sharedInstance.expensesData
            if self.rowsArray == nil {
                self.rowsArray = []
            }
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.showExpensesTotal()
        }
    }
    
    @objc func finishChangingData() {
        
        DispatchQueue.main.async {
            self.rowsArray = DataManager.sharedInstance.expensesData
            if self.rowsArray == nil {
                self.rowsArray = []
            }
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.showExpensesTotal()
        }
    }
    
    //MARK: - change date delegate
    
    func cancelSelectDate() {
        self.closeChangeDateView()
    }
    
    func selectNewDate(date: Date) {
        DisplayManager.sharedInstance.selectedDate = date
        self.closeChangeDateView()
        
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let dateString: String = df.string(from: DisplayManager.sharedInstance.selectedDate)
        self.activityIndicator.startAnimating()
        DataManager.sharedInstance.expensesOnDate(date: dateString)
        self.showDate()
        
        //-- printing
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currenteDateString = df.string(from: DisplayManager.sharedInstance.selectedDate)
        print("- ")
        print("- after change, date/time = '\(currenteDateString)' ")
        print("- ")
    }
    
    func closeChangeDateView() {
        self.changeDateVC!.view.removeFromSuperview()
        self.changeDateVC!.removeFromParent()
        self.changeDateVC = nil
    }
    
    //MARK: - table view source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rowsArray!.count as Int
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ExpenseCell? = self.tableView.dequeueReusableCell(withIdentifier: "CellId") as? ExpenseCell
        
        let data: ExpenseModel = self.rowsArray![indexPath.row]
        cell!.cellVendorLabel.text = data.vendor!
        cell!.cellPaymentLabel.text = data.payment!
        cell!.cellNotesLabel.text = data.note!
        cell!.cellTimeLabel.text = String(format: "( time: %@ )", data.time!)
        
        let amountText = String(format: "%0.2f", data.amount)
        cell!.cellAmountLabel.text = amountText
        
        return cell!
    }
    
    //MARK: - table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        //-- show selection
        self.selectedExpenseItem = self.rowsArray![indexPath.row]
        self.showOptionsForSelectedItem()
    }
    
    //MARK: - edit & delete
    
    func showProcessIndicator() {
        self.activityIndicator.startAnimating()
    }
    
    func showOptionsForSelectedItem() {
        
        let alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let deleteAction: UIAlertAction = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default) { (action) in
            print("-> to delete, ID = \(self.selectedExpenseItem!.expId) ...")
            self.deleteSelectedItem()
        }
        
        let editAction: UIAlertAction = UIAlertAction(title: "Edit", style: UIAlertAction.Style.default) { (action) in
            print("-> to update, ID = \(self.selectedExpenseItem!.expId) ...")
            let storyboard: UIStoryboard = UIStoryboard(name: "expenseHome", bundle: nil)
            self.editExpenseVC = storyboard.instantiateViewController(withIdentifier: "EditExpensesViewController") as? EditExpensesViewController
            self.editExpenseVC!.selectedModel = self.selectedExpenseItem
            self.editExpenseVC!.parentVC = self
            self.navigationController!.pushViewController(self.editExpenseVC!, animated: true)
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(deleteAction)
        alert.addAction(editAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteSelectedItem() {
        
        let title: String = String(format: "Are you sure you want to delete this record? \n%@ ($%0.2f)", self.selectedExpenseItem!.vendor!, self.selectedExpenseItem!.amount)
        
        let alert: UIAlertController = UIAlertController(title: title, message: nil, preferredStyle: UIAlertController.Style.alert)
        
        let okAction: UIAlertAction = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default) { (action) in
            print("-> to delete, ID = \(self.selectedExpenseItem!.expId) ...")
            DataManager.sharedInstance.changeExpenseData(data: self.selectedExpenseItem!, isForEdit: false)
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)

        self.present(alert, animated: true, completion: nil)
    }
    
}
