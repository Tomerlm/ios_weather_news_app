//
//  SettingsLauncher.swift
//  DataStructHw4
//
//  Created by Tomer Landesman on 12/31/18.
//  Copyright © 2018 Tomer Landesman. All rights reserved.
//

import UIKit

class SettingsLauncher: NSObject {

    
    override init() {
        super.init()
        
    }
    
    let blackOpacityView = UIView()
    
    let collectionView = OptionsMenuCV()
    
    let cellID = "menuCell"
    
    func showSettings(){
        // set options slider
        
        if let window = UIApplication.shared.keyWindow {


            blackOpacityView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackOpacityView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissMenuTap)))
            window.addSubview(blackOpacityView)
            
            window.addSubview(collectionView)
            let height: CGFloat = collectionView.cellHeight * collectionView.getNumOfSettingsItems()
            let yPos = window.frame.height - height
            
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            blackOpacityView.frame = window.frame
            blackOpacityView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackOpacityView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: yPos, width: window.frame.width, height: height)
            }, completion: nil)
        }
        
        
    }
    
    
    
    @objc func dismissMenuTap() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackOpacityView.alpha = 0
            if let window = UIApplication.shared.keyWindow{
                let height: CGFloat = self.collectionView.cellHeight * self.collectionView.getNumOfSettingsItems()
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height , width: self.collectionView.frame.width, height: height)
            }
            
            
            
        })
    }
}
