//
//  GeneralMusicPlayerView.swift
//  nava
//
//  Created by Mohammad Lashgarbolouk on 11/12/16.
//  Copyright © 2016 manshor. All rights reserved.
//

import UIKit
import Jukebox


class GeneralMusicPlayerView: UIView {

    
    var btnPrev : UIButton!
    var btnPlayPause : UIButton!
    var btnNext : UIButton!
    var btnNavigate : UIButton!
    private var lblMusicName : UILabel!
    private var lblArtistName : UILabel!
    
    
    override func draw(_ rect: CGRect)
    {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        SetGeneralPlayerView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func SetGeneralPlayerView() {
        
        self.frame.size = CGSize(width: Tools.screenWidth, height: Tools.screenHeight * 0.07)
        self.frame.origin = CGPoint(x: 0, y: 0)//Tools.screenHeight - self.frame.size.height * 2)
        self.backgroundColor = .clear
        
        let w = self.frame.size.width
        let h = self.frame.size.height
        
        let wPercent = w / 100
        let hPercent = h / 100
        
        let backView = UIView(frame: self.frame)
        backView.backgroundColor = .black
        backView.alpha = 0.5
        
        self.addSubview(backView)
        
        btnPrev = UIButton()
        
        btnPrev.frame.size = CGSize(width: w * 0.07, height: w * 0.07)
        
        btnPrev.frame.origin = CGPoint(x: wPercent * 3 , y: hPercent * 25)
        
        btnPrev.setImage(UIImage(named: "Prev"), for: .normal)
        
        btnPrev.addTarget(self, action: #selector(self.PrevTrack), for: .touchUpInside)
        
        
        
        btnPlayPause = UIButton()
        
        btnPlayPause.frame.size = btnPrev.frame.size
        
        btnPlayPause.frame.origin = CGPoint(x: wPercent * 15 , y: hPercent * 25)
        
        btnPlayPause.setImage(UIImage(named: "Play"), for: .normal)
        
        btnPlayPause.addTarget(self, action: #selector(self.PlayPause), for: .touchUpInside)
        
        
        
        btnNext = UIButton()
        
        btnNext.frame.size = btnPrev.frame.size
        
        btnNext.frame.origin = CGPoint(x: wPercent * 27 , y: hPercent * 25)
        
        btnNext.setImage(UIImage(named: "Next"), for: .normal)
        
        btnNext.addTarget(self, action: #selector(self.NextTrack), for: .touchUpInside)
        
        
        
        
        btnNavigate = UIButton()
        
        btnNavigate.frame.size = CGSize(width: h * 0.9, height: h * 0.9)
        
        btnNavigate.frame.origin = CGPoint(x: wPercent * 88 , y: hPercent * 3)
        
        btnNavigate.addTarget(self, action: #selector(self.ShowViewController), for: .touchUpInside)
        
        
        self.lblMusicName = UILabel()
        self.lblArtistName = UILabel()
        self.lblArtistName.textColor = .white
        self.lblMusicName.textColor = .white
       
        
        self.addSubview(btnPrev)
        self.addSubview(btnPlayPause)
        self.addSubview(btnNext)
        self.addSubview(btnNavigate)
        self.addSubview(lblArtistName)
        self.addSubview(lblMusicName)
    }
    
    var MusicTitleLabel : String {
        get {
            return self.lblMusicName.text!
        }
        set {
            self.lblMusicName.text = newValue
            self.lblMusicName.sizeToFit()
            self.lblMusicName.frame.origin = CGPoint(x: self.frame.size.width - self.btnNavigate.frame.size.width - self.frame.size.width * 0.02 - self.lblMusicName.frame.size.width, y:self.frame.size.height * 0.05)
        }
    }
    
    var ArtistNameLabel : String {
        get {
            return self.lblArtistName.text!
        }
        set {
            self.lblArtistName.text = newValue
            self.lblArtistName.sizeToFit()
            self.lblArtistName.frame.origin = CGPoint(x: self.frame.size.width - self.btnNavigate.frame.size.width - self.frame.size.width * 0.02 - self.lblArtistName.frame.size.width, y:self.frame.size.height * 0.45)
        }
    }
    
    
    @objc private func PlayPause()
    {
        HomeViewController.PlayPause()
    }
    
    
    @objc func NextTrack()
    {
        HomeViewController.NextTrack(isInRoot: true)
        
    }
    
    @objc func PrevTrack()
    {
        HomeViewController.PrevTrack(isInRoot: true)
    }
    
    
    @objc private func ShowViewController()
    {
         let stb = UIStoryboard(name: "Main", bundle: nil)
        
        if PlayingMediaManager.PlayingMediaItem.MediaType == .sound
        {
            let musicPlayerViewController = stb.instantiateViewController(withIdentifier: "MusicPlayerViewController") as! MusicPlayerViewController

            PlayingMediaManager.ShowingMediaItem = PlayingMediaManager.PlayingMediaItem
            
            UIApplication.topViewController()?.present(musicPlayerViewController, animated: false)
            {
                
            }
        }
    }
    
    func SetPlayButtonImage(isPlaying :Bool)
    {
        if isPlaying
        {
            btnPlayPause.setImage(UIImage(named: "Pause"), for: .normal)
        }
        else
        {
           btnPlayPause.setImage(UIImage(named: "Play"), for: .normal)
        }
    }
    
    func SetNavigateButtonImage(urlString: String)
    {
        btnNavigate.imageView?.image = nil
        
        let url = URL(string: urlString)
        
        btnNavigate.af_setImage(for: .normal, url: url!)
    }
}
