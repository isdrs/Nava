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
import MessageUI


class MusicPlayerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,MFMessageComposeViewControllerDelegate ,JukeboxDelegate {
    
    
    
    private var lblMusicName : TitleLable!
    private var lblArtistName : UILabel!
    
    private var playingMusicView : UIView!
    private var musicListView : UIView!
    
    private var tableView : UITableView!
    
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
    private var canPlay = true
    
    
    private var isStartPlaying = false
    
    var refreshControl : UIRefreshControl!
   
    var MusicTitleLabel : String {
        get {
            return self.lblMusicName.text!
        }
        set {
            self.lblMusicName.text = newValue
            self.lblMusicName.font = UIFont(name: Tools.StaticVariables.AppFont, size: 18)
            //self.lblMusicName.sizeToFit()
            self.lblMusicName.frame.origin = CGPoint(x: 0 , y:self.playingMusicView.frame.size.height * 0.3)
            self.lblMusicName.textAlignment = .center
            self.lblMusicName.center.x = self.playingMusicView.center.x
            
        }
    }
    
    var ArtistNameLabel : String {
        get {
            return self.lblArtistName.text!
        }
        set {
            self.lblArtistName.text = newValue
            self.lblArtistName.font = UIFont(name: Tools.StaticVariables.AppFont, size: 14)
            //self.lblArtistName.sizeToFit()
            self.lblArtistName.frame.origin = CGPoint(x: 0 , y:self.playingMusicView.frame.size.height * 0.37)
            self.lblArtistName.textAlignment = .center
            self.lblArtistName.center.x = self.playingMusicView.center.x
        }
    }
    
    private var isFavorited : Bool = false {
        
        didSet
        {
            if !isFavorited
            {
                let myNormalAttributedTitle = NSAttributedString(string: Tools.StaticVariables.AddToFavoriteButtonTitle,
                                                                 attributes: [NSForegroundColorAttributeName : UIColor.white,NSUnderlineStyleAttributeName : 0])
                let myNormalAttributedTitle2 = NSAttributedString(string: Tools.StaticVariables.AddToFavoriteButtonTitle,
                                                                 attributes: [NSForegroundColorAttributeName : UIColor.green,NSUnderlineStyleAttributeName : 0])
                
                addToFavoriteBtn.setAttributedTitle(myNormalAttributedTitle, for: .normal)
                addToFavoriteBtn.setAttributedTitle(myNormalAttributedTitle2, for: .highlighted)
                
            }
            else
            {
                let myNormalAttributedTitle = NSAttributedString(string: Tools.StaticVariables.DeleteFromFavoriteButtonTitle,
                                                                 attributes: [NSForegroundColorAttributeName : UIColor.white,NSUnderlineStyleAttributeName : 0])
                
                let myNormalAttributedTitle2 = NSAttributedString(string: Tools.StaticVariables.DeleteFromFavoriteButtonTitle,
                                                                  attributes: [NSForegroundColorAttributeName : UIColor.green,NSUnderlineStyleAttributeName : 0])

                addToFavoriteBtn.setAttributedTitle(myNormalAttributedTitle, for: .normal)
                addToFavoriteBtn.setAttributedTitle(myNormalAttributedTitle2, for: .highlighted)
            }
        }
    }
    
    override func viewDidLoad() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton(_:)))
        
        self.view.addGestureRecognizer(tapGesture)
        
        tapGesture.cancelsTouchesInView = false
        
        super.viewDidLoad()
        
        self.view.backgroundColor = .clear
        
        print("view frame: \( self.view.frame)")
        
        // begin receiving remote events
        
        let url = LoadData()
        
        SetPlayingMusicView()
        SetMusicListView()
        SetPopUpMenuView()
        
        isFavorited = MediaManager.IsFavoritedMedia(mediaItem: PlayingMediaManager.ShowingMediaItem)
        
        if PlayingMediaManager.CheckPlayingMediaItemIsShowing()
        {
            CheckNowPlayingMusic(myUrl: url)
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.UpdateDownloadProgressLabel), name: NSNotification.Name(rawValue: Tools.StaticVariables.DownloadProgressNotificationKey ), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.GetOtherMedia), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        
        
    }
    
    func SetPlayingMusicView() -> Void
    {
        
        let W = Tools.screenWidth
        let H =  Tools.screenHeight * 0.65
        let X = CGFloat()
        let Y = Tools.YDiffer
        let WPercent = W / 100.0
        let HPercent = H / 100.0
        
        
        self.playingMusicView = UIView()
        self.playingMusicView.frame = CGRect(x: X ,y:  Y, width: W, height: H)
        self.playingMusicView.backgroundColor = .clear
        
        
        self.btnBack = UIButton()
        self.btnBack.frame = CGRect(x: X + WPercent * 3 , y: HPercent * 2 , width: WPercent * 7 , height: WPercent * 7)
        self.btnBack.setImage(UIImage(named: "Back"), for: .normal)
        self.btnBack.addTarget(self, action: #selector(self.BackAction), for: .touchUpInside)
        
        
        //Menu Button
        self.btnMenu = UIButton()
        self.btnMenu.frame = CGRect(x: W - btnBack.frame.width - btnBack.frame.origin.x, y: btnBack.frame.origin.y, width: btnBack.frame.width, height: btnBack.frame.height)
        self.btnMenu.setImage(UIImage(named: "SubMenu"), for: .normal)
        self.btnMenu.addTarget(self, action: #selector(self.MenuAction), for: .touchUpInside)
        
        
        
        //Music Image
        self.musicImage = UIImageView()
        self.musicImage.frame = CGRect(x: 0, y: 0, width: Tools.screenWidth, height: playingMusicView.frame.height * 0.90)
        SetImageForImageView()
        self.playingMusicView.addSubview(musicImage)
        
        
        
        //Irancell and Hamrah Aval Button
        self.btnHamrah = Tools.MakeUIButtonWithAttributes(btnName: "پیشواز همراه اول",fontSize: 17.0)
        self.btnHamrah.frame.size = CGSize(width: playingMusicView.frame.size.width * 0.498, height: playingMusicView.frame.height * 0.08)
        self.btnHamrah.frame.origin = CGPoint(x: Tools.screenWidth * 0.00, y: 0)
        self.btnHamrah.center.y =  playingMusicView.frame.height * 0.95
        self.btnHamrah.backgroundColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        //self.btnHamrah.layer.cornerRadius = 5
        self.btnHamrah.addTarget(self, action: #selector(self.HamrahAvvalAction), for: UIControlEvents.touchUpInside)
        
        
        // Irancell
        self.btnIranCell = Tools.MakeUIButtonWithAttributes(btnName: "پیشواز ایرانسل",fontSize: 17.0)
        self.btnIranCell.frame.size = btnHamrah.frame.size
        self.btnIranCell.frame.origin = CGPoint(x: playingMusicView.frame.size.width - btnIranCell.frame.size.width - Tools.screenWidth * 0.00, y: btnHamrah.frame.origin.y)
        self.btnIranCell.backgroundColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        //self.btnIranCell.layer.cornerRadius = 5
        self.btnIranCell.addTarget(self, action: #selector(self.IrancellAction), for: UIControlEvents.touchUpInside)
        
        
        // seperator view
        let sepratoreView = UIView()
        sepratoreView.backgroundColor = UIColor.white
        sepratoreView.frame = CGRect(x: 0, y: 0, width: 1, height: btnHamrah.frame.size.height * 0.8)
        sepratoreView.center = CGPoint(x: btnHamrah.frame.size.width * 1.002, y: btnHamrah.center.y)
        
        
        
        //Like Button
        self.btnLike = UIButton()
        self.btnLike.frame = CGRect(x: btnBack.frame.origin.x, y: H - btnHamrah.frame.size.height - btnBack.frame.height - HPercent * 6, width: btnBack.frame.width, height: btnBack.frame.height)
        isLiked = MediaManager.IsLikedMedia(mediaItem: PlayingMediaManager.ShowingMediaItem)
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
        self.btnDownLoad.tag = 5000
        self.btnDownLoad.frame = CGRect(x: btnMenu.frame.origin.x, y: btnLike.frame.origin.y, width: btnBack.frame.width, height: btnBack.frame.height)
        self.btnDownLoad.setImage(UIImage(named: "DownloadedTab"), for: .normal)
        self.btnDownLoad.addTarget(self, action: #selector(self.DownloadAction), for: .touchUpInside)
        self.playingMusicView.addSubview(btnDownLoad)
        
        if isDownloaded
        {
            self.btnDownLoad.isHidden = true
        }
        
        
        self.progresslbl = UILabel()
        self.progresslbl.font = UIFont(name: Tools.StaticVariables.AppFont, size: 12)
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
        self.btnNext.frame = CGRect(x: btnPlay.frame.origin.x + WPercent * 14, y: btnLike.frame.origin.y, width: btnBack.frame.width, height: btnBack.frame.height)
        self.btnNext.setImage(UIImage(named: "Next"), for: .normal)
        self.btnNext.addTarget(self, action: #selector(self.NextTrack), for: .touchUpInside)
        self.btnNext.isEnabled = false
        
        
        // Previous Music Button
        self.btnPrev = UIButton()
        self.btnPrev.frame = CGRect(x: btnPlay.frame.origin.x - WPercent * 12, y: btnLike.frame.origin.y, width: btnBack.frame.width, height: btnBack.frame.height)
        self.btnPrev.setImage(UIImage(named: "Prev"), for: .normal)
        self.btnPrev.addTarget(self, action: #selector(self.PrevTrack), for: .touchUpInside)
        self.btnPrev.isEnabled = false
    
        
        //Slider bar
        self.musicSlider = UISlider()
        self.musicSlider.frame = CGRect(x: 0, y: btnPlay.frame.origin.y - HPercent * 5, width: W - WPercent * 5, height: 5)
        self.musicSlider.center.x = btnPlay.center.x
        self.musicSlider.setThumbImage(UIImage(named: "SliderThumb"), for: UIControlState())
        self.musicSlider.addTarget(self, action: #selector(self.MusicSliderValueChange), for: .valueChanged)
        self.musicSlider.addTarget(self, action: #selector(self.TouchDownMusicSlider), for: .touchDown)
        self.musicSlider.addTarget(self, action: #selector(self.TouchUpMusicSlider), for: .touchUpInside)
        self.musicSlider.tintColor = UIColor.red
        
        
        
        
        //Remaining Time Label
        self.lblRemainTime = UILabel()
        self.lblRemainTime.text = "00:00"
        self.lblRemainTime.sizeToFit()
        self.lblRemainTime.frame.origin.x = W - lblRemainTime.frame.size.width - WPercent * 2.5
        self.lblRemainTime.frame.origin.y = self.musicSlider.frame.origin.y - lblRemainTime.frame.size.height - 10
        self.lblRemainTime.textColor = UIColor.white
        
        
        self.lblArtistName = TitleLable(tagNum: 0)
        self.lblMusicName = TitleLable(tagNum: 1000)
       
        
        self.lblArtistName.textColor = .white
        self.lblMusicName.textColor = .white
        
        self.lblMusicName.frame.size = CGSize(width: self.playingMusicView.frame.size.width, height: self.playingMusicView.frame.size.height * 0.1)
        
        self.lblArtistName.frame.size = CGSize(width: self.playingMusicView.frame.size.width, height: self.playingMusicView.frame.size.height * 0.05)
        
        
        self.ArtistNameLabel = PlayingMediaManager.ShowingMediaItem.ArtistName
        self.MusicTitleLabel = PlayingMediaManager.ShowingMediaItem.MediaName
        
        // Add components to view
        
        
        self.playingMusicView.addSubview(btnHamrah)
        self.playingMusicView.addSubview(progresslbl)
        self.playingMusicView.bringSubview(toFront: btnHamrah)
        self.playingMusicView.addSubview(btnIranCell)
        self.playingMusicView.addSubview(sepratoreView)
        self.playingMusicView.addSubview(btnBack)
        self.playingMusicView.addSubview(btnMenu)
        self.playingMusicView.addSubview(btnLike)
        self.playingMusicView.addSubview(btnPlay)
        self.playingMusicView.addSubview(btnNext)
        self.playingMusicView.addSubview(btnPrev)
        self.playingMusicView.addSubview(musicSlider)
        self.playingMusicView.addSubview(lblRemainTime)
        self.playingMusicView.addSubview(lblArtistName)
        self.playingMusicView.addSubview(lblMusicName)
        
        self.view.addSubview(self.playingMusicView)
        
    }
    
    func SetMusicListView() -> Void{
        
        
        let viewSize = self.playingMusicView.frame.size
        let viewPosition = self.playingMusicView.frame.origin
        
        
        self.musicListView = UIView()
        self.musicListView.frame = CGRect(x: viewPosition.x ,y: viewPosition.y + viewSize.height, width: viewSize.width, height: Tools.screenHeight * 0.45)
        
        
        // set tableview properties
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(SameArtistCellItem.self, forCellReuseIdentifier: Tools.StaticVariables.cellReuseIdendifier)
        tableView.rowHeight = SameArtistCellItem.cellHeight
        tableView.backgroundColor = .black
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = CGRect(x: 0, y: 0, width: musicListView.frame.width , height: musicListView.frame.height)
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 120, 0);
        tableView.separatorColor = .clear
        
        self.musicListView.addSubview(tableView)
        self.view.addSubview(musicListView)
    }
    
    func SetPopUpMenuView() -> Void{
        
        popUpViewHeight = playingMusicView.frame.size.height * 0.20
        let viewSize = CGSize(width: self.playingMusicView.frame.size.width * 0.43 , height: 0)
        let viewPosition = CGPoint(x: self.playingMusicView.frame.size.width - viewSize.width - Tools.screenWidth * 0.01, y: 0)
        
        
        popUpView = UIView()
        popUpView.frame.size = viewSize
        popUpView.frame.origin = viewPosition
        
        
        shareBtn = Tools.MakeUIButtonWithAttributes(btnName: "اشتراک گذاری",fontSize: 17.0)
        shareBtn.frame = CGRect(x: 0, y: 0, width: popUpView.frame.size.width, height: popUpViewHeight * 0.5)
        shareBtn.backgroundColor = UIColor.darkGray
        self.shareBtn.addTarget(self, action: #selector(self.Sharing), for: UIControlEvents.touchUpInside)
        shareBtn.contentHorizontalAlignment = .left;
        shareBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        
        
        addToFavoriteBtn = Tools.MakeUIButtonWithAttributes(btnName: "",fontSize: 17.0)
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
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        super.viewWillAppear(animated)
        
            ResetTableView()
            GetOtherMedia()
            PlayingMediaManager.CurrentMusicIndex = PlayingMediaManager.FindShowingMediaItemInShowingList()
            print("\n Index  " + String(PlayingMediaManager.CurrentMusicIndex) )
    }
    
    private func PrevAndNextButtonEnableDisable()
    {
        PlayingMediaManager.CurrentMusicIndex = PlayingMediaManager.FindShowingMediaItemInShowingList()
        
        print("Prev Index " + String(PlayingMediaManager.CurrentMusicIndex))
        
        if PlayingMediaManager.ShowingArtistMediaItems.count > 1
        {
            if PlayingMediaManager.IsCurrentMediaFirst()
            {
                self.btnPrev.isEnabled = false
                self.btnNext.isEnabled = true
            }
            else if PlayingMediaManager.IsCurrentMediaLast()
            {
                self.btnPrev.isEnabled = true
                self.btnNext.isEnabled = false
            }
            else if PlayingMediaManager.CurrentMusicIndex == -1
            {
                self.btnNext.isEnabled = false
                self.btnPrev.isEnabled = false
            }
            else{
                self.btnNext.isEnabled = true
                
                self.btnPrev.isEnabled = true
            }
        }
    }
    
    @objc private func GetOtherMedia()
    {
        ServiceManager.GetMediaListByArtist(mediaItem: PlayingMediaManager.ShowingMediaItem, mediaType: .sound, serviceType: PlayingMediaManager.ShowingMediaItem.MediaServiceType, pageNo: 1) { (status, newMedia) in
            if status
            {
                PlayingMediaManager.ShowingArtistMediaItems = newMedia
                
                
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.PrevAndNextButtonEnableDisable()
                }
            }
            
            if self.refreshControl.isRefreshing
            {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    private func LoadData() -> URL
    {
        var myUrl : URL
        
        if let myMedia = MediaManager.IsDownloadedMedia(mediaItem: PlayingMediaManager.ShowingMediaItem)
        {
            PlayingMediaManager.ShowingMediaItem = myMedia
            
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            
            documentsURL.appendPathComponent("MyMedia/." + PlayingMediaManager.ShowingMediaItem.MediaID + ".mp3")
            
            myUrl = documentsURL
            
            isDownloaded = true
        }
        else
        {
            
            
            myUrl = URL(string: PlayingMediaManager.ShowingMediaItem.MediaUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!)!
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            if appDelegate.downloadQueue[String(PlayingMediaManager.ShowingMediaItem.MediaID)] != nil {
                isDownloaded = true
            }
            else
            {
                isDownloaded = false
            }
        }
        
        return myUrl
    }
    
    func CheckNowPlayingMusic(myUrl: URL){
        
        if ((HomeViewController.jukebox?.currentItem?.hashValue) != nil)
        {
            if HomeViewController.jukebox?.currentItem?.URL == myUrl
            {
                HomeViewController.jukebox?.delegate = nil
                HomeViewController.jukebox?.delegate = self
                
                if let currentTime = HomeViewController.jukebox?.currentItem?.currentTime,
                    let duration = PlayingMediaManager.PlayingMediaItem.TimeDouble
                {
                    let value = Float(currentTime / duration)
                    
                    if HomeViewController.jukebox?.state == .playing
                    {
                        btnPlay.setImage(UIImage(named: "Pause"), for: .normal)
                    }
                    
                    musicSlider.value = value
                    populateLabelWithTime(lblRemainTime, time: currentTime)
                }
            }
            else
            {
                HomeViewController.jukebox?.stop()
                HomeViewController.jukebox?.remove(item: (HomeViewController.jukebox?.currentItem)!)
                HomeViewController.jukebox = Jukebox(delegate: self, items: [JukeboxItem(URL: myUrl)])

                HomeViewController.jukebox?.play()
            }
        }
        else
        {
            HomeViewController.jukebox = Jukebox(delegate: self, items: [JukeboxItem(URL: myUrl)])
            HomeViewController.jukebox?.play()
        }
    }
    
    func ResetTableView()
    {
        PlayingMediaManager.ShowingArtistMediaItems.removeAll()
        
        tableView.reloadData()
    }
    
    func resetUI()
    {
        lblRemainTime.text = "00:00"
        musicSlider.value = 0
    }
    
    func appMovedToBackground() {
        print("App moved to background!")
        
        //self.canPlay = false
    }
    
    @objc private func buttonAction(sender: UIButton!) {
        print("Button tapped")
    }
    
    func BackAction(){
        
        var fileInfo = [String:String]()
        fileInfo[Tools.StaticVariables.ChangeDelegateKey] = Tools.StaticVariables.ChangedKey
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Tools.StaticVariables.ChangeDelegateKey), object: nil, userInfo: fileInfo)
        
        
        
        if HomeViewController.jukebox?.state.rawValue == Jukebox.State.playing.rawValue
            && PlayingMediaManager.PlayingMediaItem.MediaID == PlayingMediaManager.ShowingMediaItem.MediaID
            && PlayingMediaManager.ShowingArtistMediaItems.count > 1
        {
            PlayingMediaManager.PlayingArtistMediaItems = PlayingMediaManager.ShowingArtistMediaItems
        }
        
        PlayingMediaManager.ShowingMediaItem = MediaItem()
        PlayingMediaManager.ShowingArtistMediaItems.removeAll()
        
        PlayingMediaManager.CurrentMusicIndex = PlayingMediaManager.FindPlayingMediaItemInPlayingList()
        
        self.dismiss(animated: true,completion: {})
        
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
        if PlayingMediaManager.ShowingMediaItem.HamrahavalCode == ""
        {
            SCLAlertView().showInfo("", subTitle: "کد پیشواز وجود ندارد")
        }
        else
        {
            let messageVC = MFMessageComposeViewController()
            
            messageVC.body = PlayingMediaManager.ShowingMediaItem.HamrahavalCode
            messageVC.recipients = ["8989"]
            messageVC.messageComposeDelegate = self;
            
            self.present(messageVC, animated: false, completion: nil)
        }
    }
    
    @objc private func IrancellAction()
    {
        if PlayingMediaManager.ShowingMediaItem.HamrahavalCode == ""
        {
            SCLAlertView().showInfo("", subTitle: "کد پیشواز وجود ندارد")
        }
        else
        {
            let messageVC = MFMessageComposeViewController()
            
            messageVC.body = PlayingMediaManager.ShowingMediaItem.IrancellCode
            messageVC.recipients = ["7575"]
            messageVC.messageComposeDelegate = self;
            
            self.present(messageVC, animated: false, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        switch (result.rawValue) {
        case MessageComposeResult.cancelled.rawValue:
            SCLAlertView().showInfo("پیغام", subTitle: "ارسال لغو شد")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.failed.rawValue:
            SCLAlertView().showInfo("پیغام", subTitle: "ارسال با خطا مواجه شد")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.sent.rawValue:
            SCLAlertView().showInfo("پیغام", subTitle: "با موفقیت ارسال شد")
            self.dismiss(animated: true, completion: nil)
        default:
            break;
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @objc private func LikeAction()
    {
        if !isLiked
        {
            ServiceManager.LikeOrDwonloadCountAdd(mediaItem: PlayingMediaManager.ShowingMediaItem, isLike: true) { (result) in
                
                if result
                {
                    self.btnLike.setImage(UIImage(named: "Like"), for: .normal)
                    
                    MediaManager.AddNewLikeToDB(mediaItem: PlayingMediaManager.ShowingMediaItem)
                    
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
        appDelegate.downloadQueue[String(PlayingMediaManager.ShowingMediaItem.MediaID)] = "true"
        
        self.btnDownLoad.isHidden = true
        
        
        
        ServiceManager.DownloadMedia(mediaItem: PlayingMediaManager.ShowingMediaItem) { (status) in
            if status
            {
                SCLAlertView().showSuccess("دانلود", subTitle: "موفقیت آمیز بود", closeButtonTitle: "تایید", duration: 1.0)
                
                    //self.btnDownLoad.isHidden = true
                    appDelegate.downloadQueue.removeValue(forKey: String(PlayingMediaManager.ShowingMediaItem.MediaID))
            }
            else
            {
                    
                    self.btnDownLoad.isHidden = false
                    self.progresslbl.isHidden = true
            }
        }
    }
    
    @objc private func MusicSliderValueChange()
    {

    }
    
    @objc private func TouchDownMusicSlider()
    {
        isMusicSliderTouched = true
    }
    
    @objc private func TouchUpMusicSlider()
    {
        if HomeViewController.jukebox?.state == .playing
        {
            HomeViewController.jukebox?.seek(toSecond: Int(Double(musicSlider.value) * PlayingMediaManager.PlayingMediaItem.TimeDouble))
            
            isMusicSliderTouched = false
        }
    }
    
    @objc private func NextTrack()
    {
        btnPrev.isEnabled = true
        
        //HomeViewController.NextTrack(isInRoot: false)
        
        PlayingMediaManager.CurrentMusicIndex += 1
        
        if PlayingMediaManager.CurrentMusicIndex >= PlayingMediaManager.ShowingArtistMediaItems.count - 1
        {
            btnNext.isEnabled = false
        }
        
        PlayingMediaManager.ShowingMediaItem = PlayingMediaManager.ShowingArtistMediaItems[PlayingMediaManager.CurrentMusicIndex]
        
        PlayingMediaManager.SetShowingMediaItemToPlaying()
     
        let url =  LoadData()
        
        CheckNowPlayingMusic(myUrl: url)
        
        SetImageForImageView()
     
        self.btnDownLoad.isHidden = isDownloaded
   
        self.lblMusicName.text = PlayingMediaManager.PlayingMediaItem.MediaName
        self.lblArtistName.text = PlayingMediaManager.PlayingMediaItem.ArtistName
        HomeViewController.totalMusicPlayer.SetNavigateButtonImage(urlString: PlayingMediaManager.PlayingMediaItem.LargpicUrl)
        HomeViewController.totalMusicPlayer.ArtistNameLabel = PlayingMediaManager.PlayingMediaItem.ArtistName
        HomeViewController.totalMusicPlayer.MusicTitleLabel = PlayingMediaManager.PlayingMediaItem.MediaName
        
    }
    
    @objc private func PlayTrack()
    {
        let url = LoadData()
        
        PlayingMediaManager.SetShowingMediaItemToPlaying()
        
        SetImageForImageView()
        
        CheckNowPlayingMusic(myUrl: url)
        
        switch HomeViewController.jukebox?.state.rawValue {

        case Jukebox.State.ready.rawValue? :
            HomeViewController.jukebox?.play(atIndex: 0)

        case Jukebox.State.playing.rawValue? :
            HomeViewController.jukebox?.pause()
        
        case Jukebox.State.paused.rawValue? :
            HomeViewController.jukebox?.play()

        default:
            if HomeViewController.jukebox?.currentItem != nil
            {
                HomeViewController.jukebox?.play()
            }
            else
            {
                HomeViewController.jukebox?.stop()
            }
        }
        
        if !isStartPlaying
        {
            isStartPlaying = true
            
            SetMediaInfo()
            
            HomeViewController.totalMusicPlayer.SetNavigateButtonImage(urlString: PlayingMediaManager.PlayingMediaItem.LargpicUrl)
            HomeViewController.totalMusicPlayer.ArtistNameLabel = PlayingMediaManager.PlayingMediaItem.ArtistName
            HomeViewController.totalMusicPlayer.MusicTitleLabel = PlayingMediaManager.PlayingMediaItem.MediaName
        }
    }
    
    @objc private func PrevTrack()
    {
        btnNext.isEnabled = true
        
        //HomeViewController.PrevTrack(isInRoot: false)
        
        PlayingMediaManager.CurrentMusicIndex -= 1
        
        if PlayingMediaManager.CurrentMusicIndex <= 0
        {
            btnPrev.isEnabled = false
        }
        
        PlayingMediaManager.ShowingMediaItem = PlayingMediaManager.ShowingArtistMediaItems[PlayingMediaManager.CurrentMusicIndex]
     
        PlayingMediaManager.SetShowingMediaItemToPlaying()
        
        let url =  LoadData()
        
        CheckNowPlayingMusic(myUrl: url)
        
        SetImageForImageView()
        
        btnDownLoad.isHidden = isDownloaded
        
        
        self.lblMusicName.text = PlayingMediaManager.PlayingMediaItem.MediaName
        self.lblArtistName.text = PlayingMediaManager.PlayingMediaItem.ArtistName
     
        HomeViewController.totalMusicPlayer.SetNavigateButtonImage(urlString: PlayingMediaManager.PlayingMediaItem.LargpicUrl)
        HomeViewController.totalMusicPlayer.ArtistNameLabel = PlayingMediaManager.PlayingMediaItem.ArtistName
        HomeViewController.totalMusicPlayer.MusicTitleLabel = PlayingMediaManager.PlayingMediaItem.MediaName
        
    }
    
    @objc private func UpdateDownloadProgressLabel(notification: NSNotification)
    {
        let tmp : [String  : String] = notification.userInfo! as! [String : String]
        
        // if notification received, change label value
        let id = tmp[Tools.StaticVariables.MediaIdNotificationsKey] as String!
        let current = tmp[Tools.StaticVariables.ProgressNotificationsKey] as String!

        if String(PlayingMediaManager.ShowingMediaItem.MediaID) == id
            {
                if current == "100"
                {
                    self.progresslbl.isHidden = false
                    self.progresslbl.text = ""
                }
                else
                {
                    self.btnDownLoad.isHidden = true
                    self.progresslbl.isHidden = false
                    self.progresslbl.text = current! + "%"
                    self.progresslbl.sizeToFit()
                    self.progresslbl.center = self.btnDownLoad.center
                }
            }

        
    }
    
    private var artWorkImage: UIImage!
    
    func SetImageForImageView()
    {
        let mySize = musicImage.frame.size
        
        let myImage = DataCacheManager.ShareInstance.cachedImage(urlString: PlayingMediaManager.ShowingMediaItem.LargpicUrl)
        
        if let mImage = myImage
        {
            artWorkImage  = mImage
            
            PlayingMediaManager.CurrentMediaImage = mImage

            musicImage.image = Tools.cropToBounds(image: mImage, width: Double(mySize.width), height: Double(mySize.height))
        }
        else
        {
            ServiceManager.DownloadImage(urlString: PlayingMediaManager.ShowingMediaItem.LargpicUrl, completion: {
                (newImage) in
                
                
                DataCacheManager.ShareInstance.cacheImage(image: newImage!, urlString: PlayingMediaManager.ShowingMediaItem.LargpicUrl)
                
                self.musicImage.image = Tools.cropToBounds(image: newImage!, width: Double(mySize.width), height: Double(mySize.height))
                
                self.artWorkImage  = newImage
                
                PlayingMediaManager.CurrentMediaImage = newImage
                
            })
        }
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
        let text = PlayingMediaManager.ShowingMediaItem.ShareUrl
        
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
            let res = MediaManager.AddNewFavoriteToDB(mediaItems: [PlayingMediaManager.ShowingMediaItem])
            
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
            let res = MediaManager.DeleteDBFavorites(mediaItem: PlayingMediaManager.ShowingMediaItem)
            
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
    
    override func viewDidAppear(_ animated: Bool) {
        
       _ = self.becomeFirstResponder()
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
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
        
        if let currentTime = jukebox.currentItem?.currentTime, let duration = PlayingMediaManager.PlayingMediaItem.TimeDouble
        {
            let value = Float(currentTime / duration)
            
            if currentTime >= duration
            {
                if btnNext.isEnabled
                {
                    NextTrack()
                }
            }
            else{
            if !isMusicSliderTouched
            {
               musicSlider.value = value
            }
            
            populateLabelWithTime(lblRemainTime, time: currentTime)
            }
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
            HomeViewController.totalMusicPlayer.SetPlayButtonImage(isPlaying: imageName == "Pause" ? true : false)
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
                HomeViewController.jukebox?.play()
                canPlay = true
            case .remoteControlPause :
                HomeViewController.jukebox?.pause()
                
                canPlay = false
            case .remoteControlNextTrack :
                HomeViewController.jukebox?.playNext()
            case .remoteControlPreviousTrack:
                HomeViewController.jukebox?.playPrevious()
            case .remoteControlTogglePlayPause:
                if HomeViewController.jukebox?.state == .playing {
                    HomeViewController.jukebox?.pause()
                } else {
                    HomeViewController.jukebox?.play()
                }
            default:
                break
            }
            
            print(MPNowPlayingInfoCenter.default().nowPlayingInfo)
            
            
        }
    }
    
    private func SetMediaInfo()
    {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyArtist: PlayingMediaManager.PlayingMediaItem.ArtistName,
            MPMediaItemPropertyTitle: PlayingMediaManager.PlayingMediaItem.MediaName,
//            MPMediaItemPropertyArtwork : MPMediaItemArtwork(image: artWorkImage),
            MPNowPlayingInfoPropertyPlaybackRate: 1
        ]
        
        if let p = artWorkImage
        {
            MPNowPlayingInfoCenter.default().nowPlayingInfo? [MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: p)
        }
    
        print(MPNowPlayingInfoCenter.default().nowPlayingInfo)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return PlayingMediaManager.ShowingArtistMediaItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellSize = CGSize(width: Tools.screenWidth, height: SameArtistCellItem.cellHeight)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Tools.StaticVariables.cellReuseIdendifier, for: indexPath as IndexPath) as! SameArtistCellItem
        
        cell.cellMedia = PlayingMediaManager.ShowingArtistMediaItems[indexPath.row]
        
        cell.MusicTitleLabel = cell.cellMedia.MediaName
        cell.SingerNameLabel = cell.cellMedia.ArtistName
        
        cell.musicImage.image = nil
        
        print("Cell Height: \(cell.frame.size.height)")
        
        cell.frame.size = cellSize
        
        let p =  URL(string:PlayingMediaManager.ShowingArtistMediaItems[indexPath.row].LargpicUrl)!
        
        cell.musicImage.af_setImage(withURL:p)
        
        print("TableView Row Height: \(tableView.rowHeight)")
        
        print("TableView Row Height estimate: \(tableView.estimatedRowHeight)")
        
        print("Cell Height: \(cell.frame.size.height)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        //HomeViewController.jukebox?.stop()
        
        PlayingMediaManager.CurrentMusicIndex = indexPath.row
        
        print("\n table in Music  " + String(PlayingMediaManager.CurrentMusicIndex))
        
        let p = PlayingMediaManager.ShowingArtistMediaItems[PlayingMediaManager.CurrentMusicIndex]
        
        PlayingMediaManager.ShowingMediaItem = p
        
        PlayingMediaManager.SetShowingMediaItemToPlaying()
        
        PrevAndNextButtonEnableDisable()
        
            let url = LoadData()
        
            CheckNowPlayingMusic(myUrl: url)
      
        SetImageForImageView()
        
        for sub in self.playingMusicView.subviews
        {
            if sub == self.btnDownLoad
            {
                sub.isHidden = self.isDownloaded
            }
        }
        
        self.lblMusicName.text = PlayingMediaManager.PlayingMediaItem.MediaName
        self.lblArtistName.text = PlayingMediaManager.PlayingMediaItem.ArtistName
        HomeViewController.totalMusicPlayer.SetNavigateButtonImage(urlString: PlayingMediaManager.PlayingMediaItem.LargpicUrl)
        HomeViewController.totalMusicPlayer.ArtistNameLabel = PlayingMediaManager.PlayingMediaItem.ArtistName
        HomeViewController.totalMusicPlayer.MusicTitleLabel = PlayingMediaManager.PlayingMediaItem.MediaName
        
        
    }
}
