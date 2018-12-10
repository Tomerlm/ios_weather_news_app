//
//  Coordinate.swift
//  DataStructHw4
//
//  Created by Tomer Landesman on 11/19/18.
//  Copyright © 2018 Tomer Landesman. All rights reserved.
//

import Foundation

class Coordinate{
    private var lng: String
    private var lat: String
    
    init(lng: String , lat: String){
        self.lng = lng
        self.lat = lat
    }
    
    func getLng() -> String{
        return self.lng
    }
    
    func getLat() -> String{
        return self.lat
    }
}
