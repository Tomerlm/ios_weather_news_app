//
//  WeatherDisplayView.swift
//  DataStructHw4
//
//  Created by Tomer Landesman on 12/12/18.
//  Copyright © 2018 Tomer Landesman. All rights reserved.
//

import Foundation
import UIKit

class WeatherDisplayView: UIView {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var perceptionLabel: UILabel!
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var weather: Weather? {
        didSet{
           self.updateUI()
        }
    }
    
    func updateUI(){
        
        self.tempLabel.text = weather?.temperature
        self.descriptionLabel.text = weather?.description
        self.feelsLikeLabel.text = weather?.feelsLike
        self.perceptionLabel.text = weather?.precipitation
        
    }

    
    
}
