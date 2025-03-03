//
//  LocationManager.swift
//  QuickDate
//
//  Created by Nazmi Yavuz on 25.01.2022.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation
import GoogleMaps
import CoreLocation

final class LocationManager {
    // Instance
    static let shared = LocationManager()
    
    enum LocationError: Error {
        case fetchFailed(Error)
        case unknown
    }

    private init() {}
    
    // 3
    func fetchLocation(with coordinate: Coordinate,
                       completion: @escaping(Result<String, LocationError>) -> Void) {
        
        guard let latitude = Double(coordinate.latitude),
              let longitude = Double(coordinate.longitude) else {
                  Logger.error("getting coordinate")
                  completion(.failure(LocationError.unknown))
                  return
              }
        let geoCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(geoCoordinate) { response, error in
            if let error = error {
                completion(.failure(LocationError.fetchFailed(error)))
            } else if let places = response?.results() {
                let place = places.first
                let location = self.getPlaceName(city: place?.locality, country: place?.country)
                completion(.success(location))
            }
        }
    }
    
    // MARK: - Private Functions
    // 1
    private func getPlaceName(city: String?, country: String?) -> String {
        switch (city, country) {
        case let (city?, country?): return "\(city), \(country)"
        case let (city?, nil):      return city
        case let (nil, country?):   return country
        default: return "Unknown"
        }
    }
    // 2
    private func setLocationName(coordinate: CLLocationCoordinate2D, completion: @escaping(String) -> Void) {
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let error = error {
                Logger.error(error); return
            } else if let places = response?.results() {
                let place = places.first
                let location = self.getPlaceName(city: place?.locality, country: place?.country)
                completion(location)
            }
        }
    }
}
