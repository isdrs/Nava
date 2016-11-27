//
//  MediaCell.swift
//  nava
//
//  Created by Mohammad Lashgarbolouk on 10/28/16.
//  Copyright © 2016 manshor. All rights reserved.
//

import UIKit
import Alamofire


class MediaCell: UITableViewCell {
    
    static let cellHeight = Tools.screenHeight * CGFloat(0.45)
    var musicImage : UIImageView!
    private var likeCountImage : UIImageView!
    private var downLoadCountImage : UIImageView!
    private var downloadCountlbl : UILabel!
    private var likeCountlbl : UILabel!
    private var musicTitlelbl : UILabel!
    private var singerNamelbl : UILabel!
    private var infoPanelView : UIView!
    
    
    
    var MusicTitleLabel : String {
        get {
            return self.musicTitlelbl.text!
        }
        set {
            self.musicTitlelbl.text = newValue
            UpdateNamesLabel()
        }
    }
    
    var SingerNameLabel : String {
        get {
            return self.singerNamelbl.text!
        }
        set {
            self.singerNamelbl.text = newValue
            UpdateNamesLabel()
        }
    }
    
    var DownloadCounterLabelText : String {
        get {
            return self.downloadCountlbl.text!
        }
        set {
            self.downloadCountlbl.text = newValue
            UpdateLabelsOrigins()
        }
    }
    
    var LikeCounterLabelText : String {
        get {
            return self.likeCountlbl.text!
        }
        set {
            self.likeCountlbl.text = newValue
            UpdateLabelsOrigins()
        }
    }
    
    func UpdateNamesLabel()
    {
        self.musicTitlelbl.sizeToFit()
     
        self.singerNamelbl.sizeToFit()
       
        self.musicTitlelbl.frame.origin.x = infoPanelView.frame.size.width - musicTitlelbl.frame.size.width - Tools.screenWidth * 0.03
        self.musicTitlelbl.center.y =  infoPanelView.frame.size.height * 0.2
        
        self.singerNamelbl.frame.origin.x = infoPanelView.frame.size.width - singerNamelbl.frame.size.width - Tools.screenWidth * 0.03
        self.singerNamelbl.center.y =  infoPanelView.frame.size.height * 0.7
        
    }
    func UpdateLabelsOrigins() {
        self.downloadCountlbl.sizeToFit()
        self.likeCountlbl.sizeToFit()
        
        self.downloadCountlbl.center = CGPoint(x: infoPanelView.frame.origin.x + Tools.screenWidth * 0.07,
                                                     y: infoPanelView.frame.size.height / 2)
        
        self.downLoadCountImage.frame.origin = CGPoint(x: downloadCountlbl.frame.origin.x + downloadCountlbl.frame.size.width + Tools.screenWidth * 0.02, y: downloadCountlbl.frame.origin.y)
        
        self.likeCountlbl.frame.origin = CGPoint(x: downLoadCountImage.frame.origin.x + downLoadCountImage.frame.size.width + Tools.screenWidth * 0.05, y: downloadCountlbl.frame.origin.y)
        
        self.likeCountImage.frame.origin = CGPoint(x: likeCountlbl.frame.origin.x + likeCountlbl.frame.size.width + Tools.screenWidth * 0.02, y: downloadCountlbl.frame.origin.y)
    }
    

    private var cellSize : CGSize!
   
    private var cellPosition : CGPoint!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        

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
        
        
        // Download Counter Label
        downloadCountlbl = UILabel()
        downloadCountlbl.text = "0"
        downloadCountlbl.textColor = UIColor.white
        

        // Download Image
        downLoadCountImage = UIImageView()
        downLoadCountImage.frame.size =  CGSize(width: buttonSize.width, height: buttonSize.height)
        downLoadCountImage.image = UIImage(named: "DownloadedTab")
        
        
        // Like Counter Label
        likeCountlbl = UILabel()
        likeCountlbl.text = "0"
        likeCountlbl.textColor = UIColor.white
        
        
        // Like Counter Image
        likeCountImage = UIImageView()
        likeCountImage.frame.size = CGSize(width: buttonSize.width, height: buttonSize.height)
        likeCountImage.image = UIImage(named: "Like")
        
        
        // Music Title
        musicTitlelbl = UILabel()
        musicTitlelbl.text =  ""//"نوای شماره یک"
        musicTitlelbl.textColor = UIColor.white
        
        
        // Singer Title
        singerNamelbl = UILabel()
        singerNamelbl.text =  ""//"حاج سعید حدادیان"
        singerNamelbl.textColor = UIColor.white
        
        
        self.contentView.addSubview(musicImage)
        self.infoPanelView.addSubview(likeCountImage)
        self.infoPanelView.addSubview(downLoadCountImage)
        self.infoPanelView.addSubview(likeCountlbl)
        self.infoPanelView.addSubview(downloadCountlbl)
        self.infoPanelView.addSubview(singerNamelbl)
        self.infoPanelView.addSubview(musicTitlelbl)
        self.contentView.addSubview(infoPanelView)
        
        
        UpdateNamesLabel()
        UpdateLabelsOrigins()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
