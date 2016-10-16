//
//  ShahadatViewController.swift
//  nava
//
//  Created by Mohsenian on 7/18/1395 AP.
//  Copyright © 1395 manshor. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class FavoritesViewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblFavoriteMedia: UITableView!
    var mediaDataArray : [MediaItem] = []
    var mediaType = ServiceManager.ServiceMediaType.all
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        ServiceManager.GetMediaList(mediaType: mediaType, serviceType: .shahadat, pageNo: 1) { (status, newMusics) in
//            if status
//            {
//                self.musicDataArray = newMusics
//                
//                DispatchQueue.main.async {
//                    self.tblFavoriteMedia.reloadData()
//                }
//            }
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "علاقه مندی ها")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MediaCell") as! MediaTableViewCell
        
        let mediaItem = mediaDataArray[indexPath.row]
        
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
        musicPlayerViewController.mediaItem = mediaDataArray[indexPath.row]
        
        self.present(musicPlayerViewController, animated: false) {
            
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
