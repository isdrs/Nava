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
import AVKit
import AVFoundation
import AlamofireImage
import SCLAlertView

class VideoPlayerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var mediaItem : MediaItem!
    private var singerMediaItems : [MediaItem] = [MediaItem]()
    
    private var mainPlayingView : UIView!
    private var videoControllerView : UIView!
    private var videoMenuBarView : UIView!
    private var videoPlayerView : UIView!
    
    private var musicListView : UIView!
    
    private var tableView : UITableView!
    
    private var btnBack : UIButton!
    private var btnMenu : UIButton!

    private var progresslbl : UILabel!

    private var btnLike : UIButton!
    private var btnDownLoad : UIButton!
    
    
    private var lblArtistName : UILabel!
    private var lblMusicname : UILabel!
    
    
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
                                                                 attributes: [NSForegroundColorAttributeName : UIColor.white,NSUnderlineStyleAttributeName : 0])
                let myNormalAttributedTitle2 = NSAttributedString(string: Tools.StaticVariables.AddToFavoriteButtonTitle,
                                                                  attributes: [NSForegroundColorAttributeName : UIColor.green,NSUnderlineStyleAttributeName : 0])
                
                addToFavoriteBtn.setAttributedTitle(myNormalAttributedTitle, for: .normal)
                addToFavoriteBtn.setAttributedTitle(myNormalAttributedTitle2, for: .highlighted)
                
            }else
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
    var playerController : AVPlayerViewController?
    
    @objc private func buttonAction(sender: UIButton!) {
        print("Button tapped")
    }
    
    func BackAction()
    {
        
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
    
//    @objc private func PlayAction()
//    {
//        PlayVideo(myUrl: URL(string: mediaItem.MediaUrl)!)
//    }
    
    override func viewDidLoad() {
        
        HomeViewController.jukebox?.pause()
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton(_:)))
        
        self.view.addGestureRecognizer(tapGesture)
        
        tapGesture.cancelsTouchesInView = false
        
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        print("view frame: \( self.view.frame)")
        
        // begin receiving remote events
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        LoadData()
        
        SetPlayingVideoView()
        SetVideoListView()
        SetPopUpMenuView()
        UpdateNamesLabel()
        SetVideoPlayerView(myUrl: URL(string: mediaItem.MediaUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!)!)
        
        isFavorited = MediaManager.IsFavoritedMedia(mediaItem: mediaItem)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.UpdateDownloadProgressLabel), name: NSNotification.Name(rawValue: Tools.StaticVariables.DownloadProgressNotificationKey ), object: nil)
        
    }
    
    func SetPlayingVideoView() -> Void{
        let W = Tools.screenWidth
        let H =  Tools.screenHeight * 0.65
        let X = CGFloat()
        let Y = Tools.YDiffer
        let WPercent = W / 100.0
        let HPercent = H / 100.0
        
        
        
        self.mainPlayingView = UIView()
        self.mainPlayingView.frame = CGRect(x: X ,y:  Y, width: W, height: H)
        self.mainPlayingView.backgroundColor = .black
        
        
        self.videoMenuBarView = UIView()
        self.videoMenuBarView.frame = CGRect(x: X ,y: 0, width: W, height: H * 0.1)
        self.videoMenuBarView.backgroundColor = .black
        
        
        //Back Button
        self.btnBack = UIButton()
        self.btnBack.frame = CGRect(x: X + WPercent * 3 , y: HPercent * 2 , width: WPercent * 5 , height: WPercent * 5)
        self.btnBack.setImage(UIImage(named: "Back"), for: .normal)
        self.btnBack.addTarget(self, action: #selector(self.BackAction), for: .touchUpInside)
        
        
        //Menu Button
        self.btnMenu = UIButton()
        self.btnMenu.frame = CGRect(x: W - btnBack.frame.size.width  - btnBack.frame.origin.x, y: btnBack.frame.origin.y, width: btnBack.frame.width, height: btnBack.frame.height)
        self.btnMenu.setImage(UIImage(named: "SubMenu"), for: .normal)
        self.btnMenu.addTarget(self, action: #selector(self.MenuAction), for: .touchUpInside)
        
        self.videoMenuBarView.addSubview(self.btnBack)
        self.videoMenuBarView.addSubview(self.btnMenu)
        ///--------------------------------------------
        
        
        self.videoControllerView = UIView()
        self.videoControllerView.frame = CGRect(x: 0, y: self.videoMenuBarView.frame.size.height, width: W, height: self.videoMenuBarView.frame.size.height)
        self.videoControllerView.backgroundColor = UIColor.black
        
        
        //Like Button
        self.btnLike = UIButton()
        self.btnLike.frame.size = CGSize(width: W * 0.065, height: W * 0.065)
        self.btnLike.frame.origin = CGPoint(x: (self.btnBack.frame.origin.x) , y: 0)
        self.btnLike.center.y = self.videoControllerView.frame.size.height * 0.5
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
        self.btnDownLoad.frame.size = self.btnLike.frame.size
        self.btnDownLoad.frame.origin = CGPoint(x: self.btnLike.frame.size.width * 1.2 + self.btnLike.frame.origin.x  , y: 0)
        self.btnDownLoad.center.y = self.videoControllerView.frame.size.height * 0.5
        self.btnDownLoad.center.y = self.btnLike.center.y
        if !isDownloaded
        {
            self.btnDownLoad.setImage(UIImage(named: "DownloadedTab"), for: .normal)
            self.btnDownLoad.addTarget(self, action: #selector(self.DownloadAction), for: .touchUpInside)
            self.mainPlayingView.addSubview(btnDownLoad)
        }
        
        self.progresslbl = UILabel()
        self.progresslbl.font = UIFont(name: Tools.StaticVariables.AppFont, size: 12)
        self.progresslbl.center = self.btnDownLoad.center
        self.progresslbl.textColor = UIColor.white
        self.progresslbl.isHidden = true
        
        self.lblMusicname = UILabel()
        
        self.lblArtistName = UILabel()
        
        self.videoControllerView.addSubview(self.lblMusicname)
        
        self.videoControllerView.addSubview(self.lblArtistName)
        
        self.videoControllerView.addSubview(self.btnLike)
        self.videoControllerView.addSubview(self.btnDownLoad)
        self.videoControllerView.addSubview(self.progresslbl)
        
        
        
        
        self.videoPlayerView = UIView()
        self.videoPlayerView.frame = CGRect(x: 0, y: self.videoMenuBarView.frame.size.height * 2, width: W, height: self.mainPlayingView.frame.size.height - self.videoMenuBarView.frame.size.height * 2)

        
        // Add components to view
        
        self.mainPlayingView.addSubview(self.videoMenuBarView)
        self.mainPlayingView.addSubview(videoControllerView)
        self.mainPlayingView.addSubview(videoPlayerView)
        
        self.view.addSubview(self.mainPlayingView)
        
    }
    
    func UpdateNamesLabel()
    {

        
        lblMusicname.text = mediaItem.MediaName
        
        lblArtistName.text = mediaItem.ArtistName
        
        lblMusicname.textColor = .white
        
        lblArtistName.textColor = .white
        
        
        self.lblMusicname.sizeToFit()
        
        self.lblArtistName.sizeToFit()
        
        
        self.lblMusicname.textAlignment = .right
        self.lblArtistName.textAlignment = .right

        
        self.lblMusicname.frame.origin.x = self.videoControllerView.frame.size.width - lblMusicname.frame.size.width - Tools.screenWidth * 0.03
        self.lblMusicname.center.y =  self.videoControllerView.frame.size.height * 0.25
        
        self.lblArtistName.frame.origin.x = self.videoControllerView.frame.size.width - lblArtistName.frame.size.width - Tools.screenWidth * 0.03
        self.lblArtistName.center.y =  self.videoControllerView.frame.size.height * 0.65
        
    }
    
    
    func SetVideoListView() -> Void{
        
        
        let viewSize = self.mainPlayingView.frame.size
        let viewPosition = self.mainPlayingView.frame.origin
        
        
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
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
        
        self.musicListView.addSubview(tableView)
        self.view.addSubview(musicListView)
    }
    
    func SetPopUpMenuView() -> Void{
        
        
        popUpViewHeight = mainPlayingView.frame.size.height * 0.20
        let viewSize = CGSize(width: self.mainPlayingView.frame.size.width * 0.43 , height: 0)
        let viewPosition = CGPoint(x: self.mainPlayingView.frame.size.width - viewSize.width - Tools.screenWidth * 0.01, y: 0)
        
        
        popUpView = UIView()
        popUpView.frame.size = viewSize
        popUpView.frame.origin = viewPosition
        
        
        shareBtn = Tools.MakeUIButtonWithAttributes(btnName: "اشتراک گذاری",fontSize: 19.0)
        shareBtn.frame = CGRect(x: 0, y: 0, width: popUpView.frame.size.width, height: popUpViewHeight * 0.5)
        shareBtn.backgroundColor = UIColor.darkGray
        self.shareBtn.addTarget(self, action: #selector(self.Sharing), for: UIControlEvents.touchUpInside)
        shareBtn.contentHorizontalAlignment = .left;
        shareBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        
        
        addToFavoriteBtn = Tools.MakeUIButtonWithAttributes(btnName: "",fontSize: 19.0)
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
        self.mainPlayingView.addSubview(popUpView)
        
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
        
        GetOtherMedia()
    }
    
    
    private func GetOtherMedia()
    {
        ServiceManager.GetMediaListByArtist(mediaItem: mediaItem, mediaType: .video, serviceType: mediaItem.MediaServiceType, pageNo: 1) { (status, newMedia) in
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
        if let myMedia = MediaManager.IsDownloadedMedia(mediaItem: mediaItem)
        {
            mediaItem = myMedia
            
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            
            documentsURL.appendPathComponent("MyMedia/." + mediaItem.MediaID + ".mp4")
            
            isDownloaded = true
        }
        else
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            if appDelegate.downloadQueue[String(mediaItem.MediaID)] != nil {
                isDownloaded = true
            }
            else
            {
                isDownloaded = false
            }
            
        }
    }
    
    func SetVideoPlayerView(myUrl: URL)
    {
        
        let player = AVPlayer(url: myUrl)
        
        self.playerController = AVPlayerViewController()
        
        self.playerController!.view.frame.size = videoPlayerView.frame.size
        
        self.playerController!.player = player
        
        self.videoPlayerView.addSubview(self.playerController!.view)
        
        //self.playerController!.player?.play()
    }
    
    func PlayerVideoChangeSource(myUrl: URL)
    {
        let player = AVPlayer(url: myUrl)
        
        self.playerController!.player = player
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
        
        let cellSize = CGSize(width: Tools.screenWidth, height: SameArtistCellItem.cellHeight)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Tools.StaticVariables.cellReuseIdendifier, for: indexPath as IndexPath) as! SameArtistCellItem
        
        cell.cellMedia = singerMediaItems[indexPath.row]
        
        cell.MusicTitleLabel = cell.cellMedia.MediaName
        cell.SingerNameLabel = cell.cellMedia.ArtistName
        
        cell.musicImage.image = nil
        
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
        
        self.mediaItem = singerMediaItems[indexPath.row]
        
        UpdateNamesLabel()
        
        LoadData()
        
        PlayerVideoChangeSource(myUrl: URL(string: mediaItem.MediaUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!)!)
        
        GetOtherMedia()
        
    }
}
