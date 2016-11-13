//
//  VideoDownloadedViewController.swift
//  nava
//
//  Created by Mohsenian on 7/24/1395 AP.
//  Copyright © 1395 manshor. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class VideoDownloadedViewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource {
    
    var downlodedVideo = [MediaItem]()
    
    private var videoTbl: UITableView!
    
    var refreshControl : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        SetTableView()
        
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.LoadData), for: UIControlEvents.valueChanged)
        videoTbl.addSubview(refreshControl)
    }
    
    func SetTableView()
    {
        // set tableview properties
        videoTbl = UITableView()
        videoTbl = UITableView(frame: .zero, style: .plain)
        videoTbl.register(MediaCell.self, forCellReuseIdentifier: Tools.StaticVariables.cellReuseIdendifier)
        videoTbl.rowHeight = MediaCell.cellHeight
        videoTbl.backgroundColor = .black
        videoTbl.dataSource = self
        videoTbl.delegate = self
        videoTbl.frame = self.view.frame
        videoTbl.separatorStyle = .none
        videoTbl.contentInset = UIEdgeInsetsMake(0, 0, 165, 0);
        self.view.addSubview(videoTbl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if self.refreshControl.isRefreshing
        {
            self.refreshControl.endRefreshing()
        }
        
        LoadData()
    }
    
       func  LoadData()
    {
        downlodedVideo = MediaManager.GetDBMedia(mediaType: .video)
        videoTbl.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "ویدئو")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downlodedVideo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Tools.StaticVariables.cellReuseIdendifier) as! MediaCell
        
        let mediaItem = downlodedVideo[indexPath.row]
        
        cell.MusicTitleLabel = mediaItem.MediaName
        cell.SingerNameLabel = mediaItem.ArtistName
        cell.LikeCounterLabelText = mediaItem.Like
        cell.DownloadCounterLabelText = mediaItem.Download
        //cell.time.text = mediaItem.Time
        
        cell.musicImage.af_setImage(withURL: NSURL(string: mediaItem.SmallpicUrl) as! URL)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let stb = UIStoryboard(name: "Main", bundle: nil)
        

            let videoPlayerViewController = stb.instantiateViewController(withIdentifier: "VideoPlayerViewController") as! VideoPlayerViewController
            videoPlayerViewController.mediaItem = downlodedVideo[indexPath.row]
            
            self.present(videoPlayerViewController, animated: false) {
                
            }
        
        
        //self.navigationController?.pushViewController(musicPlayerViewController, animated: false)
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
