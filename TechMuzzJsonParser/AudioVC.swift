//
//  AudioVC.swift
//  TechMuzzJsonParser
//
//  Created by Parth Kheni on 30/07/17.
//  Copyright © 2017 Parth Kheni. All rights reserved.
//

import Foundation
import UIKit

class AudioVC : UIViewController {
    
    var image = UIImage()
    var mainSongTitle = String()
    
    @IBOutlet var background: UIImageView!
    
    @IBOutlet var mainImageView: UIImageView!
    
    @IBOutlet var songTitle: UILabel!
    
    override func viewDidLoad() {
        
        songTitle.text = mainSongTitle
        background.image = image
        mainImageView.image = image
    }
}
