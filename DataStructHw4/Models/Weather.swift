//
//  Weather.swift
//  DataStructHw4
//
//  Created by Tomer Landesman on 12/12/18.
//  Copyright © 2018 Tomer Landesman. All rights reserved.
//

import Foundation
class Weather{
    
    var temperature: String = ""
    var description: String = ""
    var precipitation: String = ""
    var wind: String = ""
    var feelsLike: String = ""
    

    
    init(temperature: String , description: String , precipitation: String , wind: String , feelsLike: String){
        self.temperature = temperature
        self.description = description
        self.precipitation = precipitation
        self.wind = wind
        self.feelsLike = feelsLike
        
    }
}
