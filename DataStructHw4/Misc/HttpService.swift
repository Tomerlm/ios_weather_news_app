//
//  LocationHelper.swift
//  DataStructHw4
//
//  Created by Tomer Landesman on 1/2/19.
//  Copyright © 2019 Tomer Landesman. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON
import Alamofire

class HttpService {
    
    static let sharedInstance = HttpService()
    
    typealias jsonCompletionHandler = (_ json: JSON? , _ err: Error?) -> Void
    
    typealias CLGeocodeCompletionHandler = ([CLPlacemark]?, Error?) -> Void
    
    let COO_ERR: String = "Error Getting Coordinates"
    
    let locationManager = CLLocationManager()
    
    let geocoder = CLGeocoder()
    
    var headlines: [String] = []
    
    var currentCountry: String? = ""
    
    let countryCodeHandler = CountryCodes()


    
    func weatherFromJson(jsonObj: JSON) -> Weather{
        var temp = jsonObj["currently"]["temperature"].rawString()!
        temp = Utilities.toCelsius(fern: temp)
        var description = jsonObj["currently"]["icon"].description
        var feelsLike = jsonObj["currently"]["apparentTemperature"].rawString()!
        feelsLike = "Feels like: " + Utilities.toCelsius(fern: feelsLike)
        var wind = jsonObj["currently"]["windSpeed"].rawString()!
        wind = Utilities.roundString(str: wind) + " kmH"
        var precipitation = jsonObj["currently"]["precipProbability"].description
        print(precipitation)
        precipitation = Utilities.roundString(str: precipitation) + "%"
        let mWeather = Weather(temperature: temp, description: description, precipitation: precipitation, wind: wind, feelsLike: feelsLike)
        return mWeather
    }
    
    func newsFromJson(jsonObj: JSON , i: Int) -> News{
        let description = jsonObj["articles"][i]["title"].description
        let source = jsonObj["articles"][i]["source"]["name"].description
        let urlToImageString = jsonObj["articles"][i]["urlToImage"].rawString()!
        let webUrl = jsonObj["articles"][i]["url"].rawString()!
        return News(source: source , description: description , imageUrl: urlToImageString , webUrl: webUrl)
    }
    func expandedNewsFromJson(jsonObj: JSON , i: Int) -> ExpandedNews{
        let source = jsonObj["articles"][i]["source"]["name"].description
        let urlToImageString = jsonObj["articles"][i]["urlToImage"].rawString()!
        let content = jsonObj["articles"][i]["description"].rawString()!
        let webUrl = jsonObj["articles"][i]["url"].rawString()!
        return ExpandedNews(source: source, description: content, imageUrl:urlToImageString, webUrl: webUrl)
    }
    
    func getAppleCoordinates(address: String , completionHandler: @escaping CLGeocodeCompletionHandler){
        geocoder.geocodeAddressString(address, completionHandler: completionHandler)
    }
    
    func getWeather(lng: String , lat: String , completionHandler: @escaping jsonCompletionHandler){
        let url = "https://api.darksky.net/forecast/2a9adca025c4990448ebbca5a91295da/" + lat + "," + lng
        Alamofire.request(url).responseJSON{ (response) in
            switch response.result {
            case .success(let data):
                let jsonData = JSON(data)
                completionHandler(jsonData , nil)
            case .failure(let error):
                completionHandler(nil , error)
                
            }
        }
    }
    
    func getHeadlines(country: String , completionHandler: @escaping jsonCompletionHandler){
        let url = "https://newsapi.org/v2/top-headlines?country=" + country + "&apiKey=c74d38e1bf1742b8b568cf30acbbb0b8"
        Alamofire.request(url).responseJSON{ (response) in
            switch response.result{
            case .success(let data):
                let jsonData = JSON(data)
                completionHandler(jsonData, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    
    
        
        
        
        
        
        
}
