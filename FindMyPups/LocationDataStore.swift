//
//  LocationDataStore.swift
//  FindMyPups
//
//  Created by iD Student on 8/9/17.
//  Copyright © 2017 iD Tech. All rights reserved.
//

import Foundation
import CoreLocation

class LocationDataStore {
    
    var foursquareData : Set<FoursquareData> = []

    func fetchLocationsFromFoursquareWithCompletion(_ nearString : String, completion: @escaping (Bool) -> ()) {
        let parameter = ["client_id": Constant.Endpoints.clientID,
                         "client_secret": Constant.Endpoints.clientPassword,
                         "v": "20170808",
                         "near" : nearString,
//                         "ll": "\(ll.longitude),\(ll.latitude)",
                         //Change this later to the search bar
                        "query": "animal, park"]
        
        FoursquareAPIClient.getQueryForSearchLandmarks(parameter) { itemsJSON in
            guard let itemsArray = itemsJSON.0?.dictionary!["venues"]?.array else {
                print("error: no data recieved from API Client")
                completion(false)
                return
            }
            
            for venue in itemsArray {
                self.foursquareData.insert(FoursquareData(json: venue))
            }
            completion(true)
        }
    }
}
