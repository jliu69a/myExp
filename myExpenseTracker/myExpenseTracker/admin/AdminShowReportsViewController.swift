//
//  AdminShowReportsViewController.swift
//  MyExps
//
//  Created by Johnson Liu on 1/22/19.
//  Copyright © 2019 Home Office. All rights reserved.
//

import UIKit

class AdminShowReportsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var titleBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tabeView: UITableView!
    
    var paymentsList: [ReportModel] = []
    var vendorsList: [ReportModel] = []
    
    let formatter = NumberFormatter()

    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.paymentsList = DataManager.sharedInstance.paymentReportData
        self.vendorsList = DataManager.sharedInstance.vendorReportData
        
        self.tabeView.register(UINib(nibName: "AdminReportCell", bundle: nil), forCellReuseIdentifier: "CellId")
        
        self.formatter.locale = Locale.current
        self.formatter.numberStyle = .currency

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabeView.layer.borderColor = UIColor.black.cgColor
        self.tabeView.layer.borderWidth = 0.5
        
        let df: DateFormatter = DateFormatter()
        if DataManager.sharedInstance.isReportForMonthly {
            df.dateFormat = "M/yyyy"
        }
        else {
            df.dateFormat = "yyyy"
        }
        let dateText: String = df.string(from: DataManager.sharedInstance.reportDate)
        
        let totalNumber: NSNumber = NSNumber(value: DataManager.sharedInstance.totalReportValue)
        let totalText = self.formatter.string(from: totalNumber)
        
        self.dateLabel.text = String(format: "for %@,  total = %@", dateText, totalText!)
    }
    
    //MARK: - IBAction
    
    @IBAction func gobackAction(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    //MARK: - table view source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return self.paymentsList.count
        }
        else {
            return self.vendorsList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: AdminReportCell? = self.tabeView.dequeueReusableCell(withIdentifier: "CellId") as? AdminReportCell
        var model: ReportModel? = nil
        
        if indexPath.section == 0 {
            //-- payments
            model = self.paymentsList[indexPath.row]
        }
        else {
            //-- vendors
            model = self.vendorsList[indexPath.row]
        }
        
        let itemValue:Float = Float(model!.value!)!
        let itemNumber: NSNumber = NSNumber(value: itemValue)
        
        cell!.nameLabel.text = model!.name!
        cell!.valueLabel.text = self.formatter.string(from: itemNumber)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return "Payments"
        }
        else {
            return "Vendors"
        }
    }
    
    //MARK: - table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tabeView.deselectRow(at: indexPath, animated: true)
    }
}
