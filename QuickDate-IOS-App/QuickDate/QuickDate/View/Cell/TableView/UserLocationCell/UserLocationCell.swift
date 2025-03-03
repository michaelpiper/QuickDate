//
//  UserLocationCell.swift
//  QuickDate
//
//  Created by Ubaid Javaid on 12/15/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class UserLocationCell: UITableViewCell, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK: - Views
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewlocationInfo: UIView!
    
    // MARK: - Properties
    var coordinate: Coordinate? {
        didSet {
            guard let coordinate = coordinate else {
                viewHeight.constant = 0
                addressLabel.text = "Unknown"
                self.viewlocationInfo.isHidden = true
                return
            }
            if coordinate.latitude == "0" {
                viewHeight.constant = 0
                addressLabel.text = "Unknown"
                self.viewlocationInfo.isHidden = true
            }else {
                viewHeight.constant = 110
                self.viewlocationInfo.isHidden = false
                configureLocation(with: coordinate)
            }
        }
    }
    
    private let manager: LocationManager = .shared
    let locationManager = CLLocationManager()
    let marker = GMSMarker()
    let geocoder = GMSGeocoder()
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.mapView.delegate = self
        self.locationManager.delegate = self
    }
    
    // MARK: - Private Functions
    private func configureLocation(with coordinate: Coordinate) {
        guard let latitude = Double(coordinate.latitude),
              let longitude = Double(coordinate.longitude) else {
            Logger.error("getting coordinate"); return
        }
        let geoCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let camera = GMSCameraPosition.camera(withTarget: geoCoordinate, zoom: 4.0)
        self.mapView.camera = camera
        self.marker.position = geoCoordinate
        DispatchQueue.main.async { [self] in
            manager.fetchLocation(with: coordinate) {  [weak self] (response: Result<String, LocationManager.LocationError>) in
                switch response {
                case .failure(let error):
                    Logger.error(error)
                    self?.addressLabel.text = "Unknown"
                case .success(let place):
                    self?.addressLabel.text = place
                }
            }
        }
        
        self.marker.title = "Trying"
        self.marker.snippet = "Trying"
        self.marker.map = self.mapView
        self.mapView.isUserInteractionEnabled = false
        
    }
}

extension UserLocationCell: NibReusable {}
