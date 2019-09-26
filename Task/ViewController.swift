//
//  ViewController.swift
//  Task
//
//  Created by Solayman Rana on 24/9/19.
//  Copyright © 2019 Solayman Rana. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let regionInMeter: Double = 10000
    var previousLocation: CLLocation?
    
    
    @IBOutlet weak var menuButton: UIButton!
    
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        if menuView.isHidden == true {
            menuView.isHidden = false
        }else{
            menuView.isHidden = true
        }
    }
    
    @IBAction func gpsTouch(_ sender: Any) {
        startTracingUserLocation()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        checkLocationService()
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(center){[weak self] (placemarks, error) in
            guard let self = self else {return}
            
            if let _ = error {
                //show alert informing the user
                return
            }
            guard let placemark = placemarks?.first else{
                //show alert informing the user
                return
            }
            
            if placemark.locality == nil {
                print("nil")
            }
            
       
            
        guard  let previousLocation = self.previousLocation else {return}
        print(previousLocation.altitude)
       
        guard center.distance(from: previousLocation) > 50 else{return}
        
        self.previousLocation = center
       

        
        }
        
    }
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    func centerViewInUserLocation(){
        
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeter, longitudinalMeters: regionInMeter)
            mapView.setRegion(region, animated: true)
           
        }
    }
    
    func checkLocationService() {
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuthorization()
        }else{
            
        }
    }

    
    func checkLocationAuthorization(){
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            startTracingUserLocation()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways:
            break
            
        @unknown default:
            fatalError()
        }
    }
    
    func startTracingUserLocation(){
        mapView.showsUserLocation = true
        centerViewInUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)

        
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        let location = CLLocation(latitude:latitude, longitude:longitude)
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Address dictionary
            print(placeMark.addressDictionary)
            
            // Location name
            if let locationName = placeMark.addressDictionary!["Name"] as? String {
                print(locationName)
                if let city = placeMark.addressDictionary!["State"] as? String {
                    print(city)
                    if let country = placeMark.addressDictionary!["Country"] as? String {
                        print(country)
                        self.addressLabel.text = "\(locationName),\(city),\(country)"
                }
            }
         }
          

            
            
        })
        
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    
}


extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()    }
    
}


