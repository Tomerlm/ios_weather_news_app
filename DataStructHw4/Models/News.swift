//
//  News.swift
//  DataStructHw4
//
//  Created by Tomer Landesman on 12/3/18.
//  Copyright © 2018 Tomer Landesman. All rights reserved.
//

import Foundation
class News{
    var headline: String = ""
    var description: String = ""
    var imageUrl: String = ""
    var webUrl: String = ""
    
    init(headline: String , description: String , imageUrl: String , webUrl: String){
        self.headline = headline
        self.description = description
        self.imageUrl = imageUrl
        self.webUrl = webUrl
    }
}
