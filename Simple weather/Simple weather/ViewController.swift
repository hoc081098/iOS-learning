//
//  ViewController.swift
//  Simple weather
//
//  Created by Petrus Nguyễn Thái Học on 10/2/19.
//  Copyright © 2019 Petrus Nguyễn Thái Học. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    private let locationManager = CLLocationManager.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.requestLocation()
        }
    }


}

extension ViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Get location error: \(error.localizedDescription)")
    }
}

