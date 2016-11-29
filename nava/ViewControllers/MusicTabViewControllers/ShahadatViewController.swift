//
//  ShahadatViewController.swift
//  nava
//
//  Created by Mohsenian on 7/18/1395 AP.
//  Copyright © 1395 manshor. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import AlamofireImage

class ShahadatViewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource {

    private var tblShahadatMusics : UITableView!
    
    var mediaDataArray : [MediaItem] = []
    var mediaType = NavaEnums.ServiceMediaType.all
    
    var refreshControl : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        SetTableView()
        

        
        LoadData()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.LoadData), for: UIControlEvents.valueChanged)
        tblShahadatMusics.addSubview(refreshControl)
    }
    
    func LoadData()
    {
        ServiceManager.GetMediaList(mediaType: mediaType, serviceType: .shahadat, pageNo: 1) { (status, newMusics) in
            if status
            {
                self.mediaDataArray = newMusics
                
                DispatchQueue.main.async {
                    self.tblShahadatMusics.reloadData()
                }
            }
            
            if self.refreshControl.isRefreshing
            {
                self.refreshControl.endRefreshing()
            }
        }
        
    }
    
    func SetTableView()
    {
        // set tableview properties
        tblShahadatMusics = UITableView()
        tblShahadatMusics = UITableView(frame: .zero, style: .plain)
        tblShahadatMusics.register(MediaCell.self, forCellReuseIdentifier: Tools.StaticVariables.cellReuseIdendifier)
        tblShahadatMusics.rowHeight = MediaCell.cellHeight
        tblShahadatMusics.backgroundColor = .black
        tblShahadatMusics.dataSource = self
        tblShahadatMusics.delegate = self
        tblShahadatMusics.frame = self.view.frame
        tblShahadatMusics.separatorStyle = .none
        tblShahadatMusics.contentInset = UIEdgeInsetsMake(0, 0, 165, 0);
        self.view.addSubview(tblShahadatMusics)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "شهادت")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: Tools.StaticVariables.cellReuseIdendifier) as! MediaCell
        
        let mediaItem = mediaDataArray[indexPath.row]
        
        cell.MusicTitleLabel = mediaItem.MediaName
        cell.SingerNameLabel = mediaItem.ArtistName
        cell.LikeCounterLabelText = mediaItem.Like
        cell.DownloadCounterLabelText = mediaItem.Download
       // cell.time.text = mediaItem.Time
        cell.musicImage.image = nil
        cell.musicImage.af_setImage(withURL: NSURL(string: mediaItem.LargpicUrl) as! URL)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let stb = UIStoryboard(name: "Main", bundle: nil)
        
        if mediaType == .sound
        {
            let musicPlayerViewController = stb.instantiateViewController(withIdentifier: "MusicPlayerViewController") as! MusicPlayerViewController
            
            let p = mediaDataArray[indexPath.row]
            
            if p.ArtistId == HomeViewController.mediaItem.ArtistId
            {
                HomeViewController.isCurrentMedia = true
            }
            else
            {
                HomeViewController.isCurrentMedia = false
            }
            
            HomeViewController.mediaItem = p
            
            
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
        
        
        
        //self.navigationController?.pushViewController(musicPlayerViewController, animated: false)
    }

   
}

