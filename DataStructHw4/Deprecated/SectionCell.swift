//
//  SectionCell.swift
//  DataStructHw4
//
//  Created by Tomer Landesman on 1/2/19.
//  Copyright © 2019 Tomer Landesman. All rights reserved.
//

import UIKit

class SectionCell: BaseCell {
    
    var someView: UIView? {
        didSet{
            setupViews()
        }
    }
    
   // let indicaro = UISt


    
    override init(frame: CGRect) {
        super.init(frame: frame)

        
        
    }
    
    override func setupViews() {
        if let view = someView {
            addSubview(view)
            
            self.addConstraintsWithFormat(format: "H:|[v0]|", views: view)
            self.addConstraintsWithFormat(format: "V:|[v0]|", views: view)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
