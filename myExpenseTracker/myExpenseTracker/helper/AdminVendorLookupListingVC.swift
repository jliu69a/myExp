//
//  AdminVendorLookupListingVC.swift
//  myExpenseTracker
//
//  Created by Johnson Liu on 8/6/19.
//  Copyright © 2019 Home Office. All rights reserved.
//

import UIKit


protocol AdminVendorLookupListingVCDelegate: AnyObject {
    
    func didSelectVendor(item: PAndVModel)
}


class AdminVendorLookupListingVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    
    weak var delegate: AdminVendorLookupListingVCDelegate?
    weak var parentVC: AdminVendorLookupViewController? = nil

    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableview.register(UINib(nibName: "PAndVCell", bundle: nil), forCellReuseIdentifier: "CellId")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableview.layer.borderColor = UIColor.black.cgColor
        self.tableview.layer.borderWidth = 0.5
        
        self.cancelButton.layer.cornerRadius = 5
    }
    
    //MARK: - IB action
    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    //MARK: - table view source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return DataManager.sharedInstance.vendorTop10GroupKeys!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let key: String = DataManager.sharedInstance.vendorTop10GroupKeys![section]
        var list: [PAndVModel]? = DataManager.sharedInstance.vendorGroups![key]
        if list == nil {
            list = []
        }
        return list!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var model: PAndVModel? = nil
        
        let key: String = DataManager.sharedInstance.vendorTop10GroupKeys![indexPath.section]
        var list: [PAndVModel]? = DataManager.sharedInstance.vendorGroups![key]
        if list == nil {
            list = []
        }
        model = list![indexPath.row]

        let cell: PAndVCell? = self.tableview.dequeueReusableCell(withIdentifier: "CellId") as? PAndVCell
        
        cell!.nameLabel.text = model!.pvName
        cell!.idLabel.text = model!.pvId
        
        var nameColorCode: Int = -1
        var idColorCode: Int = -1
        
        nameColorCode = DisplayManager.sharedInstance.vendorNameColorCode
        idColorCode = DisplayManager.sharedInstance.vendorIdColorCode

        let nameData: [String: AnyObject] = DisplayManager.sharedInstance.colorsData[nameColorCode]
        cell!.nameLabel.textColor = nameData["color"] as? UIColor
        
        let idData: [String: AnyObject] = DisplayManager.sharedInstance.colorsData[idColorCode]
        cell!.idLabel.textColor = idData["color"] as? UIColor
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return DataManager.sharedInstance.vendorTop10GroupKeys![section]
    }
    
    //MARK: - table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableview.deselectRow(at: indexPath, animated: true)
        
        var model: PAndVModel? = nil
        let key: String = DataManager.sharedInstance.vendorTop10GroupKeys![indexPath.section]
        var list: [PAndVModel]? = DataManager.sharedInstance.vendorGroups![key]
        if list == nil {
            list = []
        }
        model = list![indexPath.row]

        self.delegate!.didSelectVendor(item: model!)
        self.navigationController!.popViewController(animated: true)
    }

    
    
    
    
}
