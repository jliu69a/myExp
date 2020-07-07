//
//  ListsCell.swift
//  MyTests
//
//  Created by Johnson Liu on 3/24/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit


protocol ListsCellDelegate: AnyObject {
    
    func didSelectCellAtIndex(index: Int)
}


class ListsCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var indicatorLabel: UILabel!
    
    weak var delegate: ListsCellDelegate?
    
    var currentDay: String = ""
    var index: Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func showDate(date: String, week: String, isEmpty: Bool, isToday: Bool) {
        self.dateLabel.text = date
        self.weekLabel.text = week
        
        if isToday == true {
            self.dateLabel.textColor = UIColor.red
            self.indicatorLabel.backgroundColor = isEmpty ? UIColor.darkGray : UIColor.green
        }
        else {
            self.dateLabel.textColor = isEmpty ? UIColor.blue : UIColor.green
        }
    }
    
    func showIndicator(isSelected: Bool) {
        self.indicatorLabel.isHidden = isSelected ? false : true
    }
    
    func showBorder() {
        self.dateLabel.layer.borderColor = UIColor.red.cgColor
        self.dateLabel.layer.borderWidth = 0.5
    }
    
    @IBAction func selectAction(_ sender: Any) {
        self.delegate?.didSelectCellAtIndex(index: index)
    }
    
}
