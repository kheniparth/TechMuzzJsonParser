//
//  AudioVC.swift
//  TechMuzzJsonParser
//
//  Created by Parth Kheni on 30/07/17.
//  Copyright © 2017 Parth Kheni. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class AudioVC : UIViewController {
    
    var image = UIImage()
    var mainSongTitle = String()
    var previewUrl = String()
    
    @IBOutlet var background: UIImageView!
    
    @IBOutlet var mainImageView: UIImageView!
    
    @IBOutlet var songTitle: UILabel!
    
    @IBOutlet var playPauseButton: UIButton!
    
    override func viewDidLoad() {
        
        songTitle.text = mainSongTitle
        background.image = image
        mainImageView.image = image
        playPauseButton.setTitle("Pause", for: .normal)
        playPauseButton.isHidden = false
        if previewUrl != "" {
            downloadFileFromUrl(url: URL(string: previewUrl)!)
        } else {
            playPauseButton.isHidden = true
            self.showToast(message: "No Preview URL...")
        }
    }
    
    func downloadFileFromUrl(url: URL) {
        var downloadTask = URLSessionDownloadTask()
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: {
            customURL, response, error in
            self.play(url: customURL!)
        })
        downloadTask.resume()
    }
    
    func play(url : URL) {
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.play()
        }
        catch {
            print(error)
        }
        
    }
    
    @IBAction func playPause(_ sender: Any) {
        if player.isPlaying {
            player.pause()
            playPauseButton.setTitle("Play", for: .normal)
        } else {
            player.play()
            playPauseButton.setTitle("Pause", for: .normal)
        }
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController){
            player.pause()
        }
    }
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }

}
