//
//  AdminExpenseDetailsViewController.swift
//  myExpenseTracker
//
//  Created by Johnson Liu on 4/18/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit

class AdminExpenseDetailsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, LookupListsViewControllerDelegate {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var topCollectionView: UICollectionView!
    
    var myCollectionView: UICollectionView? = nil
    
    var maxSize: Int = 0
    var viewsList: [LookupListsViewController] = []
    
    var bottomSpace: CGFloat = 0
    
    
    //MARL: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.maxSize = DL_DataManager.sharedInstance.totalDaysInMonth
        self.createVC()
        
        //-- check device type
        let deviceType = UIDevice().type
        let displayDeviceType = "\(deviceType)"
        
        if displayDeviceType.contains("iPhoneX") || displayDeviceType.contains("iPhone11") {
            self.bottomSpace = DL_DataManager.sharedInstance.xSeriesSpace
        }
        else {
            self.bottomSpace = DL_DataManager.sharedInstance.notXSeriesSpace
        }
        print("-> device type = \(displayDeviceType), bottom space = \(self.bottomSpace)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.topCollectionView.register(UINib(nibName: "ListsCell", bundle: nil), forCellWithReuseIdentifier: "TopCellId")
        
        //-- create main collection view
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (width), height: (height))
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        self.myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        self.myCollectionView!.dataSource = self
        self.myCollectionView!.delegate = self
        self.myCollectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CellId")
        self.myCollectionView!.backgroundColor = UIColor.white
        self.myCollectionView!.isPagingEnabled = true
        self.myCollectionView!.tag = 2
        
        self.mainView.addSubview(self.myCollectionView!)
        
        self.myCollectionView!.frame = CGRect(x: 0, y: 0, width: width, height: height)
    }
    
    
    //MARK: - IB actions
    
    @IBAction func gobackAction(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    //MARK: - collection view source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.maxSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 1 {
            
            let cell:ListsCell? = self.topCollectionView.dequeueReusableCell(withReuseIdentifier: "TopCellId", for: indexPath) as? ListsCell
            
            let dateText = DL_DataManager.sharedInstance.monthDayDisplayList[indexPath.row]
            let data: [ExpenseModel] = DL_DataManager.sharedInstance.lookupExpenseDict[dateText] ?? []
            let isEmpty: Bool = (data.count == 0) ? true : false
            
            cell!.parentVC = self
            cell!.showDate(date: dateText, isEmpty: isEmpty)
            cell!.index = indexPath.row
            
            if indexPath.row == DL_DataManager.sharedInstance.selectedTopCollectionViewIndex {
                cell!.showIndicator(isSelected: true)
            }
            else {
                cell!.showIndicator(isSelected: false)
            }

            return cell!
        }
        else {
            let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath)
            let subVC = self.viewsList[indexPath.row]
            
            let frame = myCell.contentView.bounds
            let emptySpace: CGFloat = 88
            
            subVC.view.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: (frame.size.height - emptySpace - self.bottomSpace))
            
            
            myCell.addSubview(subVC.view)
            return myCell
        }
    }
    
    //MARK: - collection view delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if collectionView.tag == 1 {
            //
        }
        else {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView.tag == 2 {
            //-- main scroll view
            let indexValue: CGFloat = scrollView.contentOffset.x / scrollView.frame.size.width
            print("-> width = \(scrollView.frame.size.width), offset = \(scrollView.contentOffset.x), index = \(indexValue) ")
            self.displayTopScrollViewWithIndex(index: Int(indexValue), animated: true)
        }
    }
    
    func displayTopScrollViewWithIndex(index: Int, animated: Bool) {
        
        if let previousCell: ListsCell = self.topCollectionView.cellForItem(at: IndexPath(item: DL_DataManager.sharedInstance.selectedTopCollectionViewIndex, section: 0)) as? ListsCell {
            //previousCell.hideIndicator()
            previousCell.showIndicator(isSelected: false)
        }
        
        DL_DataManager.sharedInstance.selectedTopCollectionViewIndex = index
        if let currentCell: ListsCell = self.topCollectionView.cellForItem(at: IndexPath(item: DL_DataManager.sharedInstance.selectedTopCollectionViewIndex, section: 0)) as? ListsCell {
            currentCell.showIndicator(isSelected: true)
        }
        
        self.topCollectionView.scrollToItem(at: IndexPath(item: DL_DataManager.sharedInstance.selectedTopCollectionViewIndex, section: 0), at: .left, animated: animated)
    }
    
    //MARK: - selecting cell
    
    func didSelectCellAtIndex(index: Int) {
        
        //DLDataManager.sharedInstance.selectedTopCollectionViewIndex = index
        self.myCollectionView!.scrollToItem(at: IndexPath(item: index, section: 0), at: .left, animated: true)
        print("> ")
        print("> top, selected cell index = \(DL_DataManager.sharedInstance.selectedTopCollectionViewIndex) ")
        print("> ")
        
        self.displayTopScrollViewWithIndex(index: index, animated: true)
    }
    
    //MARK: - collection data
    
    func createVC() {
        
        let storyboard = UIStoryboard(name: "lookup", bundle: nil)
        self.viewsList.removeAll()
        
//        for eachDay in DL_DataManager.sharedInstance.monthDayDisplayList {
//            let dateString: String = String(format: "Date: %@", eachDay)
//            let explist: [ExpenseModel] = DL_DataManager.sharedInstance.lookupExpenseDict[eachDay] ?? []
//
//            let vc: LookupListsViewController? = storyboard.instantiateViewController(withIdentifier: "LookupListsViewController") as? LookupListsViewController
//            vc!.delegate = self
//            vc!.lookupData(data: explist, dateString: dateString)
//            self.viewsList.append(vc!)
//        }
        
        for i in 0..<DL_DataManager.sharedInstance.monthDayDisplayList.count {
            let eachDay: String = DL_DataManager.sharedInstance.monthDayDisplayList[i]
            let eachWeekday: String = DL_DataManager.sharedInstance.dayOfWeekDisplayList[i]
            
            let dateString: String = String(format: "Date: %@, %@", eachDay, eachWeekday)
            let explist: [ExpenseModel] = DL_DataManager.sharedInstance.lookupExpenseDict[eachDay] ?? []
            
            let vc: LookupListsViewController? = storyboard.instantiateViewController(withIdentifier: "LookupListsViewController") as? LookupListsViewController
            vc!.delegate = self
            vc!.lookupData(data: explist, dateString: dateString)
            self.viewsList.append(vc!)
        }
    }
    
    //MARK: - lookup delegate
    
    func didSelectExpenseItem(item: ExpenseModel) {
        
        let message: String = "\n\nID : \(item.expId)\n\nDATE : \(item.date!)\n\nTIME : \(item.time!)\n\nVENDOR : \(item.vendor!)\n\nPAYMENT : \(item.payment!)\n\nAMOUNT : \(item.amount)\n\nNOTES : \(item.note!)\n\n"
        
        let alert = UIAlertController(title: "Selected Expense Item", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction( UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil) )
        self.present(alert, animated: true, completion: nil)
    }
    
}
