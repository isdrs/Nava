//
//  FavoriteCellItem.swift
//  nava
//
//  Created by Mohammad Lashgarbolouk on 11/10/16.
//  Copyright © 2016 manshor. All rights reserved.
//

import UIKit
import Alamofire
import SCLAlertView

class SameArtistCellItem : UITableViewCell {
    
    
    var cellMedia : MediaItem!
    {
        didSet{
            
            isLiked = MediaManager.IsLikedMedia(mediaItem: cellMedia)
            
            if isLiked
            {
                self.likeBtn.setImage(UIImage(named: "Like"), for: .normal)
            }
            else
            {
                self.likeBtn.setImage(UIImage(named: "UnLike"), for: .normal)
                self.likeBtn.addTarget(self, action: #selector(self.LikeAction), for: .touchUpInside)
            }
            
            
            if MediaManager.IsDownloadedMedia(mediaItem: cellMedia) == nil
            {
                self.downloadBtn.setImage(UIImage(named: "DownloadedTab"), for: .normal)
                self.downloadBtn.addTarget(self, action: #selector(self.DownloadAction), for: .touchUpInside)
                self.infoPanelView.addSubview(downloadBtn)
            }
        }
        
    }
    
    
    static let cellHeight = Tools.screenHeight * CGFloat(0.20)
    var musicImage : UIImageView!
    private var likeBtn : UIButton!
    private var downloadBtn : UIButton!
    private var musicTitlelbl : UILabel!
    private var singerNamelbl : UILabel!
    private var infoPanelView : UIView!
    private var shareBtn : UIButton!
    
    private var progresslbl : UILabel!
    
    private var cellSize : CGSize!
    
    private var cellPosition : CGPoint!
    
    private var isLiked : Bool = false

    
    var MusicTitleLabel : String {
        get {
            return self.musicTitlelbl.text!
        }
        set {
            self.musicTitlelbl.text = newValue
            self.musicTitlelbl.sizeToFit()
            self.musicTitlelbl.frame.origin = CGPoint(x: self.infoPanelView.frame.size.width - self.musicTitlelbl.frame.size.width - cellSize.width * 0.02, y:infoPanelView.frame.size.height * 0.2)
        }
    }
    
    var SingerNameLabel : String {
        get {
            return self.singerNamelbl.text!
        }
        set {
            self.singerNamelbl.text = newValue
            self.singerNamelbl.sizeToFit()
            self.singerNamelbl.frame.origin = CGPoint(x: self.infoPanelView.frame.size.width - self.singerNamelbl.frame.size.width - cellSize.width * 0.02, y: infoPanelView.frame.size.height * 0.5)
        }
    }
    
    func LikeAction()
    {
        if !isLiked
        {
            ServiceManager.LikeOrDwonloadCountAdd(mediaItem: cellMedia, isLike: true) { (result) in
                
                if result
                {
                    self.likeBtn.setImage(UIImage(named: "Like"), for: .normal)
                    
                    MediaManager.AddNewLikeToDB(mediaItem: self.cellMedia)
                    
                    self.isLiked = true
                    
                }
                else
                {
                    self.isLiked = false
                }
            }
        }
    }
    
    func SharingAction()
    {
        let text = cellMedia.ShareUrl
        
        let vc = UIApplication.topViewController()
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = vc?.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        vc?.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc private func DownloadAction()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.downloadQueue[String(cellMedia.MediaID)] = "true"
        
        downloadBtn.isHidden = true
        downloadBtn.isEnabled = false
        
        
        ServiceManager.DownloadMedia(mediaItem: cellMedia) { (status) in
            if status
            {
                SCLAlertView().showSuccess("دانلود", subTitle: "موفقیت آمیز بود", closeButtonTitle: "تایید", duration: 1.0)
                
                self.downloadBtn.isHidden = true
                appDelegate.downloadQueue.removeValue(forKey: String(self.cellMedia.MediaID))
            }
            else
            {
                self.downloadBtn.isEnabled = true
                self.downloadBtn.isHidden = false
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
        
        if String(cellMedia.MediaID) == id
        {
            if current == "100"
            {
                self.progresslbl.isHidden = true
            }
            else{
                self.downloadBtn.isHidden = true
                self.progresslbl.isHidden = false
                self.progresslbl.text = current! + "%"
                self.progresslbl.sizeToFit()
                self.progresslbl.center = self.downloadBtn.center
            }
        }
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.UpdateDownloadProgressLabel), name: NSNotification.Name(rawValue: Tools.StaticVariables.DownloadProgressNotificationKey ), object: nil)
        
        let buttonSize = CGSize(width: Tools.screenWidth * 0.05, height: Tools.screenWidth * 0.05)
        cellSize = CGSize(width: Tools.screenWidth, height: SameArtistCellItem.cellHeight)
        cellPosition = CGPoint()
        self.frame.size = cellSize
        self.contentView.frame.size = cellSize
        
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        //self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 0.5
        self.layer.masksToBounds = true
        
        
        // set info Panel
        infoPanelView = UIView()
        infoPanelView.backgroundColor = UIColor.black.withAlphaComponent(1)
        infoPanelView.frame.size = CGSize(width: cellSize.width * 0.65, height: cellSize.height)
        infoPanelView.frame.origin = CGPoint(x: 0, y: 0)
    
        
        
        // set image of cell properties
        musicImage = UIImageView()
        musicImage.frame = CGRect(x: self.infoPanelView.frame.size.width, y: 0 , width: cellSize.width - infoPanelView.frame.size.width , height: cellSize.height)
        
        
        
        // Like Button
        likeBtn = UIButton()
        likeBtn.frame.size =  CGSize(width: buttonSize.width, height: buttonSize.height)
        likeBtn.frame.origin = CGPoint(x: buttonSize.width, y: infoPanelView.frame.size.height * 0.8)
        
        // Download Button
        downloadBtn = UIButton()
        downloadBtn.frame.size =  CGSize(width: buttonSize.width, height: buttonSize.height)
        downloadBtn.frame.origin = CGPoint(x: buttonSize.width * 5, y: likeBtn.frame.origin.y)

        
        self.progresslbl = UILabel()
        self.progresslbl.font = UIFont(name: "Arial", size: 12)
        self.progresslbl.center = self.downloadBtn.center
        self.progresslbl.textColor = UIColor.white
        self.progresslbl.isHidden = true

        
        // Music Button
        shareBtn = UIButton()
        shareBtn.frame.size =  CGSize(width: buttonSize.width, height: buttonSize.height)
        shareBtn.frame.origin = CGPoint(x: buttonSize.width * 3, y: likeBtn.frame.origin.y)
        shareBtn.setImage(UIImage(named: "Share"), for: .normal)
        self.shareBtn.addTarget(self, action: #selector(self.SharingAction), for: .touchUpInside)
        
 
        // Singer Title
        singerNamelbl = UILabel()
        singerNamelbl.text =  ""
        singerNamelbl.textColor = UIColor.white
        
        // Singer Title
        musicTitlelbl = UILabel()
        musicTitlelbl.text =  ""
        musicTitlelbl.textColor = UIColor.white
        
        
        self.contentView.addSubview(musicImage)
        self.infoPanelView.addSubview(likeBtn)
        self.infoPanelView.addSubview(shareBtn)
        self.infoPanelView.addSubview(musicTitlelbl)
        self.infoPanelView.addSubview(singerNamelbl)
        self.infoPanelView.addSubview(progresslbl)
        self.contentView.addSubview(infoPanelView)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
