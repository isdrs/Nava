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
import SCLAlertView

class MusicPlayerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, JukeboxDelegate {
    
    var mediaItem : MediaItem!
    private var singerMediaItems : [MediaItem] = [MediaItem]()
    
    private var playingMusicView : UIView!
    private var musicListView : UIView!
    
    private var tableView : UITableView!
    let cellReuseIdendifier = "cell"
    
    private var btnBack : UIButton!
    private var btnMenu : UIButton!
    
    private var lblRemainTime : UILabel!
    private var lblPastTime : UILabel!
    
    private var musicSlider : UISlider!
    private var progresslbl : UILabel!
    
    private var btnPlay : UIButton!
    private var btnNext : UIButton!
    private var btnPrev : UIButton!
    
    private var btnLike : UIButton!
    private var btnDownLoad : UIButton!
    private var musicImage : UIImageView!
    
    private var btnIranCell : UIButton!
    private var btnHamrah : UIButton!
    
    private var shareBtn : UIButton!
    private var addToFavoriteBtn : UIButton!
    private var popUpView : UIView!
    private var isMusicSliderTouched = false
    private var popUpViewHeight = CGFloat()
    private var isLiked = false
    private var isDownloaded = false
   
    private var isFavorited : Bool = false {
        
        didSet
        {
            if !isFavorited
            {
                let myNormalAttributedTitle = NSAttributedString(string: Tools.StaticVariables.AddToFavoriteButtonTitle,
                                                                 attributes: [NSForegroundColorAttributeName : UIColor.white])
                let myNormalAttributedTitle2 = NSAttributedString(string: Tools.StaticVariables.AddToFavoriteButtonTitle,
                                                                 attributes: [NSForegroundColorAttributeName : UIColor.green])
                
                addToFavoriteBtn.setAttributedTitle(myNormalAttributedTitle, for: .normal)
                addToFavoriteBtn.setAttributedTitle(myNormalAttributedTitle2, for: .highlighted)
                
            }else
            {
                let myNormalAttributedTitle = NSAttributedString(string: Tools.StaticVariables.DeleteFromFavoriteButtonTitle,
                                                                 attributes: [NSForegroundColorAttributeName : UIColor.white])
                
                let myNormalAttributedTitle2 = NSAttributedString(string: Tools.StaticVariables.DeleteFromFavoriteButtonTitle,
                                                                  attributes: [NSForegroundColorAttributeName : UIColor.green])

                addToFavoriteBtn.setAttributedTitle(myNormalAttributedTitle, for: .normal)
                addToFavoriteBtn.setAttributedTitle(myNormalAttributedTitle2, for: .highlighted)
            }
        }
    }
    var jukebox : Jukebox!
    
    @objc private func buttonAction(sender: UIButton!) {
        print("Button tapped")
    }
    
    func BackAction(){
       
        jukebox.stop()
        
        self.dismiss(animated: true,completion: {});
            
        
    }
    
    @objc private func MenuAction()
    {
        UIView.animate(withDuration: 0.5) {
            
            self.popUpView.frame.size.height = self.popUpViewHeight
            
            self.shareBtn.isHidden = false
            self.shareBtn.isEnabled = true
            
            self.addToFavoriteBtn.isEnabled = true
            self.addToFavoriteBtn.isHidden = false
            
        }
        
    }
    
    func tapBlurButton(_ sender: UITapGestureRecognizer) {
        print("Tap UI")
            // your code here
        
        if self.popUpView.frame.size.width > CGFloat(0)
        {
            HidePopUpView()
        }
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
        if !isLiked
        {
            ServiceManager.LikeOrDwonloadCountAdd(mediaItem: mediaItem, isLike: true) { (result) in
                
                if result
                {
                    self.btnLike.setImage(UIImage(named: "Like"), for: .normal)
                    
                    MediaManager.AddNewLikeToDB(mediaItem: self.mediaItem)
                    
                    self.isLiked = true
                    
                }
                else
                {
                    self.isLiked = false
                }
            }
        }
    }
    
    @objc private func DownloadAction()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.downloadQueue[String(mediaItem.MediaID)] = "true"
        
        btnDownLoad.isHidden = true
        btnDownLoad.isEnabled = false
        
        ServiceManager.DownloadMedia(mediaItem: mediaItem) { (status) in
            if status
            {
                SCLAlertView().showSuccess("دانلود", subTitle: "موفقیت آمیز بود", closeButtonTitle: "تایید", duration: 1.0)
                
                    self.btnDownLoad.isHidden = true
                    appDelegate.downloadQueue.removeValue(forKey: String(self.mediaItem.MediaID))
            }
            else
            {
                    self.btnDownLoad.isEnabled = true
                    self.btnDownLoad.isHidden = false
                    self.progresslbl.isHidden = true
            }
        }
    }
    
    @objc private func MusicSliderValueChange()
    {
//        if !isMusicSliderTouched
//        {
//            if (jukebox.currentItem?.meta.duration) != nil
//            {
//                jukebox.seek(toSecond: Int(Double(musicSlider.value) * (jukebox.currentItem?.meta.duration)!))
//            }
//        }

    }
    
    @objc private func TouchDownMusicSlider()
    {
        
        isMusicSliderTouched = true
    }
    
    @objc private func TouchUpMusicSlider()
    {
        if jukebox.state == .playing
        {
            jukebox.seek(toSecond: Int(Double(musicSlider.value) * mediaItem.TimeDouble))
            
            isMusicSliderTouched = false
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
    
    @objc private func UpdateDownloadProgressLabel(notification: NSNotification)
    {
        let tmp : [String  : String] = notification.userInfo! as! [String : String]
        
        // if notification received, change label value
        let id = tmp[Tools.StaticVariables.MediaIdNotificationsKey] as String!
        let current = tmp[Tools.StaticVariables.ProgressNotificationsKey] as String!
        
        if String(mediaItem.MediaID) == id
        {
            if current == "100"
            {
                self.progresslbl.isHidden = true
            }
            else{
                self.btnDownLoad.isHidden = true
                self.progresslbl.isHidden = false
                self.progresslbl.text = current! + "%"
                self.progresslbl.sizeToFit()
                self.progresslbl.center = self.btnDownLoad.center
            }
        }
        
    }
    
    override func viewDidLoad() {
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton(_:)))

        self.view.addGestureRecognizer(tapGesture)
       
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        print("view frame: \( self.view.frame)")
        
        // begin receiving remote events
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        LoadData()
        
        SetPlayingMusicView()
        SetMusicListView()
        SetPopUpMenuView()
        
        isFavorited = MediaManager.IsFavoritedMedia(mediaItem: mediaItem)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.UpdateDownloadProgressLabel), name: NSNotification.Name(rawValue: Tools.StaticVariables.DownloadProgressNotificationKey ), object: nil)
        
        
        
    }
    
    func SetPlayingMusicView() -> Void{
        let W = Tools.screenWidth
        let H =  Tools.GetScreenHeightPercent() * 65
        let X = CGFloat()
        let Y = Tools.GetScreenHeightPercent() * 3
        let WPercent = W / 100.0
        let HPercent = H / 100.0
        
        
        self.playingMusicView = UIView()
        self.playingMusicView.frame = CGRect(x: X ,y:  Y, width: W, height: H)
        self.playingMusicView.backgroundColor = .black
        
        
        self.btnBack = UIButton()
        self.btnBack.frame = CGRect(x: X + WPercent * 3 , y: HPercent * 2 , width: WPercent * 7 , height: WPercent * 7)
        self.btnBack.setImage(UIImage(named: "Back"), for: .normal)
        self.btnBack.addTarget(self, action: #selector(self.BackAction), for: .touchUpInside)

        
        //Menu Button
        self.btnMenu = UIButton()
        self.btnMenu.frame = CGRect(x: W - btnBack.frame.width - btnBack.frame.origin.x, y: btnBack.frame.origin.y, width: btnBack.frame.width, height: btnBack.frame.height)
        self.btnMenu.setImage(UIImage(named: "Play"), for: .normal)
        self.btnMenu.addTarget(self, action: #selector(self.MenuAction), for: .touchUpInside)
        
        
        //Music Image
        self.musicImage = UIImageView()
        self.musicImage.frame = CGRect(x: 0, y: 0, width: Tools.screenWidth, height: playingMusicView.frame.height * 0.90)
        self.musicImage.af_setImage(withURL: URL(string:mediaItem.LargpicUrl)!)
        self.playingMusicView.addSubview(musicImage)
        
        
        //Irancell and Hamrah Aval Button
        self.btnHamrah = Tools.MakeUIButtonWithAttributes(btnName: "پیشواز همراه اول")
        self.btnHamrah.frame.size = CGSize(width: playingMusicView.frame.size.width * 0.48, height: playingMusicView.frame.height * 0.08)
        self.btnHamrah.frame.origin = CGPoint(x: Tools.GetScreenWidthPercent(), y: 0)
        self.btnHamrah.center.y =  playingMusicView.frame.height * 0.95
        self.btnHamrah.backgroundColor = UIColor.gray
        self.btnHamrah.layer.cornerRadius = 5
        self.btnHamrah.addTarget(self, action: #selector(self.HamrahAvvalAction), for: UIControlEvents.touchUpInside)
        
        
        // Irancell
        self.btnIranCell = Tools.MakeUIButtonWithAttributes(btnName: "پیشواز ایرانسل")
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
        self.btnLike.frame = CGRect(x: btnBack.frame.origin.x, y: H - btnHamrah.frame.size.height - btnBack.frame.height - HPercent * 6, width: btnBack.frame.width, height: btnBack.frame.height)
        isLiked = MediaManager.IsLikedMedia(mediaItem: mediaItem)
        if isLiked
        {
            self.btnLike.setImage(UIImage(named: "Like"), for: .normal)
        }
        else
        {
            self.btnLike.setImage(UIImage(named: "UnLike"), for: .normal)
            self.btnLike.addTarget(self, action: #selector(self.LikeAction), for: .touchUpInside)
        }
        
        
        //Download Buttom
        self.btnDownLoad = UIButton()
        self.btnDownLoad.frame = CGRect(x: btnMenu.frame.origin.x, y: btnLike.frame.origin.y, width: btnBack.frame.width, height: btnBack.frame.height)
        if !isDownloaded
        {
            self.btnDownLoad.setImage(UIImage(named: "DownloadedTab"), for: .normal)
            self.btnDownLoad.addTarget(self, action: #selector(self.DownloadAction), for: .touchUpInside)
            self.playingMusicView.addSubview(btnDownLoad)
        }
        
        self.progresslbl = UILabel()
        self.progresslbl.font = UIFont(name: "Arial", size: 12)
        self.progresslbl.center = self.btnDownLoad.center
        self.progresslbl.textColor = UIColor.white
        self.progresslbl.isHidden = true
        
        
        
        // Play Button
        self.btnPlay = UIButton()
        self.btnPlay.frame = CGRect(x:0, y: 0, width: btnBack.frame.width * 1.5, height: btnBack.frame.height * 1.5)
        self.btnPlay.center.x = W / 2
        self.btnPlay.center.y = btnLike.center.y
        self.btnPlay.setImage(UIImage(named: "Play"), for: .normal)
        self.btnPlay.addTarget(self, action: #selector(self.PlayTrack), for: .touchUpInside)
        
        
        // Next Music Button
        self.btnNext = UIButton()
        self.btnNext.frame = CGRect(x: btnPlay.frame.origin.x + WPercent * 15, y: btnLike.frame.origin.y, width: btnBack.frame.width, height: btnBack.frame.height)
        self.btnNext.setImage(UIImage(named: "Next"), for: .normal)
        self.btnNext.addTarget(self, action: #selector(self.NextTrack), for: .touchUpInside)
        
        
        // Previous Music Button
        self.btnPrev = UIButton()
        self.btnPrev.frame = CGRect(x: btnPlay.frame.origin.x - WPercent * 15, y: btnLike.frame.origin.y, width: btnBack.frame.width, height: btnBack.frame.height)
        self.btnPrev.setImage(UIImage(named: "Prev"), for: .normal)
        self.btnPrev.addTarget(self, action: #selector(self.PrevTrack), for: .touchUpInside)
        
        //Slider bar
        self.musicSlider = UISlider()
        self.musicSlider.frame = CGRect(x: 0, y: btnPlay.frame.origin.y - HPercent * 5, width: W - WPercent * 5, height: 5)
        self.musicSlider.center.x = btnPlay.center.x
        self.musicSlider.setThumbImage(UIImage(named: "SliderThumb"), for: UIControlState())
        self.musicSlider.addTarget(self, action: #selector(self.MusicSliderValueChange), for: .valueChanged)
        self.musicSlider.addTarget(self, action: #selector(self.TouchDownMusicSlider), for: .touchDown)
        self.musicSlider.addTarget(self, action: #selector(self.TouchUpMusicSlider), for: .touchUpInside)
        
        
        //Remaining Time Label
        self.lblRemainTime = UILabel()
        self.lblRemainTime.text = "00:00"
        self.lblRemainTime.sizeToFit()
        self.lblRemainTime.frame.origin.x = W - lblRemainTime.frame.size.width - WPercent * 2.5
        self.lblRemainTime.frame.origin.y = self.musicSlider.frame.origin.y - lblRemainTime.frame.size.height - 10
        self.lblRemainTime.textColor = UIColor.white
        
        
        // Add components to view
        
        self.playingMusicView.addSubview(sepratoreView)
        self.playingMusicView.addSubview(btnHamrah)
        self.playingMusicView.addSubview(progresslbl)
        self.playingMusicView.bringSubview(toFront: btnHamrah)
        self.playingMusicView.addSubview(btnIranCell)
        self.playingMusicView.addSubview(btnBack)
        self.playingMusicView.addSubview(btnMenu)
        self.playingMusicView.addSubview(btnLike)
        self.playingMusicView.addSubview(btnPlay)
        self.playingMusicView.addSubview(btnNext)
        self.playingMusicView.addSubview(btnPrev)
        self.playingMusicView.addSubview(musicSlider)
        self.playingMusicView.addSubview(lblRemainTime)
        
        
        self.view.addSubview(self.playingMusicView)
        
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
        tableView.backgroundColor = .black
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = CGRect(x: 0, y: 0, width: musicListView.frame.width , height: musicListView.frame.height)
        
        
        self.musicListView.addSubview(tableView)
        self.view.addSubview(musicListView)
    }
    
    func SetPopUpMenuView() -> Void{
        
        popUpViewHeight = playingMusicView.frame.size.height * 0.26
        let viewSize = CGSize(width: self.playingMusicView.frame.size.width * 0.6 , height: 0)
        let viewPosition = CGPoint(x: self.playingMusicView.frame.size.width - viewSize.width - Tools.GetScreenWidthPercent(), y: 0)
        
        
        popUpView = UIView()
        popUpView.frame.size = viewSize
        popUpView.frame.origin = viewPosition
       
        
        shareBtn = Tools.MakeUIButtonWithAttributes(btnName: "اشتراک گذاری")
        shareBtn.frame = CGRect(x: 0, y: 0, width: popUpView.frame.size.width, height: popUpViewHeight * 0.5)
        shareBtn.backgroundColor = UIColor.darkGray
        self.shareBtn.addTarget(self, action: #selector(self.Sharing), for: UIControlEvents.touchUpInside)
        shareBtn.contentHorizontalAlignment = .left;
        shareBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        
        
        addToFavoriteBtn = Tools.MakeUIButtonWithAttributes(btnName: "")
        addToFavoriteBtn.frame = CGRect(x: 0, y: shareBtn.frame.size.height, width: shareBtn.frame.size.width, height: shareBtn.frame.size.height)
        addToFavoriteBtn.backgroundColor = UIColor.darkGray
        self.addToFavoriteBtn.addTarget(self, action: #selector(self.AddToFavorite), for: UIControlEvents.touchUpInside)
        addToFavoriteBtn.contentHorizontalAlignment = .left;
        addToFavoriteBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        
        
        self.shareBtn.isHidden = true
        self.shareBtn.isEnabled = false
        self.addToFavoriteBtn.isEnabled = false
        self.addToFavoriteBtn.isHidden = true
       
        
        self.popUpView.addSubview(shareBtn)
        self.popUpView.addSubview(addToFavoriteBtn)
        self.playingMusicView.addSubview(popUpView)
        
    }
    
    func HidePopUpView()
    {
        UIView.animate(withDuration: 0.5) {
            
            self.popUpView.frame.size.height = CGFloat()
            
            self.shareBtn.isHidden = true
            self.shareBtn.isEnabled = false
            
            self.addToFavoriteBtn.isEnabled = false
            self.addToFavoriteBtn.isHidden = true
        }
    }
    
    func Sharing()
    {
        let text = mediaItem.ShareUrl
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func AddToFavorite()
    {
        if !isFavorited
        {
            let res = MediaManager.AddNewFavoriteToDB(mediaItems: [mediaItem])
            
            if res
            {
                SCLAlertView().showSuccess("", subTitle: "انجام شد", closeButtonTitle: "تایید", duration: 1.0)
                isFavorited = true
            }
            else
            {
                SCLAlertView().showError("", subTitle: "انجام نشد", closeButtonTitle: "تایید", duration: 1.0)
            }
        }
        else
        {
            let res = MediaManager.DeleteDBFavorites(mediaItem: mediaItem)
            
            if res
            {
                SCLAlertView().showSuccess("", subTitle: "انجام شد", closeButtonTitle: "تایید", duration: 1.0)
                isFavorited = false
            }
            else
            {
                SCLAlertView().showError("", subTitle: "انجام نشد", closeButtonTitle: "تایید", duration: 1.0)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ServiceManager.GetMediaListByArtist(mediaItem: mediaItem, mediaType: .sound, serviceType: mediaItem.MediaServiceType, pageNo: 1) { (status, newMedia) in
            if status
            {
                self.singerMediaItems = newMedia
                
                DispatchQueue.main.async {
                        self.tableView.reloadData()
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
            
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            
            documentsURL.appendPathComponent("MyMedia/." + mediaItem.MediaID + ".mp3")
            
            currentMedia = JukeboxItem(URL: documentsURL)
            
            isDownloaded = true
        }
        else
        {
            currentMedia = JukeboxItem(URL: URL(string: mediaItem.MediaUrl)!)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            if appDelegate.downloadQueue[String(mediaItem.MediaID)] != nil {
                isDownloaded = true
            }
            else
            {
              isDownloaded = false
            }
            
        }
        
        jukebox = Jukebox(delegate: self, items: [currentMedia])
        
        //jukebox.play()
    }
    
    func resetUI()
    {
         lblRemainTime.text = "00:00"
         musicSlider.value = 0
    }
    
    func populateLabelWithTime(_ label : UILabel, time: Double) {
        let minutes = Int(time / 60)
        let seconds = Int(time) - minutes * 60
        
        label.text = String(format: "%02d", minutes) + ":" + String(format: "%02d", seconds)
        label.sizeToFit()
    }
    
    func jukeboxDidLoadItem(_ jukebox: Jukebox, item: JukeboxItem) {
        print("Jukebox did load: \(item.URL.lastPathComponent)")
    }
    
    func jukeboxPlaybackProgressDidChange(_ jukebox: Jukebox) {
        
//        print("currentTime:  \(jukebox.currentItem?.currentTime)")
//        
//        print("duration:  \(jukebox.currentItem?.meta.duration)")
        
        if let currentTime = jukebox.currentItem?.currentTime, let duration = mediaItem.TimeDouble//jukebox.currentItem?.meta.duration
        {
            let value = Float(currentTime / duration)
            
            if !isMusicSliderTouched
            {
               musicSlider.value = value
            }
            
            
                populateLabelWithTime(lblRemainTime, time: currentTime)
        }
        else
        {
            resetUI()
        }
    }
    
    func jukeboxStateDidChange(_ jukebox: Jukebox) {
        
        
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
                 self.btnPlay.alpha = jukebox.state == .loading ? 0 : 1
                 self.btnPlay.isEnabled = jukebox.state == .loading ? false : true
        })
        
        if jukebox.state == .ready
        {
                btnPlay.setImage(UIImage(named: "Play"), for: .normal)
        }
        else if jukebox.state == .loading
        {
                btnPlay.setImage(UIImage(named: "Pause"), for: .normal)
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
            
            btnPlay.setImage(UIImage(named: imageName), for: .normal)
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

        let cellSize = CGSize(width: Tools.screenWidth, height: Tools.GetScreenHeightPercent() * 25)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdendifier, for: indexPath as IndexPath) as! MediaCell
        
        
        
        print("Cell Height: \(cell.frame.size.height)")
        
        cell.frame.size = cellSize
        
        let p =  URL(string:singerMediaItems[indexPath.row].LargpicUrl)!
        
        cell.musicImage.af_setImage(withURL:p)
        
        print("TableView Row Height: \(tableView.rowHeight)")
        
        print("TableView Row Height estimate: \(tableView.estimatedRowHeight)")
        
        print("Cell Height: \(cell.frame.size.height)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        jukebox.stop()
        
        self.mediaItem = singerMediaItems[indexPath.row]
        
        LoadData()
    }
}
