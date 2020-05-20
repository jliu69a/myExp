//
//  HomePageViewController.swift
//  myExpenseTracker
//
//  Created by Johnson Liu on 5/19/20.
//  Copyright © 2020 Home Office. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var myExpsIndicatorLabel: UILabel!
    @IBOutlet weak var adminsIndicatorLabel: UILabel!
    
    @IBOutlet weak var mainView: UIView!
    
    var myexpsVC: ExpenseHomeViewController? = nil
    var adminsVC: AdminHomeViewController? = nil
    
    var navController: UINavigationController? = nil
    var myCollectionView: UICollectionView? = nil
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navController = self.navigationController!
        
        self.createVCs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //-- create main collection view
        let xPosition = self.mainView.frame.origin.x
        let yPosition = self.mainView.frame.origin.y
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        print("> ")
        print("> inner view frame, x = \(xPosition), y = \(yPosition), w = \(width), h = \(height)")
        print("> ")

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
        
        //-- initial select
        self.showCurrentPage()
    }
    
    //MARK: - IB actions
    
    @IBAction func selectMyExpsAction(_ sender: Any) {
        self.chooseMyExps()
    }
    
    @IBAction func selectAdminsAction(_ sender: Any) {
        self.chooseAdmins()
    }
    
    //MARK: - collection view source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //-- main collection view
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath)
        
        let subview = self.viewsForCode(code: indexPath.row)
        let frame = myCell.contentView.bounds
        subview.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: (frame.size.height - 64))
        
        myCell.addSubview(subview)
        return myCell
    }
    
    //MARK: - collection view delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        //-- main scroll view
        let indexValue: CGFloat = scrollView.contentOffset.x / scrollView.frame.size.width
        print("-> width = \(scrollView.frame.size.width), offset = \(scrollView.contentOffset.x), index = \(indexValue) ")
        self.displayTopScrollViewWithIndex(index: Int(indexValue), animated: true)
    }
    
    //MARK: - helper functions
    
    func showCurrentPage() {
        
        if DataManager.sharedInstance.selectedCollectionViewIndex == 0 {
            self.chooseMyExps()
        }
        else {
            self.chooseAdmins()
        }
    }
    
    func chooseMyExps() {
        self.myExpsIndicatorLabel.isHidden = false
        self.adminsIndicatorLabel.isHidden = true
        
        self.scrollingMainCollections(index: 0)
        DataManager.sharedInstance.selectedCollectionViewIndex = 0
    }
    
    func chooseAdmins() {
        self.myExpsIndicatorLabel.isHidden = true
        self.adminsIndicatorLabel.isHidden = false
        
        self.scrollingMainCollections(index: 1)
        DataManager.sharedInstance.selectedCollectionViewIndex = 1
    }
    
    func scrollingMainCollections(index: Int) {
        self.myCollectionView!.scrollToItem(at: IndexPath(item: index, section: 0), at: .left, animated: true)
    }
    
    //MARK: - scroll functions
    
    func createVCs() {
        
        var storyboard = UIStoryboard(name: "expenseHome", bundle: nil)
        self.myexpsVC = storyboard.instantiateViewController(withIdentifier: "ExpenseHomeViewController") as? ExpenseHomeViewController
        self.myexpsVC!.navController = self.navController!
        
        storyboard = UIStoryboard(name: "adminHome", bundle: nil)
        self.adminsVC = storyboard.instantiateViewController(withIdentifier: "AdminHomeViewController") as? AdminHomeViewController
        self.adminsVC!.navController = self.navController!
    }
    
    func viewsForCode(code: Int) -> UIView {
        
        var view: UIView = UIView(frame: CGRect.zero)
        let checkingCode = code + 1
        
        switch checkingCode {
        case 1:
            if self.myexpsVC != nil {
                view = self.myexpsVC!.view
            }
            break
        case 2:
            if self.adminsVC != nil {
                view = self.adminsVC!.view
            }
            break
        default:
            break
        }
        return view
    }
    
    func displayTopScrollViewWithIndex(index: Int, animated: Bool) {
        
        switch index {
        case 0:
            self.chooseMyExps()
            break
        case 1:
            self.chooseAdmins()
            break
        default:
            break
        }
    }
    
}
