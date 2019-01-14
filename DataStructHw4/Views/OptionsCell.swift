//
//  OptionsCell.swift
//  DataStructHw4
//
//  Created by Tomer Landesman on 12/31/18.
//  Copyright © 2018 Tomer Landesman. All rights reserved.
//

import UIKit

class OptionsCell: BaseCell {
    
    var model: SettingsItem? {
        didSet{
            labelView.text = model?.name
            imageView.image = UIImage(named: (model?.imageName)!)?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = UIColor.gray
        }
    }

    override func setupViews() {
        // setupviews
        self.addSubview(imageView)
        self.addSubview(labelView)
        
        addConstraintsWithFormat(format: "V:|-8-[v0(30)]|", views: imageView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: labelView)
        addConstraintsWithFormat(format: "H:|-8-[v0(30)]-8-[v1]|", views: imageView , labelView)
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1
            , constant: 0))

    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "home_icon")
        iv.backgroundColor = UIColor.white
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let labelView: UILabel = {
       
        let lb = UILabel()
        lb.text = "Sample"
        lb.textColor = UIColor.black
        lb.backgroundColor = UIColor.white
        lb.textAlignment = .left
        lb.font = UIFont.boldSystemFont(ofSize: 13)
        return lb
    }()
    
    override var isHighlighted: Bool {
        didSet{
            self.backgroundColor = isHighlighted ? UIColor.gray : UIColor.white
            labelView.textColor = isHighlighted ? UIColor.white : UIColor.black
            labelView.backgroundColor = isHighlighted ? UIColor.gray : UIColor.white
            imageView.tintColor = isHighlighted ? UIColor.white : UIColor.gray
        }
    }
    
}

