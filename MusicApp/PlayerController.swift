//
//  PlayerController.swift
//  MusicApp
//
//  Created by Digittrix-1 on 11/05/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit
import MediaPlayer

class PlayerController: UIViewController {
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalDurationLabel: UILabel!
    @IBOutlet weak var durationSlider: UISlider!
    @IBOutlet weak var playPauseButton: UIButton!
    
    var mediaItems = [MPMediaItem]()
    var indexToPlay: Int!
    var player = AppDelegate.shared().player
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (player.rate != 0 && player.error == nil) {
            print("playing")
            player.pause()
            currentTimeLabel.text = NSString(format: "0:00") as String
            let targetTime:CMTime = CMTimeMake(0, 1)
            player.seek(to: targetTime)
            player.rate=0.0
            durationSlider.value=0.0;
        }

        
        let song = mediaItems[indexToPlay]
        let url = song.value(forProperty: MPMediaItemPropertyAssetURL)
        let playerItem = AVPlayerItem(url: url! as! URL)
        player.replaceCurrentItem(with: playerItem)
       // player = AVPlayer(playerItem: playerItem)
        let duration : CMTime = player.currentItem!.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
        self.durationSlider.maximumValue = Float(seconds)
        let dur = String(format: "%2d:%2d", Int(Int(seconds)) / 60, Int(Int(seconds)) % 60)
        let totalDuration = dur as NSString
        totalDurationLabel.text = totalDuration as String
        print(totalDuration)
        player.play()
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: self.player.currentItem)
        playPauseButton.setTitle("PAUSE", for: .normal)
        player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if self.player.rate > 0 {
                self.durationSlider.value = Float(CMTimeGetSeconds(self.player.currentTime()))
                let currentTime : Int = Int(CMTimeGetSeconds(self.player.currentTime()))
                let minutes = currentTime/60
                let seconds = currentTime - minutes * 60
                self.currentTimeLabel.text = NSString(format: "%02d:%02d", minutes,seconds) as String
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    //MARK:- NextClicked
    @IBAction func playNext(_ sender: UIButton) {
        // player.skipToNextItem()
        print("indexToPlay is \(indexToPlay)")
        print("restr is \(mediaItems.count-1)")
        if indexToPlay == mediaItems.count-1 {
            
            
        }
        else {
            currentTimeLabel.text = NSString(format: "0:00") as String
            let targetTime:CMTime = CMTimeMake(0, 1)
            player.seek(to: targetTime)
            player.rate=0.0
            durationSlider.value=0.0;
            indexToPlay = indexToPlay+1
            print("indexToPlay is \(indexToPlay)")
            let song = mediaItems[indexToPlay]
            let url = song.value(forProperty: MPMediaItemPropertyAssetURL)
            let playerItem = AVPlayerItem(url: url! as! URL)
            player.replaceCurrentItem(with: playerItem)
            player.play()
            let duration : CMTime = player.currentItem!.asset.duration
            let seconds : Float64 = CMTimeGetSeconds(duration)
            self.durationSlider.maximumValue = Float(seconds)
            let dur = String(format: "%2d:%2d", Int(Int(seconds)) / 60, Int(Int(seconds)) % 60)
            let totalDuration = dur as NSString
            totalDurationLabel.text = totalDuration as String
            
        }
        
    }
    
    //MARK:- PreviousClicked
    @IBAction func playPrevious(_ sender: UIButton) {
        if indexToPlay == 0 {
            
            
        }
        else {
            currentTimeLabel.text = NSString(format: "0:00") as String
            player.rate=0.0
            durationSlider.value=0.0;
            indexToPlay = indexToPlay-1
            let song = mediaItems[indexToPlay]
            let url = song.value(forProperty: MPMediaItemPropertyAssetURL)
            let playerItem = AVPlayerItem(url: url! as! URL)
            player.replaceCurrentItem(with: playerItem)
            player.play()
            let duration : CMTime = player.currentItem!.asset.duration
            let seconds : Float64 = CMTimeGetSeconds(duration)
            self.durationSlider.maximumValue = Float(seconds)
            let dur = String(format: "%2d:%2d", Int(Int(seconds)) / 60, Int(Int(seconds)) % 60)
            let totalDuration = dur as NSString
            totalDurationLabel.text = totalDuration as String
            
        }
        
    }
    
    //MARK:- PlayPauseClicked
    @IBAction func playPauseClicked(_ sender: UIButton) {
        if playPauseButton.currentTitle == "PAUSE"  {
            player.pause()
            playPauseButton.setTitle("PLAY", for: .normal)
        }
        else {
            player.play()
            playPauseButton.setTitle("PAUSE", for: .normal)
        }
    }
    
    //MARK:- SliderValueChanged
    @IBAction func sliderChanged(_ sender: UISlider) {
        if (player.rate != 0 && player.error == nil) {
            
            //print("playing")
            player.pause()
            let seconds : Int64 = Int64(durationSlider.value)
            let targetTime:CMTime = CMTimeMake(seconds, 1)
            player.seek(to: targetTime)
            player.play()
        }
        else
        {
            let seconds1 : Int64 = Int64(durationSlider.value)
            let targetTime:CMTime = CMTimeMake(seconds1, 1)
            player.seek(to: targetTime)
            
            let currentTime : Int = Int(CMTimeGetSeconds(player.currentTime()))
            let minutes = currentTime/60
            let seconds = currentTime - minutes * 60
            currentTimeLabel.text = NSString(format: "%02d:%02d", minutes,seconds) as String
        }
    }
    
    func playerDidFinishPlaying(){
        print("finished")
        if indexToPlay == mediaItems.count-1 {
            currentTimeLabel.text = NSString(format: "0:00") as String
            player.rate=0.0
            durationSlider.value=0.0;
            
        }
        else {
            currentTimeLabel.text = NSString(format: "0:00") as String
            player.rate=0.0
            durationSlider.value=0.0;
            indexToPlay = indexToPlay+1
            let song = mediaItems[indexToPlay]
            let url = song.value(forProperty: MPMediaItemPropertyAssetURL)
            let playerItem = AVPlayerItem(url: url! as! URL)
            player.replaceCurrentItem(with: playerItem)
            player.play()
            let duration : CMTime = player.currentItem!.asset.duration
            let seconds : Float64 = CMTimeGetSeconds(duration)
            self.durationSlider.maximumValue = Float(seconds)
            let dur = String(format: "%2d:%2d", Int(Int(seconds)) / 60, Int(Int(seconds)) % 60)
            let totalDuration = dur as NSString
            totalDurationLabel.text = totalDuration as String
            
        }
        // playPauseButton.setImage(UIImage(named: "vplay"), for: .normal)
    }
    
    
    //MARK:- CloseClicked
    @IBAction func closeClicked(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
}
