//
//  Service.swift
//  Meteorites
//
//  Created by Adam Bezák on 21.4.17.
//  Copyright © 2017 Adam Bezák. All rights reserved.
//

import Foundation
import TRON
import SwiftyJSON
import RealmSwift

struct Service {
    
    let tron = TRON(baseURL: Constants.METEORITES_LINK + Constants.API_STR.removingPercentEncoding! + Constants.API_TOKEN.removingPercentEncoding!)
    
    static let sharedInstance = Service()
    
    class Meteorites: JSONDecodable {
        var meteorites: [Meteor]
        
        required init(json: JSON) throws {
            var meteorites = [Meteor]()
            
            for meteorJson in json.array! {
                let dateString = meteorJson["year"]
                if dateString != JSON.null {
                    let dateFormatter = DateFormatter()
                    
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS" //Your date format
                    dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")!
                    let date = dateFormatter.date(from: dateString.stringValue)
                    
                    if let compareDate = dateFormatter.date(from: "2011-01-01T00:00:00.000") {
                        if date! >= compareDate {
                            let meteor = Meteor()
                            meteor.date = date!
                            meteor.name = meteorJson["name"].stringValue
                            meteor.fall = meteorJson["fall"].stringValue
                            meteor.id = meteorJson["id"].intValue
                            meteor.reclong = meteorJson["reclong"].stringValue
                            meteor.reclat = meteorJson["reclat"].stringValue
                            meteor.mass = meteorJson["mass"].intValue
                            meteor.nametype = meteorJson["nametype"].stringValue
                            meteor.recclass = meteorJson["recclass"].stringValue
                            meteorites.append(meteor)
                        }
                    }
                }
            }
            self.meteorites = meteorites
        }
    }
    
    class JSONError: JSONDecodable {
        required init(json: JSON) throws {
            print("JSON error")
        }
    }
    
    func fetchData(completion: @escaping ([Meteor]) -> ()) {
        let request: APIRequest<Meteorites, JSONError> = tron.request("")
        request.perform(withSuccess: { (meteorites) in
            print(meteorites.meteorites.count)
            let manager = DataManager()
            
            for m in meteorites.meteorites {
                manager.add(meteor: m)
            }
            completion(meteorites.meteorites)
        }) { (err) in
            print("error", err)
        }
    }
    
}
