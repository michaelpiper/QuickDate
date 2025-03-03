//
//  GetAddress.swift
//  QuickDate
//
//  Created by iMac on 20/10/22.
//  Copyright © 2022 ScriptSun. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class GetMapAddress {
    class func getAddress(selectedLat: Double, selectedLon: Double, completion : @escaping (String?) -> Void) {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: selectedLat, longitude: selectedLon)
        //selectedLat and selectedLon are double values set by the app in a previous process
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            if placeMark == nil { return }
            // Location name
            if let locationName = placeMark.addressDictionary!["Name"] as? String {
                //print(locationName)
            }
            
            // Street address
            if let street = placeMark.addressDictionary!["Thoroughfare"] as? String {
                //print(street)
            }
            
            // City
            if let city = placeMark.addressDictionary!["City"] as? String {
                //print(city)
                completion(city)
            }
            
            // Zip code
            if let zip = placeMark.addressDictionary!["ZIP"] as? String {
                //print(zip)
            }
            
            // Country
            if let country = placeMark.addressDictionary!["Country"] as? String {
                //print(country)
                completion(country)
            }
        })
    }
}
