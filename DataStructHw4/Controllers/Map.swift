//
//  Map.swift
//  DataStructHw4
//
//  Created by Tomer Landesman on 11/19/18.
//  Copyright © 2018 Tomer Landesman. All rights reserved.
// 

import UIKit
import MapKit
import CoreLocation


class Map: UIViewController , MKMapViewDelegate {
    
    var lastLat: String = "default"
    var lastLng: String = "default"
    var lastAddress: String = "default"
    var currentCountry: String? = ""
    
    var lastAnnotation: MKPointAnnotation? = nil;
    
    let geocoder = CLGeocoder()
    
    typealias geocodeCompletionHandler = ([CLPlacemark]?, Error?) -> Void


    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var getBtnView: UIButton!
    @IBOutlet weak var cancelBtnView: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        let gestureZ = UILongPressGestureRecognizer(target: self, action: #selector(self.revealRegionDetailsWithLongPressOnMap(sender:)))
        mapView.addGestureRecognizer(gestureZ)

        setUpButtonsConstraints()
        setButtonLayout(button: getBtnView)
        setButtonLayout(button: cancelBtnView)
        
    }
    
    func setUpButtonsConstraints(){
        getBtnView.translatesAutoresizingMaskIntoConstraints = false
        cancelBtnView.translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        //constraints for green button
        getBtnView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12).isActive = true
        getBtnView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        getBtnView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.47).isActive = true
        getBtnView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08).isActive = true
        
        //for red button
        cancelBtnView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12).isActive = true
        cancelBtnView.trailingAnchor.constraint(equalTo: view.trailingAnchor , constant: -8).isActive = true
        cancelBtnView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.47).isActive = true
        cancelBtnView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.08).isActive = true
        
        // for map
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
    
    
    func addAnotation(gesureRec: UIGestureRecognizer){

    }

    
    @IBAction func revealRegionDetailsWithLongPressOnMap(sender: UILongPressGestureRecognizer){
        if sender.state != UIGestureRecognizer.State.began { return }
        if(lastAnnotation != nil){
            mapView.removeAnnotation(lastAnnotation!)
        }
        let touchLocation = sender.location(in: mapView)
        let annotation = MKPointAnnotation()
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        annotation.coordinate = locationCoordinate
        getAddress(lat: locationCoordinate.latitude, lng: locationCoordinate.latitude){(placemarks, error) in
            if(error != nil){
                print("error fetching address from coordinates")
            }
            else{
                guard let pm = placemarks?.first else{
                    // placemark error
                    print("placemark error")
                    return
                }
                
                    let subThoroughfare = pm.subThoroughfare ?? "" + " "
                    let thoroughfare = pm.thoroughfare ?? "" + " "
                    let locality = pm.locality ?? "" + " "
                    let country = pm.country ?? ""
                    self.currentCountry = country
                    self.lastAddress = subThoroughfare + thoroughfare + locality + country
                    self.lastLat = locationCoordinate.latitude.description
                    self.lastLng = locationCoordinate.latitude.description
                    self.mapView.addAnnotation(annotation)
                    self.lastAnnotation = annotation
                    print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
                    print("address: \(self.lastAddress)")
            
        }

    }
}
    
    
    
    @IBAction func getWeatherBtn(_ sender: Any) {
        if (lastLat == "default"){
            print("didn't record coordinates")
        }
        else{
            self.performSegue(withIdentifier: "mainSegue", sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC : OptionsScreen = segue.destination as! OptionsScreen
        if (lastLat == "default"){
            print("no coordinates to pass")
        }
        else{
            destVC.handleWeather(lng: lastLng, lat: lastLat, displayAddress: lastAddress)
            destVC.currentCountry = self.currentCountry
        }
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        lastLat = "default"
        lastLng = "default"
        self.performSegue(withIdentifier: "mainSegue", sender: self)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation){
        mapView.centerCoordinate = userLocation.location!.coordinate
    }
    
    func getAddress(lat: CLLocationDegrees , lng: CLLocationDegrees , completionHandler: @escaping geocodeCompletionHandler){
        let location = CLLocation(latitude: lat, longitude: lng)
        geocoder.reverseGeocodeLocation(location, completionHandler: completionHandler)
        
        
    }
    
    func setButtonLayout(button: UIButton){
        
        button.layer.cornerRadius = getBtnView.frame.height / 2
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        
    }
    

}
