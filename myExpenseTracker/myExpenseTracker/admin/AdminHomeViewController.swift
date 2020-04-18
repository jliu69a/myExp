//
//  AdminHomeViewController.swift
//  MyExps
//
//  Created by Johnson Liu on 1/21/19.
//  Copyright © 2019 Home Office. All rights reserved.
//

import UIKit
import MessageUI


class AdminHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var selectDateVC: AdminReportDateViewController? = nil
    var reportDate: Date = Date()
    
    let titlesList: [String] = ["Expense", "Misc"]
    let coreList: [String] = ["Change Color", "Edit Payments", "Edit Vendors", "Expense Report", "Export Data"]  //5
    let miscList: [String] = ["Look Up Vendor", "Look Up Expenses", "Location Check", "Device Info"]
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "AdminListCell", bundle: nil), forCellReuseIdentifier: "CellId")
        
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishReport), name: NSNotification.Name(rawValue: Constant.kPaymentsAndVendorsReportNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishDataExport), name: NSNotification.Name(rawValue: Constant.kExportMonthAndYearDataNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didGenerateExpensesLookupData), name: NSNotification.Name(rawValue: Constant.kCreateLookupExpensesDataNotificatioon), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.activityIndicator.stopAnimating()
        
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        self.versionLabel.text = String(format: "Version: %@", appVersion!)
        
        self.tableView.layer.borderColor = UIColor.black.cgColor
        self.tableView.layer.borderWidth = 0.5
    }
    
    //MARK: - IB actions
    
    @IBAction func gobackAction(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    //MARK: - table view source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.titlesList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return coreList.count
        }
        else {
            return miscList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: AdminListCell? = self.tableView.dequeueReusableCell(withIdentifier: "CellId") as? AdminListCell
        if indexPath.section == 0 {
            cell!.nameLabel.text = self.coreList[indexPath.row]
        }
        else {
            cell!.nameLabel.text = self.miscList[indexPath.row]
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.titlesList[section]
    }
    
    //MARK: - table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                self.selectColor()
                break
            case 1:
                //-- edit payments
                self.showPaymentAndVendorPage(isForVendor: false)
                break
            case 2:
                //-- edit vendors
                self.showPaymentAndVendorPage(isForVendor: true)
                break
            case 3:
                //-- report
                self.selectExpenseReportsType()
                break
            case 4:
                //-- export data
                self.selectDataExportType()
                break
            default:break
            }
        }
        else {
            switch indexPath.row {
            case 0:
                //-- lookup vendor
                self.vendorLookup()
                break
            case 1:
                //-- lookup expenses
                self.dataForExpensesLookup()
                break
            case 2:
                //-- check location
                self.checkLocations()
                break
            case 3:
                //-- check device
                self.checkDeviceInfo()
                break
            default:break
            }
        }
    }
    
    //MARK: - select color
    
    func selectColor() {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "admin", bundle: nil)
        let vc: AdminColorsViewController? = storyboard.instantiateViewController(withIdentifier: "AdminColorsViewController") as? AdminColorsViewController
        self.navigationController!.pushViewController(vc!, animated: true)
    }
    
    //MARK: - payment & vendor
    
    func showPaymentAndVendorPage(isForVendor: Bool) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "admin", bundle: nil)
        let vc: AdminPaymentsVendorsVC? = storyboard.instantiateViewController(withIdentifier: "AdminPaymentsVendorsVC") as? AdminPaymentsVendorsVC
        vc!.isForVendor = isForVendor
        self.navigationController!.pushViewController(vc!, animated: true)
    }
    
    //MARK: - reports
    
    func selectExpenseReportsType() {
        
        let alert: UIAlertController = UIAlertController(title: "Reports", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let forMonthAction: UIAlertAction = UIAlertAction(title: "For Monthly", style: UIAlertAction.Style.default) { (action) in
            self.showDateSelection(isForMonthly: true, isForDataExport: false)
        }
        alert.addAction(forMonthAction)
        
        let forYearAction: UIAlertAction = UIAlertAction(title: "For Annually", style: UIAlertAction.Style.default) { (action) in
            self.showDateSelection(isForMonthly: false, isForDataExport: false)
        }
        alert.addAction(forYearAction)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
            //-- do nothing
        }
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showReports() {
        self.closeDateSelection()

        let storyboard: UIStoryboard = UIStoryboard(name: "admin", bundle: nil)
        let vc: AdminShowReportsViewController? = storyboard.instantiateViewController(withIdentifier: "AdminShowReportsViewController") as? AdminShowReportsViewController
        self.navigationController!.pushViewController(vc!, animated: true)
    }
    
    //MARK: - export
    
    func selectDataExportType() {
        
        let alert: UIAlertController = UIAlertController(title: "Data Export", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let forMonthAction: UIAlertAction = UIAlertAction(title: "For Monthly", style: UIAlertAction.Style.default) { (action) in
            self.showDateSelection(isForMonthly: true, isForDataExport: true)
        }
        alert.addAction(forMonthAction)
        
        let forYearAction: UIAlertAction = UIAlertAction(title: "For Annually", style: UIAlertAction.Style.default) { (action) in
            self.showDateSelection(isForMonthly: false, isForDataExport: true)
        }
        alert.addAction(forYearAction)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
            //-- do nothing
        }
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showDataExport() {
        self.closeDateSelection()
        
        if DataManager.sharedInstance.exportsList == nil || DataManager.sharedInstance.exportsList!.count == 0 {
            AlertManager.showAlert(title: "Warning", message: "The export data is empty.", controller: self)
            return
        }
        
        let csvText: String = UtilsManager.sharedInstance.createCsvFromExpenseData(data: DataManager.sharedInstance.exportsList!)
        self.emailCsvFile(csvText: csvText)
    }
    
    //MARK: - email export data
    
    func emailCsvFile(csvText: String) {
        let cvsData: Data = Data(csvText.utf8)
        
        if (MFMailComposeViewController.canSendMail()) {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setToRecipients([])
            mailComposer.setSubject("my expense data")
            mailComposer.setMessageBody("in CSV format:", isHTML: true)
            mailComposer.addAttachmentData(cvsData, mimeType: "text/csv", fileName: "myExpData.csv")
            self.present(mailComposer, animated: true, completion: nil)
        }
        else {
            UtilsManager.sharedInstance.showAlertMessage(message: "", title: "Email is not supported.", controller: self)
        }
    }
    
    func mailComposeController(_ didFinishWithcontroller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - misc
    
    func vendorLookup() {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "admin", bundle: nil)
        let vc: AdminVendorLookupViewController? = storyboard.instantiateViewController(withIdentifier: "AdminVendorLookupViewController") as? AdminVendorLookupViewController
        self.navigationController!.pushViewController(vc!, animated: true)
    }
    
    func dataForExpensesLookup() {
        self.activityIndicator.startAnimating()
        
        DL_DataManager.sharedInstance.generateAllMonths()
        DL_DataManager.sharedInstance.generateAllYears()
        print("> ")
        print("> all months : \(DL_DataManager.sharedInstance.allMonthsList) ")
        print("> all years  : \(DL_DataManager.sharedInstance.allYearsList) ")
        print("> ")
        
        let rightNow = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy"
        let yearText = df.string(from: rightNow)
        df.dateFormat = "MM"
        let monthText = df.string(from: rightNow)
        df.dateFormat = "yyyy-MM"
        let dateString = df.string(from: Date())
        
        let yearValue: Int = Int(yearText)!
        let monthValue: Int = Int(monthText)!
        
        DL_DataManager.sharedInstance.generateMonthsAndDaysDisplay(year: yearValue, month: monthValue)
        print("- ")
        print("- total days in month = \(DL_DataManager.sharedInstance.totalDaysInMonth) ")
        print("- display list : \(DL_DataManager.sharedInstance.monthDayDisplayList) ")
        print("- ")
        
        DL_DataManager.sharedInstance.lookupInitialData()
        print("> ")
        print("> all expenses items : \(DL_DataManager.sharedInstance.lookupExpenseDict) ")
        print("> ")
        
        DL_DataManager.sharedInstance.lookupExpensesByDate(date: dateString)
    }
    
    func expensesLookup() {
        self.activityIndicator.stopAnimating()
        
        let storyboard: UIStoryboard = UIStoryboard(name: "admin", bundle: nil)
        let vc: AdminExpensesLookupViewController? = storyboard.instantiateViewController(withIdentifier: "AdminExpensesLookupViewController") as? AdminExpensesLookupViewController
        self.navigationController!.pushViewController(vc!, animated: true)
    }
    
    func checkLocations() {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "admin", bundle: nil)
        let vc: AdminLocationChecksViewController? = storyboard.instantiateViewController(withIdentifier: "AdminLocationChecksViewController") as? AdminLocationChecksViewController
        self.navigationController!.pushViewController(vc!, animated: true)
    }
    
    func checkDeviceInfo() {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "admin", bundle: nil)
        let vc: AdminDeviceInfoViewController? = storyboard.instantiateViewController(withIdentifier: "AdminDeviceInfoViewController") as? AdminDeviceInfoViewController
        self.navigationController!.pushViewController(vc!, animated: true)
    }
    
    //MARK: - notification
    
    @objc func didFinishReport() {
        
        DispatchQueue.main.async {
            self.showReports()
        }
    }
    
    @objc func didFinishDataExport() {
        
        DispatchQueue.main.async {
            self.showDataExport()
        }
    }
    
    @objc func didGenerateExpensesLookupData() {
        
        DispatchQueue.main.async {
            self.expensesLookup()
        }
    }
    
    //MARK: - date selection
    
    func showDateSelection(isForMonthly: Bool, isForDataExport: Bool) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "admin", bundle: nil)
        self.selectDateVC = storyboard.instantiateViewController(withIdentifier: "AdminReportDateViewController") as? AdminReportDateViewController
        self.selectDateVC!.parentVC = self
        self.selectDateVC!.isForMonthly = isForMonthly
        self.selectDateVC!.isForDataExport = isForDataExport
        
        self.view.addSubview(self.selectDateVC!.view)
        self.addChild(self.selectDateVC!)
    }
    
    func closeDateSelection() {
        
        self.selectDateVC!.view.removeFromSuperview()
        self.selectDateVC!.removeFromParent()
        self.selectDateVC = nil
    }
}
