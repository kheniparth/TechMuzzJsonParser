//
//  ViewController.swift
//  TechMuzzJsonParser
//
//  Created by Parth Kheni on 28/07/17.
//  Copyright © 2017 Parth Kheni. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

var player = AVAudioPlayer()

struct Post {
    let mainImage : UIImage!
    let name : String!
    let previewUrl : String!
}

class TableViewController: UITableViewController, UISearchBarDelegate {
        
    var posts = [Post]()
    var searchUrl = "https://api.spotify.com/v1/search?q=Imagine+Dragons&type=track"
    let headers = [
        "Authorization": "Bearer BQCzZMUotB9oYP6orcmeje79ly6ql1P6UOuM5oIHtiMPqe4lfRR96wbiU57ASbyPzZlwQ2sItzCZtHwvj5XDi7aebPRUhRZk0XS_HHEFWxkKAacFYAPfE3RfnxKxqrFISCchESIka_Ia0gZKsLT_HppltHI94qZNCn5Hh4B4nwaqO8H9lr6vHuGWjFmAUfPU-DYKRonnPbV-xJOkarG28BKh46Sdo_cOzvi1yDyaNXT3oRXX5NtErN3Ot-VXK9OvkfWzJGnOviCb508yxYFCTAwb7WFLwxwWiGeWvo341ejEFG8h8NiH2CWcKxLsbZjKeZVDgVInfIm-9iqLRgz9ZQ",
        "Accept": "application/json"
    ]

    @IBOutlet var searchBar: UISearchBar!
    typealias JSONStandard = [String: AnyObject]
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keywords = searchBar.text
        let finalKeywords = keywords?.replacingOccurrences(of: " ", with: "+")
        searchUrl = "https://api.spotify.com/v1/search?q=\(finalKeywords!)&type=track"
        callAlamo(url: searchUrl)
        self.view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        callAlamo(url: searchUrl)
    }
    
    func callAlamo(url: String) {
        Alamofire.request(url, headers: headers).responseJSON(completionHandler: {
            response in
            self.posts.removeAll()
            self.tableView.reloadData()
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
                        let previewUrl = item["preview_url"] as? String == nil ? "" : item["preview_url"] as! String
                        
                        if let album = item["album"] as? JSONStandard {
                            if let images = album["images"] as? [JSONStandard] {
                                let imageData = images[1]
                                let mainImageUrl = URL(string: imageData["url"] as! String)
                                let mainImageData = NSData(contentsOf: mainImageUrl!)
                                
                                let mainImage = UIImage(data: mainImageData as! Data)
                                
                                posts.append(Post.init(mainImage: mainImage, name: name, previewUrl: previewUrl))
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
        vc.previewUrl = posts[indexPath!].previewUrl
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

