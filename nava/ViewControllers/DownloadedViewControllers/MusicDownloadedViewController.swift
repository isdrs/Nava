//
//  MusicDownloadedViewController.swift
//  nava
//
//  Created by Mohsenian on 7/24/1395 AP.
//  Copyright © 1395 manshor. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MusicDownloadedViewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource {
    
    var downlodedMusic = [MediaItem]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        downlodedMusic = MediaManager.GetDBMedia(mediaType: .sound)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "موسیقی")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downlodedMusic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MediaCell") as! MediaTableViewCell
        
        let mediaItem = downlodedMusic[indexPath.row]
        
        cell.lblMusicName.text = mediaItem.MediaName
        cell.lblSinger.text = mediaItem.ArtistName
        cell.lblLikeCount.text = mediaItem.Like
        cell.lblDownloadCount.text = mediaItem.Download
        cell.lblMusicTime.text = mediaItem.Time
        
        cell.imgMusicThumb.af_setImage(withURL: NSURL(string: mediaItem.SmallpicUrl) as! URL)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let stb = UIStoryboard(name: "Main", bundle: nil)
        
        let musicPlayerViewController = stb.instantiateViewController(withIdentifier: "MusicPlayerViewController") as! MusicPlayerViewController
        musicPlayerViewController.mediaItem = downlodedMusic[indexPath.row]
        
        self.present(musicPlayerViewController, animated: true) {
            
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
