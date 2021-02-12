//
//  ViewController.swift
//  MapboxWithSideMenu
//
//  Created by ivan on 12.02.2021.
//

import UIKit
import Mapbox

class ViewController: UIViewController, MGLMapViewDelegate, CLLocationManagerDelegate {
    
    var mapView: MGLMapView!
    var locationManager = CLLocationManager()
    let sideMenuButton = UIButton()
    let userLocationButton = UIButton()
    var defaultPosition = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setupConstraints()
        userLocationButton.addTarget(self, action: #selector(showUserLocation), for: .touchUpInside)
        sideMenuButton.addTarget(self, action: #selector(showSideMenu), for: .touchUpInside)
    }
    
    @objc func showUserLocation() {
        guard let userLocation = mapView.userLocation?.coordinate else { return }
        mapView.setCenter(userLocation, zoomLevel: 15, animated: true)
    }
    
    @objc func showSideMenu() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        determineMyCurrentLocation()
    }
    
    func determineMyCurrentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0] as CLLocation
        
        if !defaultPosition {
            mapView.setCenter(userLocation.coordinate, zoomLevel: 15, animated: false)
            defaultPosition = true
        }
        manager.stopUpdatingLocation()
    }
}

extension ViewController {
    
    private func setupConstraints() {
        
        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        userLocationButton.setImage(#imageLiteral(resourceName: "refresh"), for:.normal)
        sideMenuButton.setImage(#imageLiteral(resourceName: "menu"), for:.normal)
        
        userLocationButton.translatesAutoresizingMaskIntoConstraints = false
        sideMenuButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mapView)
        view.addSubview(userLocationButton)
        view.addSubview(sideMenuButton)
        
        NSLayoutConstraint.activate([
            userLocationButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -200),
            userLocationButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -12),
            userLocationButton.heightAnchor.constraint(equalToConstant: 40),
            userLocationButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            sideMenuButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 50),
            sideMenuButton.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 12),
            sideMenuButton.heightAnchor.constraint(equalToConstant: 40),
            sideMenuButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}

