//
//  MainNavigationViewController.swift
//  DataStructHw4
//
//  Created by Tomer Landesman on 12/26/18.
//  Copyright © 2018 Tomer Landesman. All rights reserved.
//

import Foundation
import UIKit

class MainNavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Main Navigation Controller"
        
        
        self.navigationBar.isHidden = false
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    
    }
    
}
