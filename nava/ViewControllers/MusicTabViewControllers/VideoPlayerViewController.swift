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
    
    private var playingVideoView : UIView!
    private var musicListView : UIView!
    
    private var tableView : UITableView!
    
    private var btnBack : UIButton!
    private var btnMenu : UIButton!

    private var progresslbl : UILabel!

    private var btnPlay : UIButton!
    private var btnLike : UIButton!
    private var btnDownLoad : UIButton!
    private var videoImage : UIImageView!
    
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
    
    @objc private func PlayAction()
    {
        PlayVideo(myUrl: URL(string: mediaItem.MediaUrl)!)
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
        
        SetPlayingVideoView()
        SetVideoListView()
        SetPopUpMenuView()
        
        isFavorited = MediaManager.IsFavoritedMedia(mediaItem: mediaItem)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.UpdateDownloadProgressLabel), name: NSNotification.Name(rawValue: Tools.StaticVariables.DownloadProgressNotificationKey ), object: nil)
        
    }
    
    func SetPlayingVideoView() -> Void{
        let W = Tools.screenWidth
        let H =  Tools.screenHeight * 0.65
        let X = CGFloat()
        let Y = Tools.screenHeight * 0.03
        let WPercent = W / 100.0
        let HPercent = H / 100.0
        
        
        self.playingVideoView = UIView()
        self.playingVideoView.frame = CGRect(x: X ,y:  Y, width: W, height: H)
        self.playingVideoView.backgroundColor = .black
        
        
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
        self.videoImage = UIImageView()
        self.videoImage.frame = CGRect(x: 0, y: 0, width: Tools.screenWidth, height: playingVideoView.frame.height * 0.90)
        self.videoImage.af_setImage(withURL: URL(string:mediaItem.LargpicUrl)!)
        self.playingVideoView.addSubview(videoImage)
        
        
        //Irancell and Hamrah Aval Button
        self.btnHamrah = Tools.MakeUIButtonWithAttributes(btnName: "پیشواز همراه اول",fontSize: 19.0)
        self.btnHamrah.frame.size = CGSize(width: playingVideoView.frame.size.width * 0.48, height: playingVideoView.frame.height * 0.08)
        self.btnHamrah.frame.origin = CGPoint(x: Tools.screenWidth * 0.01, y: 0)
        self.btnHamrah.center.y =  playingVideoView.frame.height * 0.95
        self.btnHamrah.backgroundColor = UIColor.gray
        self.btnHamrah.layer.cornerRadius = 5
        self.btnHamrah.addTarget(self, action: #selector(self.HamrahAvvalAction), for: UIControlEvents.touchUpInside)
        
        
        // Irancell
        self.btnIranCell = Tools.MakeUIButtonWithAttributes(btnName: "پیشواز ایرانسل",fontSize: 19.0)
        self.btnIranCell.frame.size = btnHamrah.frame.size
        self.btnIranCell.frame.origin = CGPoint(x: playingVideoView.frame.size.width - btnIranCell.frame.size.width - Tools.screenWidth * 0.01, y: btnHamrah.frame.origin.y)
        self.btnIranCell.backgroundColor = UIColor.gray
        self.btnIranCell.layer.cornerRadius = 5
        self.btnIranCell.addTarget(self, action: #selector(self.IrancellAction), for: UIControlEvents.touchUpInside)
        
        
        // seperator view
        let sepratoreView = UIView()
        sepratoreView.backgroundColor = UIColor.white
        sepratoreView.frame = CGRect(x: 0, y: 0, width: 1, height: btnHamrah.frame.size.height * 0.8)
        sepratoreView.center = CGPoint(x: Tools.screenWidth * 0.02 + btnHamrah.frame.size.width, y: btnHamrah.center.y)
        
        
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
            self.playingVideoView.addSubview(btnDownLoad)
        }
        
        self.progresslbl = UILabel()
        self.progresslbl.font = UIFont(name: "Arial", size: 12)
        self.progresslbl.center = self.btnDownLoad.center
        self.progresslbl.textColor = UIColor.white
        self.progresslbl.isHidden = true
        
        
        
        // Play Button
        self.btnPlay = UIButton()
        self.btnPlay.frame = CGRect(x:0, y: 0, width: btnBack.frame.width * 1.5, height: btnBack.frame.height * 1.5)
        self.btnPlay.center = videoImage.center
        self.btnPlay.setImage(UIImage(named: "Play"), for: .normal)
        self.btnPlay.addTarget(self, action: #selector(self.PlayAction), for: .touchUpInside)
        
        
        // Add components to view
        
        self.playingVideoView.addSubview(sepratoreView)
        self.playingVideoView.addSubview(btnHamrah)
        self.playingVideoView.addSubview(progresslbl)
        self.playingVideoView.bringSubview(toFront: btnHamrah)
        self.playingVideoView.addSubview(btnIranCell)
        self.playingVideoView.addSubview(btnBack)
        self.playingVideoView.addSubview(btnMenu)
        self.playingVideoView.addSubview(btnPlay)
        
        
        self.view.addSubview(self.playingVideoView)
        
    }
    
    func SetVideoListView() -> Void{
        
        
        let viewSize = self.playingVideoView.frame.size
        let viewPosition = self.playingVideoView.frame.origin
        
        
        self.musicListView = UIView()
        self.musicListView.frame = CGRect(x: viewPosition.x ,y: viewPosition.y + viewSize.height, width: viewSize.width, height: Tools.screenHeight * 0.45)
        
        
        // set tableview properties
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(MediaCell.self, forCellReuseIdentifier: Tools.StaticVariables.cellReuseIdendifier)
        tableView.rowHeight = MediaCell.cellHeight
        tableView.backgroundColor = .black
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = CGRect(x: 0, y: 0, width: musicListView.frame.width , height: musicListView.frame.height)
        
        
        self.musicListView.addSubview(tableView)
        self.view.addSubview(musicListView)
    }
    
    func SetPopUpMenuView() -> Void{
        
        popUpViewHeight = playingVideoView.frame.size.height * 0.26
        let viewSize = CGSize(width: self.playingVideoView.frame.size.width * 0.6 , height: 0)
        let viewPosition = CGPoint(x: self.playingVideoView.frame.size.width - viewSize.width - Tools.screenWidth * 0.01, y: 0)
        
        
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
        self.playingVideoView.addSubview(popUpView)
        
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
    
    func PlayVideo(myUrl: URL)
    {
        
        let playerView = PlayerViewController()
        
        playerView.myUrl = URL(string: mediaItem.MediaUrl)!
        
        self.present(playerView, animated: true) { 
            
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
        
        let cellSize = CGSize(width: Tools.screenWidth, height: Tools.screenHeight * 0.25)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Tools.StaticVariables.cellReuseIdendifier, for: indexPath as IndexPath) as! MediaCell
        
        
        
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
        
        LoadData()
    }
}
