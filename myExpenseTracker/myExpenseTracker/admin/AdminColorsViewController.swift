//
//  AdminColorsViewController.swift
//  MyExps
//
//  Created by Johnson Liu on 1/21/19.
//  Copyright © 2019 Home Office. All rights reserved.
//

import UIKit

class AdminColorsViewController: UIViewController, AdminEditColorViewControllerDelegate {
    
    @IBOutlet weak var paymentNameView: UIView!
    @IBOutlet weak var paymentIdView: UIView!
    @IBOutlet weak var vendorNameView: UIView!
    @IBOutlet weak var vendorIdView: UIView!
    
    @IBOutlet weak var paymentNameColorLabel: UILabel!
    @IBOutlet weak var paymentIdColorLabel: UILabel!
    @IBOutlet weak var vendorNameColorLabel: UILabel!
    @IBOutlet weak var vendorIdColorLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let paymentNameData: [String: AnyObject] = DisplayManager.sharedInstance.colorsData[DisplayManager.sharedInstance.paymentNameColorCode]
        self.paymentNameColorLabel.backgroundColor = paymentNameData["color"] as? UIColor
        
        let paymentIdData: [String: AnyObject] = DisplayManager.sharedInstance.colorsData[DisplayManager.sharedInstance.paymentIdColorCode]
        self.paymentIdColorLabel.backgroundColor = paymentIdData["color"] as? UIColor
        
        let vendorNameData: [String: AnyObject] = DisplayManager.sharedInstance.colorsData[DisplayManager.sharedInstance.vendorNameColorCode]
        self.vendorNameColorLabel.backgroundColor = vendorNameData["color"] as? UIColor
        
        let vendorIdData: [String: AnyObject] = DisplayManager.sharedInstance.colorsData[DisplayManager.sharedInstance.vendorIdColorCode]
        self.vendorIdColorLabel.backgroundColor = vendorIdData["color"] as? UIColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.paymentNameColorLabel.layer.borderColor = UIColor.black.cgColor
        self.paymentNameColorLabel.layer.borderWidth = 0.5
        
        self.paymentIdColorLabel.layer.borderColor = UIColor.black.cgColor
        self.paymentIdColorLabel.layer.borderWidth = 0.5
        
        self.vendorNameColorLabel.layer.borderColor = UIColor.black.cgColor
        self.vendorNameColorLabel.layer.borderWidth = 0.5
        
        self.vendorIdColorLabel.layer.borderColor = UIColor.black.cgColor
        self.vendorIdColorLabel.layer.borderWidth = 0.5
        
        self.saveButton.layer.cornerRadius = 5
    }
    
    //MARK: - IB actions
    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
        var indexText: String = ""
        
        indexText = String(format: "%d", DisplayManager.sharedInstance.paymentNameColorCode)
        UserDefaults.standard.set(indexText as Any, forKey: Constant.kUserDefaultPaymentNameColorCodeKey)
        
        indexText = String(format: "%d", DisplayManager.sharedInstance.paymentIdColorCode)
        UserDefaults.standard.set(indexText as Any, forKey: Constant.kUserDefaultPaymentIdColorCodeKey)
        
        indexText = String(format: "%d", DisplayManager.sharedInstance.vendorNameColorCode)
        UserDefaults.standard.set(indexText as Any, forKey: Constant.kUserDefaultVendorNameColorCodeKey)

        indexText = String(format: "%d", DisplayManager.sharedInstance.vendorIdColorCode)
        UserDefaults.standard.set(indexText as Any, forKey: Constant.kUserDefaultVendortIdColorCodeKey)
        
        self.navigationController!.popViewController(animated: true)
    }
    
    //MARK: - IB actions, color change
    
    @IBAction func changePaymentNameColorAction(_ sender: Any) {
        self.selectColor(typeIndex: Constant.kPaymentNameColorIndex)
    }
    
    @IBAction func changePaymentIdColorAction(_ sender: Any) {
        self.selectColor(typeIndex: Constant.kPaymentIdColorIndex)
    }
    
    @IBAction func changeVendorNameColorAction(_ sender: Any) {
        self.selectColor(typeIndex: Constant.kVendorNameColorIndex)
    }
    
    @IBAction func changeVendorIdColorAction(_ sender: Any) {
        self.selectColor(typeIndex: Constant.kVendorIdColorIndex)
    }
    
    //MARK: - select color
    
    func selectColor(typeIndex: Int) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "admin", bundle: nil)
        let vc: AdminEditColorViewController? = storyboard.instantiateViewController(withIdentifier: "AdminEditColorViewController") as? AdminEditColorViewController
        vc!.delegate = self
        vc!.colorTypeIndex = typeIndex
        self.navigationController!.pushViewController(vc!, animated: true)
    }
    
    //MARK: - select color delegate
    
    func didSelectColor(colorTypeIndex: Int, colorIndex: Int, color: UIColor) {
        
        switch colorTypeIndex {
        case Constant.kPaymentNameColorIndex:
            DisplayManager.sharedInstance.paymentNameColorCode = colorIndex
            self.paymentNameColorLabel.backgroundColor = color
            break
        case Constant.kPaymentIdColorIndex:
            DisplayManager.sharedInstance.paymentIdColorCode = colorIndex
            self.paymentIdColorLabel.backgroundColor = color
            break
        case Constant.kVendorNameColorIndex:
            DisplayManager.sharedInstance.vendorNameColorCode = colorIndex
            self.vendorNameColorLabel.backgroundColor = color
            break
        case Constant.kVendorIdColorIndex:
            DisplayManager.sharedInstance.vendorIdColorCode = colorIndex
            self.vendorIdColorLabel.backgroundColor = color
            break
        default:break
        }
    }
}
