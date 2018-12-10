// new api key c74d38e1bf1742b8b568cf30acbbb0b8

import Alamofire
import SwiftyJSON
import Kingfisher
import UIKit
import CoreLocation

//https://api.unsplash.com/photos/random?client_id=a99603d4b1944706f22e3f0251674527b377666c6c732f57f8bd45689357aaa6



class OptionsScreen: UIViewController , CLLocationManagerDelegate {
    
    typealias jsonCompletionHandler = (_ json: JSON? , _ err: Error?) -> Void
    
    typealias CLGeocodeCompletionHandler = ([CLPlacemark]?, Error?) -> Void
    
    let COO_ERR: String = "Error Getting Coordinates"
    
    let locationManager = CLLocationManager()
    
    let geocoder = CLGeocoder()
    
    var headlines: [String] = []
    
    var currentCountry: String? = ""
    
    let countryCodeHandler = CountryCodes()
    
    @IBOutlet weak var newBtnLayout: UIButton!
    @IBOutlet weak var customLocationBtn: UIButton!
    @IBOutlet weak var mLocationBtn: UIButton!
    @IBOutlet weak var fromMapBtn: UIButton!
    
    override func viewDidLoad() {
        tempImage.isHidden = true
        progressBar.style = .whiteLarge
        progressBar.stopAnimating()
        progressBar.hidesWhenStopped = true
        
        setButtonLayout(button: newBtnLayout)
        setButtonLayout(button: customLocationBtn)
        setButtonLayout(button: mLocationBtn)
        setButtonLayout(button: fromMapBtn)
        
        
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
        }
        
        
        
        super.viewDidLoad()
    }
    
    
    @IBAction func reportViewButton(_ sender: Any) {
                self.performSegue(withIdentifier: "mainToReportSegue", sender: self)
        
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
    
    
    
    

    @IBOutlet weak var tempImage: UIImageView!
    
    @IBOutlet weak var weatherLabel: UILabel!
    
    @IBOutlet weak var progressBar: UIActivityIndicatorView!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBAction func goToMap(_ sender: Any) {
        self.performSegue(withIdentifier: "mapViewSegue", sender: self)
    }
    @IBAction func getNewsBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "getNewsSegue", sender: self)
    }
    @IBAction func myLocationBtn(_ sender: Any) {
        print(locationManager.location)
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
        tempImage.isHidden = true
        self.weatherLabel.isHidden = true
        if weatherLabel.text != "" || weatherLabel.text != nil {
            let displayAddress = addressTextField.text!
            self.progressBar.startAnimating()
            fetchData(displayAddress)
        }
        
    }
    
    func fetchData(_ address: String){

            getAppleCoordinates(address: address){ (placemarks , err) in // googleGecode request callback
                if (err != nil) {
                    self.progressBar.stopAnimating()
                    print("An error has ocurred: \(err)")
                    }
                else{
                    
                        if (placemarks?.count)! > 0 {
                            let pm = placemarks?[0]
                            let lat = pm?.location?.coordinate.latitude.description
                            let lng = pm?.location?.coordinate.longitude.description
                            self.currentCountry = pm?.country?.description
                            print("getting weather for coordinats:")
                            print("lat: \(String(describing: lat)) , lng: \(String(describing: lng))")
                            self.handleWeather(lng: lng, lat:  lat, displayAddress: address)

                        }
                        else{
                            print("error with placemarks")
                        }
                    print("got coordinates. fetching weather data...") // end of googleGeocode callback

                }
            }
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
    
    func handleWeather(lng: String?, lat: String?, displayAddress: String){
        self.getWeather(lng: lng!, lat: lat!){ (json , err) in
            if let jsonObj = json {
                
                
                if(jsonObj["code"] == 400){
                    self.progressBar.stopAnimating()
                    print("Bad Coordinates")
                }
                else{
                    var temp = jsonObj["currently"]["temperature"].rawString()!
                    let tempDouble = Double(temp)!
                    let celsius = (tempDouble - 32)*(5/9)
                    temp = String(celsius)
                    temp = String(temp.prefix(4))
                    self.getImage(){(json , err) in
                        if let jsonObj = json {
                            
                            let urlString = jsonObj["links"]["download"].rawString()!
                            let imageUrl = URL(string: urlString)
                            let path = Bundle.main.path(forResource: "snoop", ofType: "gif")!
                            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
                            self.tempImage.kf.indicatorType = .image(imageData: data)
                            self.tempImage.kf.setImage(with: imageUrl, completionHandler: {
                                (image, error, cacheType, imageUrl) in
                                if (image == nil || error != nil){
                                    print("error getting image")
                                }
                                else{
                                    DispatchQueue.main.async {
                                        self.progressBar.stopAnimating()
                                        self.tempImage.isHidden = false
                                        print("downloaded image from url: \(urlString)")
                                        self.weatherLabel.text = "Temperature in \(displayAddress) : " + temp
                                        self.weatherLabel.isHidden = false
                                    }

                                }

                            })

                            
                        }
                        else{
                            print("error getting image: \(err)")
                        }
                        
                    }
                
                }
            }
            else{
                self.progressBar.stopAnimating()
                print(err ?? 400)
            }
        }
    }
    
    private func praseAddress(address: String) -> String{
        print(address.replacingOccurrences(of: " ", with: "+"))
        return address.replacingOccurrences(of: " ", with: "+")
    }
    
    private func getImage(completionHandler: @escaping jsonCompletionHandler){
        let url = "https://api.unsplash.com/photos/random?client_id=a99603d4b1944706f22e3f0251674527b377666c6c732f57f8bd45689357aaa6"
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "mapViewSegue":
                let controller = segue.destination as! Map
            case "getNewsSegue":
                let controller = segue.destination as! NewsViewController
                if let country = self.currentCountry{
                    controller.currentCountry = self.countryCodeHandler.getCountryCode(country: country)
                }
            default:
                return
            }
        }
    }
    
    func setButtonLayout(button: UIButton){
        
        button.layer.cornerRadius = button.frame.height / 2
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        
    }
    
    

}


        



