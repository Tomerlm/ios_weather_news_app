//
//  MenuCell.swift
//  DataStructHw4
//
//  Created by Tomer Landesman on 12/26/18.
//  Copyright © 2018 Tomer Landesman. All rights reserved.
//

import Foundation
import UIKit

class MenuCell: BaseCell {

    override func setupViews(){
        backgroundColor = UIColor.rgb(red: 30, green: 30, blue: 180)
        
        addSubview(textView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: textView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: textView)
        addConstraint(NSLayoutConstraint(item: textView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: textView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    let textView: UILabel = {
        let tv = UILabel()
        tv.text = "forecast"
        tv.backgroundColor = UIColor.rgb(red: 30, green: 30, blue: 180)
        tv.textAlignment = .center
        tv.font = UIFont.boldSystemFont(ofSize: 14)
        tv.tintColor = UIColor.rgb(red: 13, green: 14, blue: 70)
        return tv
    }()
    
    override var isHighlighted: Bool {
        didSet{
            textView.textColor = isHighlighted ? UIColor.white : UIColor.rgb(red: 13, green: 14, blue: 70)
            textView.font = UIFont.boldSystemFont(ofSize: 14)
        }
    }
    override var isSelected: Bool {
        didSet{
           textView.textColor = isSelected ? UIColor.white : UIColor.rgb(red: 13, green: 14, blue: 70)
            textView.font = UIFont.boldSystemFont(ofSize: 14)
        }
    }
    
    
}
