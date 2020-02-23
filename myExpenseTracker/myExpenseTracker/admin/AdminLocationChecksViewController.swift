//
//  AdminLocationChecksViewController.swift
//  MyExps
//
//  Created by Johnson Liu on 1/27/19.
//  Copyright © 2019 Home Office. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class AdminLocationChecksViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var textView: UITextView!
    
    let locationManager: CLLocationManager = CLLocationManager()
    
    var latitude: CLLocationDegrees = 0
    var longitude: CLLocationDegrees = 0
    
    //MARK: - init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        self.checkLocations()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didHaveFullAddress), name: NSNotification.Name(rawValue: Constant.kLocationCheckFullAddressNotification), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.mapView.layer.borderColor = UIColor.black.cgColor
        self.mapView.layer.borderWidth = 0.5
        
        self.textView.layer.borderColor = UIColor.black.cgColor
        self.textView.layer.borderWidth = 0.5
        
        self.textView.text = ""
    }
    
    //MARK: - IB actions
    
    @IBAction func gobackAction(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    //MARK - locations
    
    func checkLocations() {
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        self.latitude = locValue.latitude
        self.longitude = locValue.longitude
        self.locationManager.stopUpdatingLocation()
        
        DataManager.sharedInstance.locationLatitude = "\(self.latitude)"
        DataManager.sharedInstance.locationLongitude = "\(self.longitude)"
        
        print("-> latitude = \(self.latitude) | longitude = \(self.longitude) ")
        
        //-- map view: zoom in
        let center: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 400.0, longitudinalMeters: 400.0)
        self.mapView.setRegion(region, animated: true)
        
        //-- map view: add pin
        let annotation: MKPointAnnotation = MKPointAnnotation()
        annotation.coordinate = center
        self.mapView.addAnnotation(annotation)
        
        //-- convert to address
        if Reachability.isConnectedToNetwork() {
            DataManager.sharedInstance.checkDeviceLocation(latitude: self.latitude, longitude: self.longitude)
        }
        else {
            AlertManager.showAlert(title: UserManager.sharedInstance.noInternetAlertTitle, message: UserManager.sharedInstance.noInternetAlertMessage, controller: self)
        }
    }
    
    //MARK: - notifcation
    
    @objc func didHaveFullAddress() {
        
        DispatchQueue.main.async {
            let displayString: String = String(format: "\nLatitude: %@ \n\nLongitude: %@ \n\n\nStreet: %@ \n\nCity: %@\n\nState: %@\n\nZip Code: %@", DataManager.sharedInstance.locationLatitude, DataManager.sharedInstance.locationLongitude, DataManager.sharedInstance.locationStreet, DataManager.sharedInstance.locationCity, DataManager.sharedInstance.locationState, DataManager.sharedInstance.locationZipcode)
            self.textView.text = displayString
        }
    }
    
}
