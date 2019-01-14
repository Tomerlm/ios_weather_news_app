//
//  MenuBar.swift
//  DataStructHw4
//
//  Created by Tomer Landesman on 12/26/18.
//  Copyright © 2018 Tomer Landesman. All rights reserved.
//

import Foundation
import UIKit

class MenuBar: UIView , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    let menuItemName = ["forecast", "news" , "info"]
    
    var selectedCellWidthConstraint: NSLayoutConstraint? = nil
    
    let horizontalBarView = UIView()
    
    let ESTIMATED_WIDTH_OFFSET: CGFloat = 88
    let CELL_HEIGHT: CGFloat = 30
    
    var horizontalBarWidthConstraint: NSLayoutConstraint?
    var horizontalBarLeftConstraint: NSLayoutConstraint?
    
    var cellsWidthList =  Dictionary<IndexPath , CGFloat>()
    var cellLeftAnchorConstant = Dictionary<IndexPath , CGFloat>()
    
    let cellID = "cellID"
    
    var parentVC: SectionViewController? = nil
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero , collectionViewLayout: layout)
        cv.backgroundColor = UIColor.rgb(red: 30, green: 30, blue: 180)
        cv.delegate = self
        cv.dataSource = self
        cv.isScrollEnabled = false
        
        return cv
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItemName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MenuCell
        if (indexPath.row == 0){
            horizontalBarWidthConstraint?.constant = cell.frame.width
            horizontalBarWidthConstraint?.isActive = true
        }
        cellsWidthList[indexPath] = cell.frame.width
        calculateLeftConstant(currentWidth: cell.frame.width, indexPath: indexPath)
        cell.textView.tintColor = UIColor.rgb(red: 13, green: 14, blue: 70)
        cell.textView.text = menuItemName[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let size = CGSize(width: 1200, height: CELL_HEIGHT)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        let estimatedFrame = NSString(string: menuItemName[indexPath.row]).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        return CGSize(width: estimatedFrame.width + ESTIMATED_WIDTH_OFFSET, height: CELL_HEIGHT)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let pvc = parentVC else {
            return
        }
        horizontalBarLeftConstraint?.constant = cellLeftAnchorConstant[indexPath]!
        horizontalBarWidthConstraint?.constant = cellsWidthList[indexPath]!
        pvc.scrollToMenuItem(menuIndex: indexPath.item)


    }
    
    func calculateLeftConstant(currentWidth: CGFloat, indexPath: IndexPath){
        cellLeftAnchorConstant[indexPath] = 0
        for item in cellLeftAnchorConstant{
            if item.key != indexPath{
                cellLeftAnchorConstant[indexPath] = cellLeftAnchorConstant[indexPath]! + cellsWidthList[item.key]!
            }
        }
    }
    

    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellID)
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        collectionView.selectItem(at: firstIndex, animated: false, scrollPosition: [])
        
        setupHorizontalBar()

   
    }
    
    func setupHorizontalBar(){
        
        //horizontalBarView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        horizontalBarView.backgroundColor = UIColor.white
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarView)
        

        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        horizontalBarLeftConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalBarLeftConstraint?.isActive = true
        horizontalBarWidthConstraint = horizontalBarView.widthAnchor.constraint(equalToConstant: self.frame.width / 4)
        horizontalBarWidthConstraint?.isActive = true



    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let firstIndex = IndexPath(item: 0, section: 0)
    
    
}
