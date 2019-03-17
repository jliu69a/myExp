//
//  AdminDeviceInfoViewController.swift
//  MyExps
//
//  Created by Johnson Liu on 2/14/19.
//  Copyright © 2019 Home Office. All rights reserved.
//

import UIKit


class AdminDeviceInfoViewController: UIViewController {
    
    @IBOutlet weak var deviceInfoTextView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var batteryLevel: Float {
        return UIDevice.current.batteryLevel
    }
    
    var batteryState: UIDevice.BatteryState {
        return UIDevice.current.batteryState
    }
    
    var levelTitle: String = ""
    var stateTitle: String = ""
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        self.activityIndicator.startAnimating()
        
        NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelDidChange), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(batteryStateDidChange), name: UIDevice.batteryStateDidChangeNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.deviceInfoTextView.layer.borderColor = UIColor.black.cgColor
        self.deviceInfoTextView.layer.borderWidth = 0.5
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let now: String = self.rightNow()
        self.levelTitle = String(format: "Battery Level, initial: %@", now)
        self.stateTitle = String(format: "Battery State, initial: %@", now);
        self.printOnScreen()
    }
    
    func rightNow() -> String {
        
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return df.string(from: Date())
    }
    
    //MARK: - IB action
    
    @IBAction func gobackAction(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func testLinkAction(_ sender: Any) {
        let theUrl:URL? = URL(string: "http://www.google.com")
        UIApplication.shared.openURL(theUrl!)
    }
    
    //MARK: - notification
    
    @objc func batteryLevelDidChange(_ notification: Notification) {
        
        let now: String = self.rightNow()
        self.levelTitle = String(format: "Battery Level, updated: %@", now)
        self.printOnScreen()
    }
    
    @objc func batteryStateDidChange(_ notification: Notification) {
        
        let now: String = self.rightNow()
        self.stateTitle = String(format: "Battery State, update: %@", now);
        self.printOnScreen()
    }
    
    //MARK: - printing
    
    func printOnScreen() {
        
        var detailsText: String = "\n\n"
        
        detailsText = detailsText + self.levelTitle + "\n\n"
        
        let level: String = String(format: "battery: level = %0.0f%%", (self.batteryLevel * 100.0))
        detailsText = detailsText + level + "\n\n\n\n"
        
        detailsText = detailsText + self.stateTitle + "\n\n"
        
        var state: String = "n/a"
        switch self.batteryState {
        case .unplugged:
            state = "battery: is unplugged"
        case .unknown:
            state = "battery: not charging"
        case .charging:
            state = "battery: charging"
        case .full:
            state = "battery: is full"
        }
        detailsText = detailsText + state + "\n\n"

        self.activityIndicator.stopAnimating()
        self.deviceInfoTextView.text = detailsText
    }
    
}
