//
//  MusicPlayerViewController.swift
//  nava
//
//  Created by Mohsenian on 7/19/1395 AP.
//  Copyright © 1395 manshor. All rights reserved.
//

import AlamofireImage
import Foundation
import UIKit
import MediaPlayer
import Jukebox
import AlamofireImage
import SCLAlertView_Objective_C

class MusicPlayerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, JukeboxDelegate {
    
    var mediaItem : MediaItem!
    private var singerMediaItems : [MediaItem] = [MediaItem]()
    private var MysingerMediaItems : [String] = ["http://hadsahang.arsinit.com/files/large/a7a2c3822bc78ad","http://hadsahang.arsinit.com/files/large/a7a2c3822bc78ad","http://hadsahang.arsinit.com/files/large/a7a2c3822bc78ad"]
    

    
    private var playingMusicView : UIView!
    private var musicListView : UIView!
    
    private var tableView : UITableView!
    let cellReuseIdendifier = "cell"
    
    private var btnBack : UIButton!
    private var btnMenu : UIButton!
    
    private var lblRemainTime : UILabel!
    private var lblPastTime : UILabel!
    
    private var musicSlider : UISlider!
    
    private var btnPlay : UIButton!
    private var btnNext : UIButton!
    private var btnPrev : UIButton!
    
    private var btnLike : UIButton!
    private var btnDownLoad : UIButton!
    
    private var musicImage : UIImageView!
    
    private var btnIranCell : UIButton!
    private var btnHamrah : UIButton!
    
    
    
    
    //var playButton : UIButton!
    var jukebox : Jukebox!
    
    @objc private func buttonAction(sender: UIButton!) {
        print("Button tapped")
    }
    
    @objc private func MenuAction()
    {
        print("Button tapped")
    }
    
    @objc private func HamrahAvvalAction()
    {
        print("Button tapped")
    }
    
    @objc private func IrancellAction()
    {
        print("Button tapped")
    }
    
    
    
    @objc private func LikeAction()
    {
        
    }
    
    private func DownloadAction()
    {
        // btnDownloadOutlet.isEnabled = false
        
        ServiceManager.DownloadMedia(mediaItem: mediaItem) { (status) in
            if status
            {
                SCLAlertView().showSuccess("دانلود", subTitle: "موفقیت آمیز بود", closeButtonTitle: "تایید", duration: 1.0)
                
                //     self.btnDownloadOutlet.isHidden = true
            }
            else
            {
                //     self.btnDownloadOutlet.isEnabled = true
            }
        }
    }
    
    private func MusicSliderValueChange()
    {
        if (jukebox.currentItem?.meta.duration) != nil
        {
            //       jukebox.seek(toSecond: Int(Double(slrMusicDuration.value) * duration))
        }
    }
    
    @objc private func NextTrack()
    {
        jukebox.playNext()
    }
    
    @objc private func PlayTrack()
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
    
    @objc private func PrevTrack()
    {
        if let time = jukebox.currentItem?.currentTime, time > 5.0 || jukebox.playIndex == 0 {
            jukebox.replayCurrentItem()
        } else {
            jukebox.playPrevious()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print("view frame: \( self.view.frame)")
        
        
        
        resetUI()
        // begin receiving remote events
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        SetPlayingMusicView()
        
        
        SetMusicListView()
        
        LoadData()
    }
    
    
    func SetPlayingMusicView() -> Void
    {
        let W = Tools.screenWidth
        let H =  Tools.GetScreenHeightPercent() * 65
        let X = CGFloat()
        let Y = Tools.GetScreenHeightPercent() * 2
        let WPercent = W / 100.0
        let HPercent = H / 100.0
        
        
        
        
        self.playingMusicView = UIView()
        //self.playingMusicView.backgroundColor = UIColor.blue
     
        self.playingMusicView.frame = CGRect(x: X ,y:  Y, width: W, height: H)
        
        
        self.btnBack = UIButton()
        self.btnBack.frame = CGRect(x: X + WPercent * 3 , y: Y + HPercent * 4, width: WPercent * 7 , height: WPercent * 7)
        self.btnBack.setBackgroundImage(UIImage(named: "Back"), for: .normal)
        self.btnBack.addTarget(self, action: #selector(self.BackAction), for: .touchUpInside)

        
        //Menu Button
        self.btnMenu = UIButton()
        self.btnMenu.frame = CGRect(x: W - btnBack.frame.width - btnBack.frame.origin.x, y: btnBack.frame.origin.y, width: btnBack.frame.width, height: btnBack.frame.height)
        self.btnMenu.setBackgroundImage(UIImage(named: "Play"), for: .normal)
        self.btnMenu.addTarget(self, action: #selector(self.MenuAction), for: .touchUpInside)
        
        
        //Music Image
        self.musicImage = UIImageView()
        self.musicImage.frame = CGRect(x: X, y: Y, width: Tools.screenWidth, height: playingMusicView.frame.height * 0.85)
        self.musicImage.af_setImage(withURL: URL(string:"http://hadsahang.arsinit.com/files/large/a7a2c3822bc78ad")!)
        
        
        //Irancell and Hamrah Aval Button
        let attrs = [NSFontAttributeName : UIFont.systemFont(ofSize: 19.0),
            NSForegroundColorAttributeName : UIColor.white,
            NSUnderlineStyleAttributeName : 0] as [String : Any]
        var attributedString = NSMutableAttributedString(string:"")
        var buttonTitleStr = NSMutableAttributedString(string:"پیشواز همراه اول", attributes:attrs)
        attributedString.append(buttonTitleStr)
        
        let attrs2 = [NSFontAttributeName : UIFont.systemFont(ofSize: 19.0),
                     NSForegroundColorAttributeName : UIColor.green,
                     NSUnderlineStyleAttributeName : 0] as [String : Any]
        var attributedString2 = NSMutableAttributedString(string:"")
        var buttonTitleStr2 = NSMutableAttributedString(string:"پیشواز همراه اول", attributes:attrs2)
        attributedString2.append(buttonTitleStr2)
       
        
        
        self.btnHamrah = UIButton()
        self.btnHamrah.setAttributedTitle(attributedString, for: .normal)
        self.btnHamrah.setAttributedTitle(attributedString2, for: .highlighted)
        self.btnHamrah.frame.size = CGSize(width: playingMusicView.frame.size.width * 0.48, height: playingMusicView.frame.size.height - musicImage.frame.size.height - Y - 10)
        self.btnHamrah.frame.origin = CGPoint(x: Tools.GetScreenWidthPercent(), y: musicImage.frame.size.height + Y + 5)
        self.btnHamrah.backgroundColor = UIColor.gray
        self.btnHamrah.layer.cornerRadius = 5
        self.btnHamrah.addTarget(self, action: #selector(self.HamrahAvvalAction), for: UIControlEvents.touchUpInside)
        
        // Irancell
        self.btnIranCell = UIButton()
        buttonTitleStr = NSMutableAttributedString(string:"پیشواز ایرانسل", attributes:attrs)
        attributedString = NSMutableAttributedString(string:"")
        attributedString.append(buttonTitleStr)
        buttonTitleStr2 = NSMutableAttributedString(string:"پیشواز ایرانسل", attributes:attrs2)
        attributedString2 = NSMutableAttributedString(string:"")
        attributedString2.append(buttonTitleStr2)
        self.btnIranCell.setAttributedTitle(attributedString, for: .normal)
        self.btnIranCell.setAttributedTitle(attributedString2, for: .highlighted)
        self.btnIranCell.frame.size = btnHamrah.frame.size
        self.btnIranCell.frame.origin = CGPoint(x: playingMusicView.frame.size.width - btnIranCell.frame.size.width - Tools.GetScreenWidthPercent(), y: btnHamrah.frame.origin.y)
        self.btnIranCell.backgroundColor = UIColor.gray
        self.btnIranCell.layer.cornerRadius = 5
        self.btnIranCell.addTarget(self, action: #selector(self.IrancellAction), for: UIControlEvents.touchUpInside)
        
        
        // seperator view
        let sepratoreView = UIView()
        sepratoreView.backgroundColor = UIColor.white
        sepratoreView.frame = CGRect(x: 0, y: 0, width: 1, height: btnHamrah.frame.size.height * 0.8)
        sepratoreView.center = CGPoint(x: Tools.GetScreenWidthPercent() * 2 + btnHamrah.frame.size.width, y: btnHamrah.center.y)
        
        
        //Like Button
        self.btnLike = UIButton()
        self.btnLike.frame = CGRect(x: btnBack.frame.origin.x, y: H - btnHamrah.frame.size.height - btnBack.frame.height - HPercent * 10, width: btnBack.frame.width, height: btnBack.frame.height)
        self.btnLike.setBackgroundImage(UIImage(named: "Like"), for: .normal)
        self.btnLike.addTarget(self, action: #selector(self.LikeAction), for: .touchUpInside)
        
        //Download Buttom
        self.btnDownLoad = UIButton()
        self.btnDownLoad.frame = CGRect(x: btnMenu.frame.origin.x, y: btnLike.frame.origin.y, width: btnBack.frame.width, height: btnBack.frame.height)
        self.btnDownLoad.setBackgroundImage(UIImage(named: "DownloadedTab"), for: .normal)
        self.btnDownLoad.addTarget(self, action: #selector(self.BackAction), for: .touchUpInside)
        
        // Play Button
        self.btnPlay = UIButton()
        self.btnPlay.frame = CGRect(x:0, y: 0, width: btnBack.frame.width * 1.5, height: btnBack.frame.height * 1.5)
        self.btnPlay.center.x = W / 2
        self.btnPlay.center.y = btnLike.center.y
        self.btnPlay.setBackgroundImage(UIImage(named: "Play"), for: .normal)
        self.btnPlay.addTarget(self, action: #selector(self.PlayTrack), for: .touchUpInside)
        
        // Next Music Button
        self.btnNext = UIButton()
        self.btnNext.frame = CGRect(x: btnPlay.frame.origin.x + WPercent * 15, y: btnLike.frame.origin.y, width: btnBack.frame.width, height: btnBack.frame.height)
        self.btnNext.setBackgroundImage(UIImage(named: "Next"), for: .normal)
        self.btnNext.addTarget(self, action: #selector(self.NextTrack), for: .touchUpInside)
        
        
        // Previous Music Button
        self.btnPrev = UIButton()
        self.btnPrev.frame = CGRect(x: btnPlay.frame.origin.x - WPercent * 15, y: btnLike.frame.origin.y, width: btnBack.frame.width, height: btnBack.frame.height)
        self.btnPrev.setBackgroundImage(UIImage(named: "Prev"), for: .normal)
        self.btnPrev.addTarget(self, action: #selector(self.PrevTrack), for: .touchUpInside)
        
        
        self.musicSlider = UISlider()
        self.musicSlider.frame = CGRect(x: 0, y: btnPlay.frame.origin.y - HPercent * 5, width: W - WPercent * 5, height: 5)
        self.musicSlider.center.x = btnPlay.center.x
        self.musicSlider.setThumbImage(UIImage(named: "SliderThumb"), for: UIControlState())
        
        
        self.lblRemainTime = UILabel()
        self.lblRemainTime.text = "13:43"
        self.lblRemainTime.sizeToFit()
        self.lblRemainTime.frame.origin.x = W - lblRemainTime.frame.size.width - WPercent * 2.5
        self.lblRemainTime.frame.origin.y = self.musicSlider.frame.origin.y - lblRemainTime.frame.size.height - 10
        self.lblRemainTime.textColor = UIColor.white
        
        
        
        
        // Add components to view
        self.playingMusicView.addSubview(musicImage)
        self.playingMusicView.addSubview(sepratoreView)
        self.playingMusicView.addSubview(btnHamrah)
        self.playingMusicView.bringSubview(toFront: btnHamrah)
        self.playingMusicView.addSubview(btnIranCell)
        self.playingMusicView.addSubview(btnBack)
        self.playingMusicView.addSubview(btnMenu)
        self.playingMusicView.addSubview(btnLike)
        self.playingMusicView.addSubview(btnDownLoad)
        self.playingMusicView.addSubview(btnPlay)
        self.playingMusicView.addSubview(btnNext)
        self.playingMusicView.addSubview(btnPrev)
        self.playingMusicView.addSubview(musicSlider)
        self.playingMusicView.addSubview(lblRemainTime)
        
    }
    
    func SetMusicListView() -> Void{
        
        
        let viewSize = self.playingMusicView.frame.size
        let viewPosition = self.playingMusicView.frame.origin
        
        
        self.musicListView = UIView()
        self.musicListView.frame = CGRect(x: viewPosition.x ,y: viewPosition.y + viewSize.height, width: viewSize.width, height: Tools.GetScreenHeightPercent() * 45)
        
        
        // set tableview properties
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(MediaCell.self, forCellReuseIdentifier: cellReuseIdendifier)
        tableView.rowHeight = MediaCell.cellHeight
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = CGRect(x: 0, y: 0, width: musicListView.frame.width , height: musicListView.frame.height)
        
        
        self.musicListView.addSubview(tableView)
        self.view.addSubview(musicListView)
    }
    
    func BackAction(){
        jukebox.stop()
        
        self.dismiss(animated: true)
        {
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ServiceManager.GetMediaListByArtist(mediaItem: mediaItem, mediaType: .sound, serviceType: mediaItem.MediaServiceType, pageNo: 1) { (status, newMedia) in
            if status
            {
                self.singerMediaItems = newMedia
                
                DispatchQueue.main.async {
                    //           self.tblSingerMedia.reloadData()
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
            
            btnDownLoad.isHidden = true
            
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            
            documentsURL.appendPathComponent("MyMedia/." + mediaItem.MediaID + ".mp3")
            
            currentMedia = JukeboxItem(URL: documentsURL)
        }
        else
        {
            currentMedia = JukeboxItem(URL: URL(string: mediaItem.MediaUrl)!)
            
            btnDownLoad.isHidden = false
        }
        
        if MediaManager.IsLikedMedia(mediaItem: mediaItem) {
            
            btnLike.setImage(UIImage(named: "Like"), for: .normal)
        }
        else
        {
            btnLike.setImage(UIImage(named: "UnLike"), for: .normal)
        }
        
        
        self.view.addSubview(self.playingMusicView)
        
        jukebox = Jukebox(delegate: self, items: [currentMedia])
        
        
        jukebox.play()
    }
    
    func resetUI()
    {
        // lblMusicCurrentTime.text = "00:00"
        // slrMusicDuration.value = 0
    }
    
    func populateLabelWithTime(_ label : UILabel, time: Double) {
        let minutes = Int(time / 60)
        let seconds = Int(time) - minutes * 60
        
        label.text = String(format: "%02d", minutes) + ":" + String(format: "%02d", seconds)
    }
    
    func jukeboxDidLoadItem(_ jukebox: Jukebox, item: JukeboxItem) {
        print("Jukebox did load: \(item.URL.lastPathComponent)")
    }
    
    func jukeboxPlaybackProgressDidChange(_ jukebox: Jukebox) {
        
        print("currentTime:  \(jukebox.currentItem?.currentTime)")
        
        print("duration:  \(jukebox.currentItem?.meta.duration)")
        
        if let currentTime = jukebox.currentItem?.currentTime, let duration = mediaItem.TimeDouble//jukebox.currentItem?.meta.duration
        {
            let value = Float(currentTime / duration)
            //    slrMusicDuration.value = value
            //    populateLabelWithTime(lblMusicCurrentTime, time: currentTime)
        }
        else
        {
            resetUI()
        }
    }
    
    func jukeboxStateDidChange(_ jukebox: Jukebox) {
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            //     self.btnPlayPause.alpha = jukebox.state == .loading ? 0 : 1
            //     self.btnPlayPause.isEnabled = jukebox.state == .loading ? false : true
        })
        
        if jukebox.state == .ready
        {
            //    btnPlayPause.setImage(UIImage(named: "Play"), for: .normal)
        }
        else if jukebox.state == .loading
        {
            //    btnPlayPause.setImage(UIImage(named: "Pause"), for: .normal)
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
            //    btnPlayPause.setImage(UIImage(named: imageName), for: .normal)
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
        
        return MysingerMediaItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MediaCell") as! MediaTableViewCell
//        
//        let mediaItem = singerMediaItems[indexPath.row]
//        
//        cell.lblMusicName.text = mediaItem.MediaName
//        cell.lblSinger.text = mediaItem.ArtistName
//        cell.lblLikeCount.text = mediaItem.Like
//        cell.lblDownloadCount.text = mediaItem.Download
//        cell.lblMusicTime.text = mediaItem.Time
//        
//        cell.imgMusicThumb.af_setImage(withURL: NSURL(string: mediaItem.SmallpicUrl) as! URL)

        let cellSize = CGSize(width: Tools.screenWidth, height: Tools.GetScreenHeightPercent() * 25)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdendifier, for: indexPath as IndexPath) as! MediaCell
        
        
        
        print("Cell Height: \(cell.frame.size.height)")
        
        cell.frame.size = cellSize
        
        let p =  URL(string:MysingerMediaItems[indexPath.row])!
        cell.musicImage.af_setImage(withURL:p)
        
        print("TableView Row Height: \(tableView.rowHeight)")
        
        print("TableView Row Height estimate: \(tableView.estimatedRowHeight)")
        
        print("Cell Height: \(cell.frame.size.height)")
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        jukebox.stop()
        
        //self.mediaItem = singerMediaItems[indexPath.row]
        
        LoadData()
    }
}
