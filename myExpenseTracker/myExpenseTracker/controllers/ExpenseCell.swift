//
//  ExpenseCell.swift
//  MyExps
//
//  Created by Johnson Liu on 1/14/19.
//  Copyright © 2019 Home Office. All rights reserved.
//

import UIKit

class ExpenseCell: UITableViewCell {
    
    
    @IBOutlet weak var cellVendorLabel: UILabel!
    @IBOutlet weak var cellNotesLabel: UILabel!
    @IBOutlet weak var cellAmountLabel: UILabel!
    @IBOutlet weak var cellPaymentLabel: UILabel!
    @IBOutlet weak var cellTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func displayModelData(data: ExpenseModel) {
        
        self.cellVendorLabel.text = data.vendor!
        self.cellPaymentLabel.text = data.payment!
        self.cellNotesLabel.text = data.note!
        self.cellTimeLabel.text = String(format: "( time: %@ )", data.time!)
        
        let amountText = String(format: "%0.2f", data.amount)
        self.cellAmountLabel.text = amountText
    }
    
}
