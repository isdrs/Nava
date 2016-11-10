//
//  ShahadatViewController.swift
//  nava
//
//  Created by Mohsenian on 7/18/1395 AP.
//  Copyright © 1395 manshor. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MoharramViewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource {

    private var tblMoharramMedia : UITableView!
    
    var mediaDataArray : [MediaItem] = []
    var mediaType = NavaEnums.ServiceMediaType.all
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        SetTableView()
    }
    
    func SetTableView()
    {
        // set tableview properties
        tblMoharramMedia = UITableView()
        tblMoharramMedia = UITableView(frame: .zero, style: .plain)
        tblMoharramMedia.register(MediaCell.self, forCellReuseIdentifier: Tools.StaticVariables.cellReuseIdendifier)
        tblMoharramMedia.rowHeight = MediaCell.cellHeight
        tblMoharramMedia.backgroundColor = .black
        tblMoharramMedia.dataSource = self
        tblMoharramMedia.delegate = self
        tblMoharramMedia.frame = self.view.frame
        tblMoharramMedia.separatorStyle = .none
        self.view.addSubview(tblMoharramMedia)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ServiceManager.GetMediaList(mediaType: mediaType, serviceType: .moharam, pageNo: 1) { (status, newMusics) in
            if status
            {
                self.mediaDataArray = newMusics
                
                DispatchQueue.main.async {
                    self.tblMoharramMedia.reloadData()
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "محرم")
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
        //cell.time.text = mediaItem.Time
        
        cell.musicImage.af_setImage(withURL: NSURL(string: mediaItem.SmallpicUrl) as! URL)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let stb = UIStoryboard(name: "Main", bundle: nil)
        
        if mediaType == .sound
        {
            let musicPlayerViewController = stb.instantiateViewController(withIdentifier: "MusicPlayerViewController") as! MusicPlayerViewController
            musicPlayerViewController.mediaItem = mediaDataArray[indexPath.row]
            
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
