//
//  ViewController.swift
//  MusicApp
//
//  Created by Digittrix-1 on 11/05/17.
//  Copyright © 2017 Mahesh. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit

class ViewController: UIViewController, MPMediaPickerControllerDelegate, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var musicLibraryTable: UITableView!
    var mediaItems = [MPMediaItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
                
        //setCategory(AVAudioSessionCategoryPlayback, error: nil)

        musicLibraryTable.delegate = self
        musicLibraryTable.dataSource = self
        musicLibraryTable.tableFooterView = UIView()
        
        // All
        self.checkMediaLibraryPermissions()
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- CheckConnections
    func checkMediaLibraryPermissions() {
        MPMediaLibrary.requestAuthorization({(_ status: MPMediaLibraryAuthorizationStatus) -> Void in
            switch status {
            case .notDetermined: break
            // not determined
            case .restricted: break
            // restricted
            case .denied: break
            // denied
            case .authorized:
            // authorized
            self.fetchSongs()
            break
            }
        })
    }

    
    func fetchSongs()  {
        self.mediaItems = MPMediaQuery.songs().items!
        if self.mediaItems.count > 0 {
            
            let label = UILabel(frame:self.musicLibraryTable.frame)
            label.center = self.musicLibraryTable.center
            label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
            label.text = "No Music Files Found"
            label.textColor = UIColor.darkGray
            label.textAlignment = .center
        }
        else {
            
        }
        self.musicLibraryTable.reloadData()

    }
    //MARK:- MediaPicker Delegate
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        //User selected a/an item(s).
        for mpMediaItem in mediaItemCollection.items {
            print("Add \(mpMediaItem) to a playlist, prep the player, etc.")
        }
    }
 
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        print("User selected Cancel tell me what to do")
        mediaPicker.dismiss(animated: true , completion: nil)
    }

    //MARK: TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "music")
        cell?.selectionStyle = .none
        let nameLabel = cell?.viewWithTag(10) as! UILabel
        if mediaItems.count > 0 {
            let currentItem = mediaItems[indexPath.row]
              nameLabel.text = currentItem.title
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let  screen = self.storyboard?.instantiateViewController(withIdentifier: "PlayerController") as! PlayerController
        screen.mediaItems = mediaItems
        screen.indexToPlay = Int(indexPath.row)
        present(screen, animated: true, completion: nil)
    }

    //MARK:- ViewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

