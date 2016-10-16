//
//  MusicPlayerViewController.swift
//  nava
//
//  Created by Mohsenian on 7/19/1395 AP.
//  Copyright © 1395 manshor. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer
import Jukebox
import AlamofireImage
import SCLAlertView_Objective_C

class MusicPlayerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, JukeboxDelegate {

    var mediaItem : MediaItem!
    private var singerMediaItems : [MediaItem] = [MediaItem]()
    @IBOutlet weak var tblSingerMedia: UITableView!
    
    
    @IBOutlet weak var viwPlayerController: UIView!
    @IBOutlet weak var lblMusicTotalTime: UILabel!
    @IBOutlet weak var lblMusicCurrentTime: UILabel!
    @IBOutlet weak var slrMusicDuration: UISlider!
    @IBOutlet weak var lblMusicName: UILabel!
    @IBOutlet weak var lblSinger: UILabel!
    @IBOutlet weak var imgMusicImage: UIImageView!
    @IBOutlet weak var btnLikeOutlet: UIButton!
    @IBOutlet weak var btnDownloadOutlet: UIButton!
    @IBOutlet weak var btnPlayPause: UIButton!
    
    var jukebox : Jukebox!
    
    @IBAction func LikeAction(_ sender: AnyObject)
    {
        
    }
   
    @IBAction func DownloadAction(_ sender: AnyObject)
    {
        btnDownloadOutlet.isEnabled = false
        
        ServiceManager.DownloadMedia(mediaItem: mediaItem) { (status) in
            if status
            {
                SCLAlertView().showSuccess("دانلود", subTitle: "موفقیت آمیز بود", closeButtonTitle: "تایید", duration: 1.0)
                
                self.btnDownloadOutlet.isHidden = true
            }
            else
            {
                self.btnDownloadOutlet.isEnabled = true
            }
        }
    }
    
    @IBAction func MusicSliderValueChange(_ sender: AnyObject)
    {
        if let duration = jukebox.currentItem?.meta.duration
        {
            jukebox.seek(toSecond: Int(Double(slrMusicDuration.value) * duration))
        }
    }
    @IBAction func NextTrack(_ sender: AnyObject)
    {
        jukebox.playNext()
    }
    
    @IBAction func PlayTrack(_ sender: AnyObject)
    {
        switch jukebox.state {
        case .ready :
            jukebox.play(atIndex: 0)
        case .playing :
            jukebox.pause()
        case .paused :
            jukebox.play()
        default:
            jukebox.stop()
        }
    }

    @IBAction func PrevTrack(_ sender: AnyObject)
    {
        if let time = jukebox.currentItem?.currentTime, time > 5.0 || jukebox.playIndex == 0 {
            jukebox.replayCurrentItem()
        } else {
            jukebox.playPrevious()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        // begin receiving remote events
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        LoadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ServiceManager.GetMediaListByArtist(mediaItem: mediaItem, mediaType: .sound, serviceType: mediaItem.MediaServiceType, pageNo: 1) { (status, newMedia) in
            if status
            {
                self.singerMediaItems = newMedia
                
                DispatchQueue.main.async {
                    self.tblSingerMedia.reloadData()
                }
            }
        }
    }
    
    private func LoadData()
    {
        var currentMedia : JukeboxItem
        
        if let myMedia = MediaManager.IsDownloadedMedia(mediaItem: mediaItem)
        {
            mediaItem = myMedia
            
            btnDownloadOutlet.isHidden = true
            
            let path = Bundle.main.path(forResource: "." + mediaItem.MediaID, ofType: "mp3", inDirectory: "MyMedia")
            
            currentMedia = JukeboxItem(URL: URL(string: path!)!)
        }
        else
        {
            currentMedia = JukeboxItem(URL: URL(string: mediaItem.MediaUrl)!)
            
            btnDownloadOutlet.isHidden = false
        }
        
        if MediaManager.IsLikedMedia(mediaItem: mediaItem) {
            
            btnLikeOutlet.setImage(UIImage(named: "Like"), for: .normal)
        }
        else
        {
           btnLikeOutlet.setImage(UIImage(named: "UnLike"), for: .normal)
        }
        
        let musicUrl = URL(string: mediaItem.MediaUrl)
        
        jukebox = Jukebox(delegate: self, items: [currentMedia])
        
        let imageUrl = URL(string: mediaItem.LargpicUrl)
        
        imgMusicImage.af_setImage(withURL: imageUrl!)
        
        jukebox.play()
    }
    
    func configureUI ()
    {
        resetUI()
        
        let color = UIColor(red:0.84, green:0.09, blue:0.1, alpha:1)
        
        //slrMusicDuration.setThumbImage(UIImage(named: "sliderThumb"), for: UIControlState())
        slrMusicDuration.minimumTrackTintColor = color
        slrMusicDuration.maximumTrackTintColor = UIColor.white
        
        lblMusicName.text = mediaItem.MediaName
        lblSinger.text = mediaItem.ArtistName
    }
    
    func resetUI()
    {
        lblMusicTotalTime.text = "00:00"
        lblMusicCurrentTime.text = "00:00"
        slrMusicDuration.value = 0
    }
    
    func populateLabelWithTime(_ label : UILabel, time: Double) {
        let minutes = Int(time / 60)
        let seconds = Int(time) - minutes * 60
        
        label.text = String(format: "%02d", minutes) + ":" + String(format: "%02d", seconds)
    }
    
    // MARK:- JukeboxDelegate -
    
    func jukeboxDidLoadItem(_ jukebox: Jukebox, item: JukeboxItem) {
        print("Jukebox did load: \(item.URL.lastPathComponent)")
    }
    
    func jukeboxPlaybackProgressDidChange(_ jukebox: Jukebox) {
        
        print("currentTime:  \(jukebox.currentItem?.currentTime)")
        
        print("duration:  \(jukebox.currentItem?.meta.duration)")
                
        if let currentTime = jukebox.currentItem?.currentTime, let duration = mediaItem.TimeDouble//jukebox.currentItem?.meta.duration
        {
            let value = Float(currentTime / duration)
            slrMusicDuration.value = value
            populateLabelWithTime(lblMusicCurrentTime, time: currentTime)
            populateLabelWithTime(lblMusicTotalTime, time: duration)
        }
        else
        {
            resetUI()
        }
    }
    
    func jukeboxStateDidChange(_ jukebox: Jukebox) {
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.btnPlayPause.alpha = jukebox.state == .loading ? 0 : 1
            self.btnPlayPause.isEnabled = jukebox.state == .loading ? false : true
        })
        
        if jukebox.state == .ready
        {
            btnPlayPause.setImage(UIImage(named: "Play"), for: .normal)
        }
        else if jukebox.state == .loading
        {
            btnPlayPause.setImage(UIImage(named: "Pause"), for: .normal)
        }
        else
        {
            let imageName: String
            switch jukebox.state
            {
            case .playing, .loading:
                imageName = "Pause"
            case .paused, .failed, .ready:
                imageName = "Play"
            }
            btnPlayPause.setImage(UIImage(named: imageName), for: .normal)
        }
        
        print("Jukebox state changed to \(jukebox.state)")
    }
    
    func jukeboxDidUpdateMetadata(_ jukebox: Jukebox, forItem: JukeboxItem) {
        print("Item updated:\n\(forItem)")
    }
    
    
    override func remoteControlReceived(with event: UIEvent?) {
        if event?.type == .remoteControl {
            switch event!.subtype {
            case .remoteControlPlay :
                jukebox.play()
            case .remoteControlPause :
                jukebox.pause()
            case .remoteControlNextTrack :
                jukebox.playNext()
            case .remoteControlPreviousTrack:
                jukebox.playPrevious()
            case .remoteControlTogglePlayPause:
                if jukebox.state == .playing {
                    jukebox.pause()
                } else {
                    jukebox.play()
                }
            default:
                break
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return singerMediaItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MediaCell") as! MediaTableViewCell
        
        let mediaItem = singerMediaItems[indexPath.row]
        
        cell.lblMusicName.text = mediaItem.MediaName
        cell.lblSinger.text = mediaItem.ArtistName
        cell.lblLikeCount.text = mediaItem.Like
        cell.lblDownloadCount.text = mediaItem.Download
        cell.lblMusicTime.text = mediaItem.Time
        
        cell.imgMusicThumb.af_setImage(withURL: NSURL(string: mediaItem.SmallpicUrl) as! URL)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        jukebox.stop()
        
        self.mediaItem = singerMediaItems[indexPath.row]
        
        LoadData()
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
