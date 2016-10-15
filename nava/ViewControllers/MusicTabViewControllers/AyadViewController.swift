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

    @IBOutlet weak var tblShahadatMusics: UITableView!
    var musicDataArray : [MusicObj] = []
    var mediaType = ServiceManager.ServiceMediaType.all
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ServiceManager.GetMediaList(mediaType: mediaType, serviceType: .eid, pageNo: 1) { (status, newMusics) in
            if status
            {
                self.musicDataArray = newMusics
                
                DispatchQueue.main.async {
                    self.tblShahadatMusics.reloadData()
                }
            }
        }
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
        return musicDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicCell") as! MusicTableViewCell
        
        let musicObj = musicDataArray[indexPath.row]
        
        cell.lblMusicName.text = musicObj.MusicName
        cell.lblSinger.text = musicObj.ArtistName
        cell.lblLikeCount.text = musicObj.Like
        cell.lblDownloadCount.text = musicObj.Download
        cell.lblMusicTime.text = musicObj.Time
        
        cell.imgMusicThumb.af_setImage(withURL: NSURL(string: musicObj.SmallpicUrl) as! URL)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let stb = UIStoryboard(name: "Main", bundle: nil)
        
        let musicPlayerViewController = stb.instantiateViewController(withIdentifier: "MusicPlayerViewController") as! MusicPlayerViewController
        musicPlayerViewController.musicObj = musicDataArray[indexPath.row]
        
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
