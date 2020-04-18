//
//  LookupListsViewController.swift
//  myExpenseTracker
//
//  Created by Johnson Liu on 4/18/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit

class LookupListsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var rowsList: [String] = []
    
    var dateDisplayText: String = ""
    
    var expensesList: [ExpenseModel] = []
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.dateLabel.text = self.dateDisplayText
        
        self.tableView.layer.borderColor = UIColor.black.cgColor
        self.tableView.layer.borderWidth = 0.5
        
    }
    
    //MARK: - local functions
    
    func lookupData(data: [ExpenseModel], dateString: String) {
        self.expensesList = data
        self.dateDisplayText = dateString
    }
    
    func showBorder() {
        //self.tableView.layer.borderColor = UIColor.black.cgColor
        //self.tableView.layer.borderWidth = 0.5
    }
    
    //MARK: - table view source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.expensesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell? = self.tableView.dequeueReusableCell(withIdentifier: "CellId")
        
        let model: ExpenseModel = self.expensesList[indexPath.row]
        let displayText: String = String(format: "%@: %0.2f", model.vendor!, model.amount)
        
        cell!.textLabel!.text = displayText
        cell!.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        return cell!
    }
    
    //MARK: - table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
