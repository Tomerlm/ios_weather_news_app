//
//  HomeCollectionViewController.swift
//  DataStructHw4
//
//  Created by Tomer Landesman on 1/2/19.
//  Copyright © 2019 Tomer Landesman. All rights reserved.
//

import UIKit

class HomeCollectionView: UIView , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    var sectionViews: [UIView] = {
        
        let view1 = ForecastView()
        let view2 = NewsView()
        let arr: [UIView] = [view1 , view2]
        return arr
    }()
    
    let colors: [UIColor] = [UIColor.orange , UIColor.red]
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        collectionView.register(SectionCell.self, forCellWithReuseIdentifier: cellID)
        
        addSubview(collectionView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.isPagingEnabled = true
        cv.delegate = self
        cv.dataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    

    
    let cellID = "SectionCell"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionViews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SectionCell
        cell.someView = sectionViews[indexPath.row]

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width , height: frame.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
