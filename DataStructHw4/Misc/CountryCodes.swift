//
//  CountryCodes.swift
//  DataStructHw4
//
//  Created by Tomer Landesman on 11/26/18.
//  Copyright © 2018 Tomer Landesman. All rights reserved.
//

import Foundation
import SwiftyJSON

class CountryCodes{
    
    var codes: [Any] = []
    
    init(){
        readJson()
    }
    
    func getCountryCode(country: String) -> String{
        if(codes.count > 0){
            var countryToCompare = ""
            for i in codes as! [Dictionary<String, AnyObject>] {
                countryToCompare = i["Name"] as! String
                if (countryToCompare.lowercased() == country.lowercased()){
                    return (i["Code"] as! String).lowercased()
                }
            }
            return ""
        }
        else{
            print("error getting code")
            return ""
        }
    }

    
    
    private func readJson() {
        do {
            if let file = Bundle.main.url(forResource: "country_codes", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    // json is a dictionary
                } else if let object = json as? [Any] {
                    // json is an array
                    codes = object
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
