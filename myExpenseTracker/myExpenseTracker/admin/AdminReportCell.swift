//
//  AdminReportCell.swift
//  MyExps
//
//  Created by Johnson Liu on 1/28/19.
//  Copyright © 2019 Home Office. All rights reserved.
//

import UIKit

class AdminReportCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
