//
//  MainOptionsView.swift
//  DataStructHw4
//
//  Created by Tomer Landesman on 1/7/19.
//  Copyright © 2019 Tomer Landesman. All rights reserved.
//

import UIKit

class ForecastView: BaseInsideSectionView , UITextFieldDelegate  {
    
    //LOGIC
    
    var displayAdress: String = ""
    
    var currentCountry: String = ""
    
    //UI
    
    
    let weatherDisplayView: WeatherDisplayView = {
        let weather = WeatherDisplayView()
        weather.isHidden = true
        return weather
    }()
    
    let progressBar: UIActivityIndicatorView = {
        let ind = UIActivityIndicatorView()
        ind.isHidden = true
        ind.translatesAutoresizingMaskIntoConstraints = false
        return ind
    }()
    
    let customLocButton: MainOptionsButton = {
        let btn = MainOptionsButton()
        btn.setTitle("Custom Location", for: .normal)
        btn.setRoundButtonLayout()
        btn.backgroundColor = UIColor.rgb(red: 0, green: 76, blue: 153)
        btn.addTarget(self, action: #selector(getCustomLocationWeather) , for: UIControl.Event.touchDown)
        return btn
    }()
    
    let textInput: UITextField = {
       
        let txt = UITextField()
        txt.setRoundLayout()
        txt.text = "Where do you want to check?"
        txt.backgroundColor = UIColor.white
        txt.textAlignment = .center
        return txt
        
    }()
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    override func setupViews(){
        
        textInput.delegate = self
        
        setKeyboardDismiss()
        
        
        addBackground(imageName: "background", contentMode: .scaleAspectFill)
        
        addSubview(progressBar)
        addSubview(textInput)
        addSubview(customLocButton)
        
        //progress bar constraints
        progressBar.center = center
        progressBar.widthAnchor.constraint(equalToConstant: 30).isActive = true
        progressBar.heightAnchor.constraint(equalToConstant: 30).isActive = true
        progressBar.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        progressBar.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        // textField and Buttons constraints
        addConstraintsWithFormat(format: "V:|-16-[v0(30)]|", views: textInput)
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: customLocButton)
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: textInput)
        
        customLocButton.topAnchor.constraint(equalTo: textInput.bottomAnchor, constant: 32).isActive = true
        customLocButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        

    }
    
    func setKeyboardDismiss(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        textInput.resignFirstResponder()
    }
    
    @objc func getCustomLocationWeather(){
        textInput.resignFirstResponder()
        
        if textInput.text != "" || textInput.text != nil {
            if(self.weatherDisplayView.isHidden == false){
                self.weatherDisplayView.isHidden = true
            }
            let displayAddress = textInput.text!
            self.progressBar.startAnimating()
            fetchData(displayAddress)
        }
        
    }
    
    func fetchData(_ address: String){
        
        HttpService.sharedInstance.getAppleCoordinates(address: address , completionHandler: { (placemarks , err) in // googleGecode request callback
            if (err != nil) {
                self.progressBar.stopAnimating()
                print("An error has ocurred: \(String(describing: err))")
            }
            else{
                if (placemarks?.count)! > 0 {
                    let pm = placemarks?[0]
                    let lat = pm?.location?.coordinate.latitude.description
                    let lng = pm?.location?.coordinate.longitude.description
                    self.currentCountry = pm?.country?.description ?? ""
                    print("getting weather for coordinats:")
                    print("lat: \(String(describing: lat)) , lng: \(String(describing: lng))")
                    self.handleWeather(lng: lng, lat:  lat, displayAddress: address)
                }
                else{
                    print("error with placemarks")
                }
                print("got coordinates. fetching weather data...") // end of googleGeocode callback
            }
        })
    }
    
    func handleWeather(lng: String?, lat: String?, displayAddress: String){
        HttpService.sharedInstance.getWeather(lng: lng!, lat: lat!){ (json , err) in
            if let jsonObj = json {
                
                
                if(jsonObj["code"] == 400){
                    self.progressBar.stopAnimating()
                    print("Bad Coordinates")
                }
                else{
                    self.progressBar.stopAnimating()
                    
                    self.weatherDisplayView.weather = HttpService.sharedInstance.weatherFromJson(jsonObj: jsonObj)
                    self.weatherDisplayView.isHidden = false
                    
                    //self.animateWeatherImage()
                    
                    
                }
            }
            else{
                self.progressBar.stopAnimating()
                print(err ?? 400)
            }
        }
    }
    

}
