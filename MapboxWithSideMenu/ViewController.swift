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
    var isActiveSideMenu = false
    
    override var prefersStatusBarHidden: Bool {
        return isHiddenStatusBar ? true : false
        }
    
    var isHiddenStatusBar = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupConstraints()
        userLocationButton.addTarget(self, action: #selector(showUserLocation), for: .touchUpInside)
        sideMenuButton.addTarget(self, action: #selector(showSideMenu), for: .touchUpInside)
    }
    
    func toggleAppearance() {
        isHiddenStatusBar.toggle()
    }
    
    @objc func showUserLocation() {
        guard let userLocation = mapView.userLocation?.coordinate else { return }
        mapView.setCenter(userLocation, zoomLevel: 15, animated: true)
    }
    
    @objc func showSideMenu() {
        let modalController = ModalViewController()
        modalController.modalPresentationStyle = .custom
        modalController.transitioningDelegate = self
        modalController.isModalInPresentation = false
        
        present(modalController, animated: true, completion: nil)
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

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension ViewController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        toggleAppearance()
        isActiveSideMenu.toggle()
        if isActiveSideMenu {
            UIView.animate(withDuration: 0.3) {
                self.mapView.alpha = 0.5
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.mapView.alpha = 1
            }
        }
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.viewController(forKey: .from)?.view,
              let toView = transitionContext.viewController(forKey: .to)?.view else {
            return
        }
        
        let isPresenting = (fromView == view)
        
        let presentingView = isPresenting ? toView : fromView
        
        if isPresenting {
            transitionContext.containerView.addSubview(presentingView)
        }
        
        let size = CGSize(width: UIScreen.main.bounds.size.width / 1,
                          height: UIScreen.main.bounds.size.height)
        
        let offScreenFrame = CGRect(origin: CGPoint(x: -size.width, y: 0), size: size)
        let onScreenFrame = CGRect(origin: .zero, size: size)
        
        presentingView.frame = isPresenting ? offScreenFrame : onScreenFrame
        
        let animationDuration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: animationDuration) {
            presentingView.frame = isPresenting ? onScreenFrame : offScreenFrame
        } completion: { isSuccess in
            if !isPresenting {
                presentingView.removeFromSuperview()
            }
            transitionContext.completeTransition(isSuccess)
        }
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

