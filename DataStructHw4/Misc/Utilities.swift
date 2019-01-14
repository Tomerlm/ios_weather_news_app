//
//  Utilities.swift
//  DataStructHw4
//
//  Created by Tomer Landesman on 1/2/19.
//  Copyright © 2019 Tomer Landesman. All rights reserved.
//

import Foundation

class Utilities {
    
    static func praseAddress(address: String) -> String{
        print(address.replacingOccurrences(of: " ", with: "+"))
        return address.replacingOccurrences(of: " ", with: "+")
    }
    
    static func toCelsius(fern: String) -> String{
        
        let tempDouble = Double(fern)!
        let celsius = round((tempDouble - 32)*(5/9))
        if celsius == 0.0 {
            return "0" + "°"
        }
        let temp = String(celsius)
        return temp + "°"
        
    }
    
    static func roundString(str: String) -> String{
        let roundWind = round(Double(str)!)
        return String(roundWind)
    }
    
    
}
