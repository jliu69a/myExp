//
//  PAndVCell.swift
//  MyExps
//
//  Created by Johnson Liu on 1/19/19.
//  Copyright © 2019 Home Office. All rights reserved.
//

import UIKit

class PAndVCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
