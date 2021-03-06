//
//  VideoDownloadedViewController.swift
//  nava
//
//  Created by Mohsenian on 7/24/1395 AP.
//  Copyright © 1395 manshor. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class VideoDownloadedViewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource, DownloadCellItemDelegate
{
    
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
        videoTbl.register(DownloadCellItem.self, forCellReuseIdentifier: Tools.StaticVariables.cellReuseIdendifier)
        videoTbl.rowHeight = DownloadCellItem.cellHeight
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Tools.StaticVariables.cellReuseIdendifier) as! DownloadCellItem
        
        let mediaItem = downlodedVideo[indexPath.row]
        
        cell.cellMedia = mediaItem
        
        cell.MusicTitleLabel = mediaItem.MediaName
        cell.SingerNameLabel = mediaItem.ArtistName
        cell.delegate = self
        //cell.time.text = mediaItem.Time
        
        cell.musicImage.af_setImage(withURL: NSURL(string: mediaItem.LargpicUrl) as! URL)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let stb = UIStoryboard(name: "Main", bundle: nil)
        

            let videoPlayerViewController = stb.instantiateViewController(withIdentifier: "VideoPlayerViewController") as! VideoPlayerViewController
            videoPlayerViewController.mediaItem = downlodedVideo[indexPath.row]
            
            self.present(videoPlayerViewController, animated: false) {
                
            }
        
        
        //self.navigationController?.pushViewController(musicPlayerViewController, animated: false)
    }
    
}
