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
    
    @IBOutlet weak var videoTbl: UITableView!
    
    var refreshControl : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.LoadData), for: UIControlEvents.valueChanged)
        videoTbl.addSubview(refreshControl)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MediaCell") as! MediaTableViewCell
        
        let mediaItem = downlodedVideo[indexPath.row]
        
        cell.lblMusicName.text = mediaItem.MediaName
        cell.lblSinger.text = mediaItem.ArtistName
        cell.lblLikeCount.text = mediaItem.Like
        cell.lblDownloadCount.text = mediaItem.Download
        cell.lblMusicTime.text = mediaItem.Time
        
        cell.imgMusicThumb.af_setImage(withURL: NSURL(string: mediaItem.SmallpicUrl) as! URL)
        
        return cell
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
