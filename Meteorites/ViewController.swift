//
//  ViewController.swift
//  Meteorites
//
//  Created by Adam Bezák on 21.4.17.
//  Copyright © 2017 Adam Bezák. All rights reserved.
//

import UIKit
import TRON
import SwiftyJSON

class ViewController: UIViewController {

    let tron = TRON(baseURL: Constants.METEORITES_LINK + Constants.API_STR.removingPercentEncoding! + Constants.API_TOKEN.removingPercentEncoding!)
    
    class Meteorites: JSONDecodable {
        required init(json: JSON) throws {
            for meteor in json.array! {
                let dateString = meteor["year"]
                if dateString != JSON.null {
                    let dateFormatter = DateFormatter()
                    
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS" //Your date format
                    dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")!
                    let date = dateFormatter.date(from: dateString.stringValue)

                    if let compareDate = dateFormatter.date(from: "2011-01-01T00:00:00.000") {
                        if date! >= compareDate {
                            print(date)
                        }
                    }
                }
            }
        }
    }
    
    class JSONError: JSONDecodable {
        required init(json: JSON) throws {
            print("JSON error")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchJson()
    }

    fileprivate func fetchJson() {

        let request: APIRequest<Meteorites, JSONError> = tron.request("")
        request.perform(withSuccess: { (meteorites) in
            print("succesfully fetchec")
        }) { (err) in
            print("error", err)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

