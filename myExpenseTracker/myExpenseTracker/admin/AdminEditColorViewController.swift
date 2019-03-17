//
//  AdminEditColorViewController.swift
//  MyExps
//
//  Created by Johnson Liu on 1/21/19.
//  Copyright © 2019 Home Office. All rights reserved.
//

import UIKit


protocol AdminEditColorViewControllerDelegate: AnyObject {
    
    func didSelectColor(colorTypeIndex: Int, colorIndex: Int, color: UIColor)
}


class AdminEditColorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: AdminEditColorViewControllerDelegate?
    
    var colorsList: [[String: AnyObject]] = []
    
    var colorTypeIndex: Int = 0
    var selectedColorIndex: Int = 0
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.colorsList = DisplayManager.sharedInstance.colorsData
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch colorTypeIndex {
        case Constant.kPaymentNameColorIndex:
            self.selectedColorIndex = DisplayManager.sharedInstance.paymentNameColorCode
            break
        case Constant.kPaymentIdColorIndex:
            self.selectedColorIndex = DisplayManager.sharedInstance.paymentIdColorCode
            break
        case Constant.kVendorNameColorIndex:
            self.selectedColorIndex = DisplayManager.sharedInstance.vendorNameColorCode
            break
        case Constant.kVendorIdColorIndex:
            self.selectedColorIndex = DisplayManager.sharedInstance.vendorIdColorCode
            break
        default:break
        }
        
    }
    
    //MARK: - IB action
    
    @IBAction func gobackAction(_ sender: Any) {
        self.closePage()
    }
    
    //MARK: - table view source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.colorsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell? = self.tableView.dequeueReusableCell(withIdentifier: "CellId")
        
        let colorData: [String: AnyObject] = DisplayManager.sharedInstance.colorsData[indexPath.row]
        let name: String = colorData["name"] as! String
        let color: UIColor = colorData["color"] as! UIColor
        
        cell!.backgroundColor = UIColor.gray
        
        if name == "Clear" {
            cell!.textLabel!.text = String(format: "(%@)", name)
            cell!.textLabel!.textColor = UIColor.black
        }
        else {
            cell!.textLabel!.text = name
            cell!.textLabel!.textColor = color
        }
        
        if self.selectedColorIndex == indexPath.row {
            cell!.accessoryType = UITableViewCell.AccessoryType.checkmark
        }
        else {
            cell!.accessoryType = UITableViewCell.AccessoryType.none
        }
        
        return cell!
    }
    
    //MARK: - table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        //-- save data here
        let index: Int = indexPath.row as Int
        let colorData: [String: AnyObject] = DisplayManager.sharedInstance.colorsData[indexPath.row]
        let color: UIColor = colorData["color"] as! UIColor
        
        self.delegate!.didSelectColor(colorTypeIndex: self.colorTypeIndex, colorIndex: index, color: color)
        self.closePage()
    }
    
    //MARK: - close page
    
    func closePage() {
        self.navigationController!.popViewController(animated: true)
    }
    
}
