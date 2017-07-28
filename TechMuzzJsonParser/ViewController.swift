//
//  ViewController.swift
//  TechMuzzJsonParser
//
//  Created by Parth Kheni on 28/07/17.
//  Copyright © 2017 Parth Kheni. All rights reserved.
//

import UIKit
import Alamofire

class TableViewController: UITableViewController {
    
    var searchUrl = "https://api.spotify.com/v1/search?q=Imagine+Dragons&type=track"
    typealias JSONStandard = [String: AnyObject]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        callAlamo(url: searchUrl)
    }
    
    func callAlamo(url: String) {
        Alamofire.request(url).responseJSON(completionHandler: {
            response in
            self.parseData(JSONData: response.data!)
        })
    }
    
    func parseData(JSONData: Data) {
        do {
            var readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
            print(readableJSON)
        }
        catch {
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

