//
//  PaymentsVendorsViewController.swift
//  MyExps
//
//  Created by Johnson Liu on 1/19/19.
//  Copyright © 2019 Home Office. All rights reserved.
//

import UIKit


protocol PaymentsVendorsViewControllerDelegate: AnyObject {
    
    func didSelectItem(item: PAndVModel, isForPayments: Bool)
}


class PaymentsVendorsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var rowsList: [PAndVModel]? = []
    var isForPayments: Bool = true
    
    weak var delegate: PaymentsVendorsViewControllerDelegate?

    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "PAndVCell", bundle: nil), forCellReuseIdentifier: "CellId")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.isForPayments {
            self.titleLabel.text = "Payment"
        }
        else {
            self.titleLabel.text = "Vendor"
        }
        
        self.tableView.layer.borderColor = UIColor.black.cgColor
        self.tableView.layer.borderWidth = 0.5
        
        self.showData()
    }
    
    //MARK: - data
    
    func showData() {
        
        if self.isForPayments {
            self.rowsList = DataManager.sharedInstance.paymentsData!
        }
        else {
            self.rowsList = DataManager.sharedInstance.vendorsData!
        }
        self.tableView.reloadData()
    }
    
    //MARK: - IB action
    
    @IBAction func gobackAction(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    //MARK: - table view source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if self.isForPayments {
            return 1
        }
        else {
            return DataManager.sharedInstance.vendorTop10GroupKeys!.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.isForPayments {
            return self.rowsList!.count
        }
        else {
            let key: String = DataManager.sharedInstance.vendorTop10GroupKeys![section]
            var list: [PAndVModel]? = DataManager.sharedInstance.vendorGroups![key]
            if list == nil {
                list = []
            }
            return list!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var model: PAndVModel? = nil
        
        if self.isForPayments {
            model = self.rowsList![indexPath.row]
        }
        else {
            let key: String = DataManager.sharedInstance.vendorTop10GroupKeys![indexPath.section]
            var list: [PAndVModel]? = DataManager.sharedInstance.vendorGroups![key]
            if list == nil {
                list = []
            }
            model = list![indexPath.row]
        }
        
        let cell: PAndVCell? = self.tableView.dequeueReusableCell(withIdentifier: "CellId") as? PAndVCell
        
        cell!.nameLabel.text = model!.pvName
        cell!.idLabel.text = model!.pvId
        
        var nameColorCode: Int = -1
        var idColorCode: Int = -1
        
        if self.isForPayments {
            nameColorCode = DisplayManager.sharedInstance.paymentNameColorCode
            idColorCode = DisplayManager.sharedInstance.paymentIdColorCode
        }
        else {
            nameColorCode = DisplayManager.sharedInstance.vendorNameColorCode
            idColorCode = DisplayManager.sharedInstance.vendorIdColorCode
        }
        
        let nameData: [String: AnyObject] = DisplayManager.sharedInstance.colorsData[nameColorCode]
        cell!.nameLabel.textColor = nameData["color"] as? UIColor
        
        let idData: [String: AnyObject] = DisplayManager.sharedInstance.colorsData[idColorCode]
        cell!.idLabel.textColor = idData["color"] as? UIColor
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if self.isForPayments {
            return 0
        }
        else {
            //-- for vendors
            if section == 0 {
                let key: String = DataManager.sharedInstance.vendorTop10GroupKeys![section]
                let list: [PAndVModel]? = DataManager.sharedInstance.vendorGroups![key]
                
                //-- check for Top-10 listing
                if list != nil && list!.count > 0 {
                    return 30
                }
                else {
                    return 0
                }
            }
            else {
                return 30
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if self.isForPayments {
            return nil
        }
        else {
            return DataManager.sharedInstance.vendorTop10GroupKeys![section]
        }
    }
    
    //MARK: - table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        var model: PAndVModel? = nil
        if self.isForPayments {
            model = self.rowsList![indexPath.row]
        }
        else {
            let key: String = DataManager.sharedInstance.vendorTop10GroupKeys![indexPath.section]
            var list: [PAndVModel]? = DataManager.sharedInstance.vendorGroups![key]
            if list == nil {
                list = []
            }
            model = list![indexPath.row]
        }
        
        self.delegate!.didSelectItem(item: model!, isForPayments: self.isForPayments)
        self.navigationController!.popViewController(animated: true)
    }
}

