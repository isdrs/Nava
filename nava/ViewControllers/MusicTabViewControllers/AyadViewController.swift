//
//  ShahadatViewController.swift
//  nava
//
//  Created by Mohsenian on 7/18/1395 AP.
//  Copyright © 1395 manshor. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class AyadViewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource {

   private var tblAyadMedia: UITableView!
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
        tblAyadMedia.addSubview(refreshControl)
    }
    
    func LoadData()
    {
        ServiceManager.GetMediaList(mediaType: mediaType, serviceType: .eid, pageNo: 1) { (status, newMusics) in
            if status
            {
                self.mediaDataArray = newMusics
                
                DispatchQueue.main.async {
                    self.tblAyadMedia.reloadData()
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
        tblAyadMedia = UITableView()
        tblAyadMedia = UITableView(frame: .zero, style: .plain)
        tblAyadMedia.register(MediaCell.self, forCellReuseIdentifier: Tools.StaticVariables.cellReuseIdendifier)
        tblAyadMedia.rowHeight = MediaCell.cellHeight
        tblAyadMedia.backgroundColor = .black
        tblAyadMedia.dataSource = self
        tblAyadMedia.delegate = self
        tblAyadMedia.frame = self.view.frame
        tblAyadMedia.separatorStyle = .none
        tblAyadMedia.contentInset = UIEdgeInsetsMake(0, 0, 165, 0);
        self.view.addSubview(tblAyadMedia)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        
        return IndicatorInfo(title: "اعیاد")
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
        cell.DownloadCounterLabelText = mediaItem.Like
        cell.DownloadCounterLabelText = mediaItem.Download
        //cell.lblMusicTime.text = mediaItem.Time
        cell.musicImage.image = nil
        
        cell.musicImage.af_setImage(withURL: NSURL(string: mediaItem.LargpicUrl) as! URL)
        
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
