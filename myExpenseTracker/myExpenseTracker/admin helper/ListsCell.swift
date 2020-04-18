//
//  ListsCell.swift
//  MyTests
//
//  Created by Johnson Liu on 3/24/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit

class ListsCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var indicatorLabel: UILabel!
    
    weak var parentVC: AdminExpenseDetailsViewController? = nil
    
    var index: Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func showDate(date: String) {
        self.dateLabel.text = date
    }
    
    func showIndicator(isSelected: Bool) {
        self.indicatorLabel.isHidden = isSelected ? false : true
    }
    
    func showBorder() {
        self.dateLabel.layer.borderColor = UIColor.red.cgColor
        self.dateLabel.layer.borderWidth = 0.5
    }
    
    @IBAction func selectAction(_ sender: Any) {
        self.parentVC!.didSelectCellAtIndex(index: index)
    }
    
}
