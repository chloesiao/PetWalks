//
//  FourSquareAPIClient.swift
//  FindMyPups
//
//  Created by iD Student on 8/8/17.
//  Copyright © 2017 iD Tech. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON
import Alamofire

struct FoursquareConstants {
    static let v = "20170808"
    //date that it was made
    static let query = "animal,park"
    //query = categories
}

class FoursquareAPIClient {
    
    class func getQueryForSearchLandmarks(_ parameter: [String: String], completion: @escaping (JSON?, Error?) -> ()) {
        //added @escaping so that there was no escaping parameter for completion
        Alamofire.request(Constant.Endpoints.FOURSQUARE_GET_VENUES, parameters: parameter, headers: nil).responseJSON { response in
            guard let data = response.data, let responseJSON = JSON(data: data).dictionary?["response"]
                else {
                    completion(nil,response.result.error)
                    return
            }
            completion(responseJSON, nil)
        }
    }
}
