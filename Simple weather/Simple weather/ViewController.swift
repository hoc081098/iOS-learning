//
//  ViewController.swift
//  Simple weather
//
//  Created by Petrus Nguyễn Thái Học on 10/2/19.
//  Copyright © 2019 Petrus Nguyễn Thái Học. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import MBProgressHUD

let apiKey = "6592d24a33ae13c2ac1401db99732c61"

struct CurrentWeather {
    let name: String
    let main: String
    let icon: String
    let temperature: Double
}

class ViewController: UIViewController {
    private let locationManager = CLLocationManager.init()

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var labelCityName: UILabel!
    @IBOutlet weak var labelTemperature: UILabel!
    @IBOutlet weak var labelMainWeather: UILabel!
    @IBOutlet weak var imageWeather: UIImageView!
    @IBOutlet weak var labelDayOfWeek: UILabel!

    private let gradientLayer = CAGradientLayer.init()
    private var hud: MBProgressHUD?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.backgroundView.layer.addSublayer(gradientLayer)

        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.requestLocation()
        }

        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .indeterminate
        hud.label.text = "Loading..."
        self.hud = hud
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setBlueGradient()
    }

    private func setBlueGradient() {
        let topColor = UIColor.init(red: 95.0 / 255, green: 165.0 / 255, blue: 1, alpha: 1).cgColor
        let bottomColor = UIColor.init(red: 72.0 / 255, green: 114.0 / 255, blue: 184.0 / 255, alpha: 1).cgColor
        self.gradientLayer.frame = self.view.bounds
        self.gradientLayer.colors = [topColor, bottomColor]
    }

    private func setGreyGradient() {
        let topColor = UIColor.init(red: 151.0 / 255, green: 151.0 / 255, blue: 151.0 / 255, alpha: 1).cgColor
        let bottomColor = UIColor.init(red: 72.0 / 255, green: 72.0 / 255, blue: 72.0 / 255, alpha: 1).cgColor
        self.gradientLayer.frame = self.view.bounds
        self.gradientLayer.colors = [topColor, bottomColor]
    }

    private func render(with weather: CurrentWeather) {
        self.hud?.hide(animated: true)
        self.labelCityName.text = weather.name
        self.labelMainWeather.text = weather.main

        let numberFomatter = NumberFormatter.init()
        numberFomatter.numberStyle = .decimal
        numberFomatter.maximumFractionDigits = 2
        self.labelTemperature.text = numberFomatter.string(from: .init(value: weather.temperature))

        self.imageWeather.image = UIImage.init(named: weather.icon)

        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "EEEE"
        self.labelDayOfWeek.text = dateFormatter.string(from: .init())


        if weather.icon.hasSuffix("n") {
            self.setGreyGradient()
        } else {
            self.setBlueGradient()
        }

        print("Rendered")
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let lat = location.coordinate.latitude
            let lng = location.coordinate.longitude
            Alamofire
                .request(
                    "https://api.openweathermap.org/data/2.5/weather",
                    method: .get,
                    parameters: [
                        "lat": lat,
                        "lon": lng,
                        "appid": apiKey,
                        "units": "metric"
                    ]
                )
                .validate()
                .responseJSON { [weak self] (dataResponse) in
                    func hideHUD() {
                        self?.hud?.hide(animated: true)
                    }

                    if let error = dataResponse.error {
                        print("Error \(error)")
                        return hideHUD()
                    }
                    guard let json = dataResponse.result.value as? [String: Any]
                        else { return hideHUD() }

                    print(json)

                    guard let weather = (json["weather"] as? [Any])?.first as? [String: Any]
                        else { return hideHUD() }
                    guard let name = json["name"] as? String
                        else { return hideHUD() }
                    guard let main = weather["main"] as? String
                        else { return hideHUD() }
                    guard let icon = weather["icon"] as? String
                        else { return hideHUD() }

                    guard let temperature = (json["main"] as? [String: Any])?["temp"] as? Double
                        else { return hideHUD() }

                    self?.render(with: .init(name: name, main: main, icon: icon, temperature: temperature))
            }
        } else {
            self.hud?.hide(animated: true)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.hud?.hide(animated: true)
        print("Get location error: \(error.localizedDescription)")
    }
}

