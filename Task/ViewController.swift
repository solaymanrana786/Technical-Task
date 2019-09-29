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
    
    
    @IBOutlet weak var carImageView: UIImageView!
    
    @IBOutlet weak var hideAndShowView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var downView: UIView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBAction func hideButton(_ sender: Any) {
        

        
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            self.hideAndShowView.alpha = 0 // Here you will get the animation you want
        }, completion: { _ in
            
            if self.hideAndShowView.isHidden == false{
                self.hideAndShowView.isHidden = true
                UIView.animateKeyframes(withDuration: 0.25, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: 7), animations: {
                    self.downView.frame.origin.y+=200
                },completion: nil)
                
            }
            
            else{
                self.hideAndShowView.isHidden = false
                UIView.animateKeyframes(withDuration: 0.25, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: 7), animations: {
                    self.downView.frame.origin.y-=200
                    self.hideAndShowView.alpha = 1
                },completion: nil)
            }// Here you hide it when animation done
          
            })

    }


    let locationManager = CLLocationManager()
    let regionInMeter: Double = 10000
    var previousLocation: CLLocation?
    
    
    @IBOutlet weak var menuButton: UIButton!
    
    
    @IBAction func gpsTouch(_ sender: Any) {
        startTracingUserLocation()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        checkLocationService()
       
        
    }
    
    
    
    func addAnnotation() {
        
        let usEmbassy = MKPointAnnotation() //23.7964822,90.4228446
        usEmbassy.coordinate = CLLocationCoordinate2D(latitude: 23.7964822, longitude: 90.4228446)
        mapView.addAnnotation(usEmbassy)
        
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
            
//            let usEmbassy = MKPointAnnotation() //23.7964822,90.4228446
//            usEmbassy.coordinate = CLLocationCoordinate2D(latitude: location+500, longitude: location+500)
//            usEmbassy.title = "US Embassy"
//            mapView.addAnnotation(usEmbassy)
            
           
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
//            addAnnotation()
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
        
//        let position = CLLocationCoordinate2D(latitude: 23.7964859, longitude: 90.4210676)
//        position.
//
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




    



