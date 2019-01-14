//
//  Coordinate.swift
//  DataStructHw4
//
//  Created by Tomer Landesman on 11/19/18.
//  Copyright © 2018 Tomer Landesman. All rights reserved.
//

import Foundation

class Coordinate{
     var lng: String
     var lat: String
    var address: String
    
    
    init(lng: String , lat: String , address: String){
        self.lng = lng
        self.lat = lat
        self.address = address
    }
    
}
