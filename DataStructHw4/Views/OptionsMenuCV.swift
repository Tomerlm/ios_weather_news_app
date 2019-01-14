//
//  OptionsMenuCV.swift
//  DataStructHw4
//
//  Created by Tomer Landesman on 12/31/18.
//  Copyright © 2018 Tomer Landesman. All rights reserved.
//

import UIKit

class SettingsItem: NSObject {
    let name: String
    let imageName: String
    
    init(name: String,  imageName: String){
        self.name = name
        self.imageName = imageName
    }
}

class OptionsMenuCV: UIView , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    let cellID = "optionsCellID"
    let cellHeight: CGFloat = 50;
    
    var parentVC: SectionViewController? = nil
    
    let settings: [SettingsItem] = {
        let item1 = SettingsItem(name: "Settings" , imageName: "settings_icon")
        let item2 = SettingsItem(name: "About" , imageName: "about_icon")
        let item3 = SettingsItem(name: "Report a Bug" , imageName: "bug_icon")
        return[item1 , item2 , item3]
    }()
    
    lazy var collectionView: UICollectionView = {
       
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero , collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.delegate = self
        cv.dataSource = self
        cv.isScrollEnabled = false
        return cv
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.register(OptionsCell.self, forCellWithReuseIdentifier: cellID)
        
        self.addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        collectionView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! OptionsCell
        
        cell.model = settings[indexPath.row]

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: frame.width , height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
     public func getNumOfSettingsItems() -> CGFloat{
        return CGFloat(settings.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch(indexPath.item){
        case 0:
            clickedSettings()
            break
        case 1:
            clickedAbout()
        case 2:
            clickedReport()
        default:
            break
        }
    }
    
    func clickedSettings(){
        print("clicked settings")
    }
    
    func clickedAbout(){
        print("clicked about")
    }
    func clickedReport(){
        parentVC?.clickedReport()
    }
    
    
    
    
}
