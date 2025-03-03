//
//  AppLocationManager.swift
//  QuickDate
//
//  Created by iMac on 27/10/22.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import LocalAuthentication

class AppLocationManager: NSObject {
    static let shared = AppLocationManager()
    var locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    private var onLocationUpdateHandler: ((CLLocationCoordinate2D) -> ())?
    private var onLocationAccessCompletion: ((Bool) -> ())?
    private var forceForLocationPermission = false
    
    override init() {
        super.init()
        setupLocationManager()
        addNotificationObservers()
    }
    
    deinit {
        removeNotificationObservers()
        stopLocationUpdate()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .other
    }
    
    private func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(onApplicationWillEnterForegroundNotification), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    private func removeNotificationObservers() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    func requestLocationServiceIfNeed(force: Bool, completionHandler: @escaping ((Bool) -> ())) {
        onLocationAccessCompletion = completionHandler
        forceForLocationPermission = force
        checkForLocationServicePermission()
    }
    
    func requestUserLocationServiceIfNeed(completionHandler: @escaping ((Bool) -> ())) {
        onLocationAccessCompletion = completionHandler
        checkForUserLocationServicePermission()
    }
    
    func isLocationPermissionGiven() -> Bool {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            return false
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        case .denied, .restricted:
            return false
        @unknown default:
            break
        }
        return false
    }
    
    private func checkForLocationServicePermission() {
        DispatchQueue.main.async {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                self.locationManager.requestWhenInUseAuthorization()
            case .authorizedAlways, .authorizedWhenInUse:
                self.onLocationAccessCompletion?(true)
            case .denied, .restricted:
                self.onLocationAccessCompletion?(false)
                if self.forceForLocationPermission {
                    Utility.showAlertForAppSettings(title: "We Can't Get Your Location", message: "To enable location service, you need to allow location service for this application from settings.", allowCancel: false) { (completed) in
                    }
                }
            @unknown default:
                break
            }
        }
        
    }
    
    private func checkForUserLocationServicePermission() {
        DispatchQueue.main.async {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                self.locationManager.requestWhenInUseAuthorization()
            case .authorizedAlways, .authorizedWhenInUse:
                self.onLocationAccessCompletion?(true)
            case .denied, .restricted:
                self.onLocationAccessCompletion?(false)
                Utility.showAlertForAppSettings(title: "We Can't Get Your Location", message: "To enable location service, you need to allow location service for this application from settings.", allowCancel: true) { (completed) in
                }
                
            @unknown default:
                break
            }
        }
        
    }
    
    func startLocationUpdate(onLocationUpdate: @escaping ((CLLocationCoordinate2D) -> ())) {
        onLocationUpdateHandler = onLocationUpdate
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdate() {
        locationManager.stopUpdatingLocation()
        onLocationAccessCompletion = nil
        forceForLocationPermission = false
    }
   
    // MARK: - NotificationCenter events
    @objc private func onApplicationWillEnterForegroundNotification() {
        if forceForLocationPermission {
            checkForLocationServicePermission()
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension AppLocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkForLocationServicePermission()
        guard status == .authorizedWhenInUse || status == .authorizedAlways else {
            return
        }
        currentLocation = manager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        if !(location.coordinate.latitude == currentLocation.latitude && location.coordinate.longitude == currentLocation.longitude) {
            currentLocation = location.coordinate
            onLocationUpdateHandler?(currentLocation)
        }
    }
}


class Utility {
    
    // MARK: - Variables
    static let shared = Utility()
    
    class func showAlertForAppSettings(title: String, message: String, allowCancel: Bool = true, completion: @escaping (Bool) -> ()) {
        let alertWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        
        let alertController: UIAlertController = UIAlertController(title: NSLocalizedString(title, comment: ""), message: NSLocalizedString(message, comment: ""), preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default, handler: { (action) -> Void in
            
            alertWindow.isHidden = true
            
            let settingURL = URL(string: UIApplication.openSettingsURLString)!
            
            if(UIApplication.shared.canOpenURL(settingURL)) {
                UIApplication.shared.open(settingURL, options: [:], completionHandler: nil)
            }
            
            completion(false)
            
        }))
        
        if allowCancel {
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { (action) -> Void in
                
                alertWindow.isHidden = true
                completion(false)
                
            }))
        }
        
        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
