//
//  BaseInsideSectionView.swift
//  DataStructHw4
//
//  Created by Tomer Landesman on 1/7/19.
//  Copyright © 2019 Tomer Landesman. All rights reserved.
//

import UIKit
class BaseInsideSectionView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    

    
    func setupViews(){
        print("base section")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
