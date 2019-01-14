//
//  ExpandedNews.swift
//  DataStructHw4
//
//  Created by Tomer Landesman on 12/10/18.
//  Copyright © 2018 Tomer Landesman. All rights reserved.
//

import Foundation
class ExpandedNews{
    var source: String = ""
    var description: String = ""
    var imageUrl: String = ""
    var webUrl: String = ""
    
    init(source: String , description: String , imageUrl: String , webUrl: String){
        self.source = source
        self.description = description
        self.imageUrl = imageUrl
        self.webUrl = webUrl
    }
}
