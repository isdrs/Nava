//
//  FavoriteCellitem.swift
//  nava
//
//  Created by Mohammad Lashgarbolouk on 11/10/16.
//  Copyright © 2016 manshor. All rights reserved.

import UIKit
import Alamofire
import SCLAlertView

protocol FavoriteCellItemDelegate
{
    func LoadData()
}

class FavoriteCellItem: UITableViewCell
{
    var delegate:FavoriteCellItemDelegate! = nil
    
    var cellMedia : MediaItem!
    static let cellHeight = MediaCell.cellHeight
    var musicImage : UIImageView!
    private var musicTitlelbl : UILabel!
    private var singerNamelbl : UILabel!
    private var infoPanelView : UIView!
    private var removeFavoriteBtn : UIButton!
    private var shareBtn : UIButton!
    
    
    private var cellSize : CGSize!
    
    private var cellPosition : CGPoint!
    
    
    var MusicTitleLabel : String {
        get {
            return self.musicTitlelbl.text!
        }
        set {
            self.musicTitlelbl.text = newValue
            self.musicTitlelbl.sizeToFit()
            self.musicTitlelbl.frame.origin = CGPoint(x: self.infoPanelView.frame.size.width - self.musicTitlelbl.frame.size.width - cellSize.width * 0.05, y: infoPanelView.frame.height * 0.15)
        }
    }
    
    var SingerNameLabel : String {
        get {
            return self.singerNamelbl.text!
        }
        set {
            self.singerNamelbl.text = newValue
            self.singerNamelbl.sizeToFit()
            self.singerNamelbl.frame.origin = CGPoint(x: self.infoPanelView.frame.size.width - self.singerNamelbl.frame.size.width - cellSize.width * 0.05, y: infoPanelView.frame.height * 0.6)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
    }
    
    @objc func RemoveAction()
    {
        let res = MediaManager.DeleteDBFavorites(mediaItem: self.cellMedia)
        
        if res
        {
            SCLAlertView().showSuccess("", subTitle: "انجام شد", closeButtonTitle: "تایید", duration: 1.0)
            
            self.delegate.LoadData()
        }
        else
        {
            SCLAlertView().showError("", subTitle: "انجام نشد", closeButtonTitle: "تایید", duration: 1.0)
        }
    }

    @objc func SharingAction()
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

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let buttonSize = CGSize(width: Tools.screenWidth * 0.05, height: Tools.screenWidth * 0.05)
        cellSize = CGSize(width: Tools.screenWidth, height: MediaCell.cellHeight)
        cellPosition = CGPoint()
        self.frame.size = cellSize
        self.contentView.frame.size = cellSize
        
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.layer.masksToBounds = true
        
        
        // set info Panel
        infoPanelView = UIView()
        infoPanelView.backgroundColor = UIColor.black.withAlphaComponent(1)
        infoPanelView.frame.size = CGSize(width: cellSize.width, height: cellSize.height * 0.2)
        infoPanelView.frame.origin = CGPoint(x: 0, y: cellSize.height - infoPanelView.frame.size.height)
        
        
        // set image of cell properties
        musicImage = UIImageView()
        musicImage.frame = CGRect(x: cellPosition.x, y: cellPosition.y , width: cellSize.width, height: cellSize.height * 0.8)
        
        
        
        //Set Share Button properties
        shareBtn = UIButton()
        shareBtn.frame.size =  CGSize(width: buttonSize.width, height: buttonSize.height)
        shareBtn.frame.origin = CGPoint(x: buttonSize.width * 1, y: infoPanelView.frame.size.height * 0.5)
        shareBtn.setImage(UIImage(named: "Share"), for: .normal)
        self.shareBtn.addTarget(self, action: #selector(self.SharingAction), for: .touchUpInside)

        
        //Set Share Button properties
        removeFavoriteBtn = UIButton()
        removeFavoriteBtn.frame.size =  CGSize(width: buttonSize.width, height: buttonSize.height)
        removeFavoriteBtn.frame.origin = CGPoint(x: buttonSize.width * 3, y: infoPanelView.frame.size.height * 0.5)
        removeFavoriteBtn.setImage(UIImage(named: "Trash"), for: .normal)
        self.removeFavoriteBtn.addTarget(self, action: #selector(self.RemoveAction), for: .touchUpInside)

        
        
        // Music Title
        musicTitlelbl = UILabel()
        musicTitlelbl.text =  ""//"نوای شماره یک"
        musicTitlelbl.textColor = UIColor.white
        
        
        // Singer Title
        singerNamelbl = UILabel()
        singerNamelbl.text =  ""//"حاج سعید حدادیان"
        singerNamelbl.textColor = UIColor.white
        
        
        self.contentView.addSubview(musicImage)
        self.infoPanelView.addSubview(shareBtn)
        self.infoPanelView.addSubview(removeFavoriteBtn)
        self.infoPanelView.addSubview(singerNamelbl)
        self.infoPanelView.addSubview(musicTitlelbl)
        self.contentView.addSubview(infoPanelView)
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
