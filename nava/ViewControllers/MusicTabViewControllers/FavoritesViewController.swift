//
//  ShahadatViewController.swift
//  nava
//
//  Created by Mohsenian on 7/18/1395 AP.
//  Copyright © 1395 manshor. All rights reserved.
//

import UIKit
import XLPagerTabStrip



class FavoritesViewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource, FavoriteCellItemDelegate {
    
    private var tblFavoriteMedia: UITableView!
    var mediaDataArray : [MediaItem] = []
    var mediaType = NavaEnums.ServiceMediaType.all
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        SetTableView()
        
        LoadData()
    }
    
    func LoadData()
    {
        mediaDataArray = MediaManager.GetFavoriteMedia(mediaType: mediaType)
        DispatchQueue.main.async
            {
                self.tblFavoriteMedia.reloadData()
        }
    }
    
    func SetTableView()
    {
        // set tableview properties
        tblFavoriteMedia = UITableView()
        tblFavoriteMedia = UITableView(frame: .zero, style: .plain)
        tblFavoriteMedia.register(FavoriteCellItem.self, forCellReuseIdentifier: Tools.StaticVariables.cellReuseIdendifier)
        tblFavoriteMedia.rowHeight = FavoriteCellItem.cellHeight
        tblFavoriteMedia.backgroundColor = .black
        tblFavoriteMedia.dataSource = self
        tblFavoriteMedia.delegate = self
        tblFavoriteMedia.frame = self.view.frame
        tblFavoriteMedia.separatorStyle = .none
        tblFavoriteMedia.contentInset = UIEdgeInsetsMake(0, 0, 165, 0);
        self.view.addSubview(tblFavoriteMedia)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "علاقه مندی")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Tools.StaticVariables.cellReuseIdendifier) as! FavoriteCellItem
        
        let mediaItem = mediaDataArray[indexPath.row]
        
        cell.cellMedia = mediaItem
        
        cell.MusicTitleLabel = mediaItem.MediaName
        cell.SingerNameLabel = mediaItem.ArtistName
        
        //cell.time.text = mediaItem.Time
        cell.musicImage.image = nil
        
        cell.musicImage.af_setImage(withURL: NSURL(string: mediaItem.LargpicUrl) as! URL)
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let stb = UIStoryboard(name: "Main", bundle: nil)
        
        if mediaType == .sound
        {
            let musicPlayerViewController = stb.instantiateViewController(withIdentifier: "MusicPlayerViewController") as! MusicPlayerViewController
            HomeViewController.mediaItem = mediaDataArray[indexPath.row]
            
            self.present(musicPlayerViewController, animated: false) {
                
            }
        }
        else
        {
            let videoPlayerViewController = stb.instantiateViewController(withIdentifier: "VideoPlayerViewController") as! VideoPlayerViewController
            videoPlayerViewController.mediaItem = mediaDataArray[indexPath.row]
            
            self.present(videoPlayerViewController, animated: false) {
                
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
