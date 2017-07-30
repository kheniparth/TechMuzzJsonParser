//
//  ViewController.swift
//  TechMuzzJsonParser
//
//  Created by Parth Kheni on 28/07/17.
//  Copyright © 2017 Parth Kheni. All rights reserved.
//

import UIKit
import Alamofire

struct Post {
    let mainImage : UIImage!
    let name : String!
}

class TableViewController: UITableViewController {
    
    var posts = [Post]()
    var searchUrl = "https://api.spotify.com/v1/search?q=Imagine+Dragons&type=track"
    let headers = [
        "Authorization": "Bearer BQBNmIhnTrdid89TX4bZD0IVzcyk5IqDDYyisxp01J3Yvci8ZDbULQI9ljR_Lp2vD6_UArYTAk5ssswuBwn7Qt54Qz0Wny7ZEg1cHLjF2zM9UjCQ57k9HZ0wbG1srDzEHjB1uIelvgbeMALNUxBMFjVoq2xQf6SY1lxuLigiCoyF1i8Dky02V5T60N_udoCE_TPgixgEb2UND4lYtLBOWei-DkpD6JbZS4bRUKEWYij8zreWJEvDfmNxiKQC0xtgAtu8jxPWMXfZma3Gxd5a1TDi-3LPShiA6m0XOjQJ3Itu2LC6XyZdvIjkbSwVqWfbg3SeccXrdr4cCbWykh87wg",
        "Accept": "application/json"
    ]

    typealias JSONStandard = [String: AnyObject]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        callAlamo(url: searchUrl)
    }
    
    func callAlamo(url: String) {
        Alamofire.request(url, headers: headers).responseJSON(completionHandler: {
            response in
            self.parseData(JSONData: response.data!)
        })
    }
    
    func parseData(JSONData: Data) {
        do {
            let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
            if let tracks = readableJSON["tracks"] as? JSONStandard {
                if let items = tracks["items"] as? [JSONStandard] {
                    for i in 0..<items.count {
                        let item = items[i]
                        let name = item["name"] as! String
                        
                        if let album = item["album"] as? JSONStandard {
                            if let images = album["images"] as? [JSONStandard] {
                                let imageData = images[1]
                                let mainImageUrl = URL(string: imageData["url"] as! String)
                                let mainImageData = NSData(contentsOf: mainImageUrl!)
                                
                                let mainImage = UIImage(data: mainImageData as! Data)
                                
                                posts.append(Post.init(mainImage: mainImage, name: name))
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
        catch {
            print(error)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell")
        let mainImageView = cell?.viewWithTag(2) as! UIImageView
        mainImageView.image = posts[indexPath.row].mainImage
        let mainLabel = cell?.viewWithTag(1) as! UILabel
        mainLabel.text = posts[indexPath.row].name
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.tableView.indexPathForSelectedRow?.row
        let vc = segue.destination as! AudioVC
        
        vc.image = posts[indexPath!].mainImage
        vc.mainSongTitle = posts[indexPath!].name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

