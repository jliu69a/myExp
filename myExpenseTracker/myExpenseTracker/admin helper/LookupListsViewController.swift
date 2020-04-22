//
//  LookupListsViewController.swift
//  myExpenseTracker
//
//  Created by Johnson Liu on 4/18/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit


protocol LookupListsViewControllerDelegate: AnyObject {
    
    func didSelectExpenseItem(item: ExpenseModel)
}


class LookupListsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: LookupListsViewControllerDelegate?
    
    var rowsList: [String] = []
    var dateDisplayText: String = ""
    var expensesList: [ExpenseModel] = []
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
        self.tableView.register(UINib(nibName: "ExpenseCell", bundle: nil), forCellReuseIdentifier: "CellId")
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
    
    //MARK: - table view source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.expensesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ExpenseCell? = self.tableView.dequeueReusableCell(withIdentifier: "CellId") as? ExpenseCell
        
        let data: ExpenseModel = self.expensesList[indexPath.row]
        cell!.displayModelData(data: data)
        
        return cell!
    }
    
    //MARK: - table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    
}
