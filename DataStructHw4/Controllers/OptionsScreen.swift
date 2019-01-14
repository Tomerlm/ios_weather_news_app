// new api key c74d38e1bf1742b8b568cf30acbbb0b8

import Alamofire
import SwiftyJSON
import Kingfisher
import UIKit
import CoreLocation

//https://api.unsplash.com/photos/random?client_id=a99603d4b1944706f22e3f0251674527b377666c6c732f57f8bd45689357aaa6



class OptionsScreen: UIViewController , CLLocationManagerDelegate{
    
    // Logic
    typealias jsonCompletionHandler = (_ json: JSON? , _ err: Error?) -> Void
    
    typealias CLGeocodeCompletionHandler = ([CLPlacemark]?, Error?) -> Void
    
    let COO_ERR: String = "Error Getting Coordinates"
    
    let locationManager = CLLocationManager()
    
    let geocoder = CLGeocoder()
    
    var headlines: [String] = []
    
    var currentCountry: String? = ""
    
    let DEGREE_MARK = "°"
    
    var workItem : DispatchWorkItem?
    
    let countryCodeHandler = CountryCodes()
    
    var countryDelegate: UIViewController? = nil
    
    // UI
    
    let isImageAnimating: Bool = true
    
    let settingsLauncher = SettingsLauncher()
    
    var menuBar: MenuBar? = nil
    
    @IBOutlet weak var customLocationBtn: UIButton!
    @IBOutlet weak var mLocationBtn: UIButton!
    @IBOutlet weak var fromMapBtn: UIButton!
    @IBOutlet weak var animatingImage: UIImageView!
    @IBOutlet weak var textInput: UITextField!
    
    @IBOutlet weak var weatherDisplayView: WeatherDisplayView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        weatherDisplayView.isHidden = true
        bgOrientationCheck()
        progressBar.style = .whiteLarge
        progressBar.stopAnimating()
        progressBar.hidesWhenStopped = true
        
        

        customLocationBtn.setRoundButtonLayout()
        mLocationBtn.setRoundButtonLayout()
        fromMapBtn.setRoundButtonLayout()
        
        setNewConstraints()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
        }

    }
    
    @objc func optionsMenuAction(){
        settingsLauncher.showSettings()
    }
    

    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.denied){
            showLocationDisabledPopup()
        }
    }
    
    func showLocationDisabledPopup(){
        let alertController = UIAlertController(title: "Location access disabled" ,
                                                message:"We need your premmission to use location",
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let openAction = UIAlertAction(title: "Open Settings", style: .default) {(action) in
            if let url = URL(string: UIApplication.openSettingsURLString){
                UIApplication.shared.open(url, options: [:] , completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var progressBar: UIActivityIndicatorView!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBAction func goToMap(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MapVC")
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func myLocationBtn(_ sender: Any) {
        if let mLocation = locationManager.location {
            locationManager.startUpdatingLocation()
            let lat = mLocation.coordinate.latitude.description
            let lng = mLocation.coordinate.longitude.description
            print("getting weather for: ")
            print("lat: \(lat)")
            print("lng: \(lng)")
            handleWeather(lng: lng, lat: lat, displayAddress: "your location")
            locationManager.stopUpdatingLocation()
        }
        else{
            print("problem getting your location")
        }
        
    }
    
    @IBAction func actionBtn(_ sender: Any) {
        addressTextField.resignFirstResponder()

        if addressTextField.text != "" || addressTextField.text != nil {
            if(self.weatherDisplayView.isHidden == false){
                self.weatherDisplayView.isHidden = true
            }
            let displayAddress = addressTextField.text!
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
                    self.changeCurrentCountry(country: (pm?.country?.description)!)
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
    
    func changeCurrentCountry(country: String){
        self.currentCountry = country
        (countryDelegate as! SectionViewController).didChangeCountry(country: country)
        
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
                    
                    self.animateWeatherImage()

                
                }
            }
            else{
                self.progressBar.stopAnimating()
                print(err ?? 400)
            }
        }
    }
    
    
    func animateWeatherImage(){
        self.animatingImage.isHidden = false
        UIView.animate(withDuration: 2, delay: 0, options: [.curveLinear , .repeat ], animations: { () -> Void in
            self.animatingImage.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        } , completion: nil)

    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        bgOrientationCheck()
    }
    
    func bgOrientationCheck(){
        switch UIDevice.current.orientation{
        case .portrait:
            self.view.addBackground()
            if !self.animatingImage.isHidden{
                self.animateWeatherImage()
            }
            break
        case .landscapeLeft:
            
            self.view.addBackground(imageName: "LrotatedBG.png")
            if !self.animatingImage.isHidden{
                self.animateWeatherImage()
            }
            break
        case .landscapeRight:
            
            self.view.addBackground(imageName: "LrotatedBG.png")
            if !self.animatingImage.isHidden{
                self.animateWeatherImage()
            }
            break
        case .faceUp:
            break
        case .faceDown:
            break
        case .unknown:
            self.view.addBackground(imageName: "LrotatedBG.png")
            if !self.animatingImage.isHidden{
                self.animateWeatherImage()
            }
            break
        case .portraitUpsideDown:
            self.view.addBackground()
            if !self.animatingImage.isHidden{
                self.animateWeatherImage()
            }
            break
        }
    }
    
    func setNewConstraints(){
        let formatH = "V:|-64-[v0(35)]-24-[v1(50)]-16-[v2(50)]-16-[v3(50)]-34-[v4]-4-|"
        view.addConstraintsWithFormat(format:formatH , views: textInput , customLocationBtn , mLocationBtn , fromMapBtn , weatherDisplayView )
        
        view.addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: textInput)
        view.addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: customLocationBtn)
        view.addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: mLocationBtn)
        view.addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: fromMapBtn)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: weatherDisplayView)
        
    }
    
    
    
    

}





