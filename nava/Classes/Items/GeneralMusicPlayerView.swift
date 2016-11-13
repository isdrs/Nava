//
//  GeneralMusicPlayerView.swift
//  nava
//
//  Created by Mohammad Lashgarbolouk on 11/12/16.
//  Copyright © 2016 manshor. All rights reserved.
//

import UIKit


class GeneralMusicPlayerView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var btnPrev : UIButton!
    var btnPlayPause : UIButton!
    var btnNext : UIButton!
    var btnNavigate : UIButton!

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
        backView.backgroundColor = .gray
        backView.alpha = 0.5
        
        self.addSubview(backView)
        
        btnPrev = UIButton()
        
        btnPrev.frame.size = CGSize(width: w * 0.07, height: w * 0.07)
        
        btnPrev.frame.origin = CGPoint(x: wPercent * 3 , y: hPercent * 25)
        
        btnPrev.setImage(UIImage(named: "Prev"), for: .normal)
        
        //btnPrev.addTarget(self, action: #selector(self.ShowViewController), for: .touchUpInside)
        
        
        
        btnPlayPause = UIButton()
        
        btnPlayPause.frame.size = btnPrev.frame.size
        
        btnPlayPause.frame.origin = CGPoint(x: wPercent * 15 , y: hPercent * 25)
        
        btnPlayPause.setImage(UIImage(named: "Play"), for: .normal)
        
        btnPlayPause.addTarget(self, action: #selector(self.PlayPause), for: .touchUpInside)
        
        
        
        btnNext = UIButton()
        
        btnNext.frame.size = btnPrev.frame.size
        
        btnNext.frame.origin = CGPoint(x: wPercent * 27 , y: hPercent * 25)
        
        btnNext.setImage(UIImage(named: "Next"), for: .normal)
        
        //btnNext.addTarget(self, action: #selector(self.ShowViewController), for: .touchUpInside)
        
        
        
        btnNavigate = UIButton()
        
        btnNavigate.frame.size = CGSize(width: h * 0.9, height: h * 0.9)
        
        btnNavigate.frame.origin = CGPoint(x: wPercent * 88 , y: hPercent * 3)
        
        //btnNavigate.backgroundColor = .red
        
        //btnNavigate.setImage(UIImage(named: "Play"), for: .normal)
        
        btnNavigate.addTarget(self, action: #selector(self.ShowViewController), for: .touchUpInside)
        
        self.addSubview(btnPrev)
        self.addSubview(btnPlayPause)
        self.addSubview(btnNext)
        self.addSubview(btnNavigate)
    }
    
    @objc private func PlayPause()
    {
        HomeViewController.PlayPause()
    }
    
    
    @objc private func ShowViewController()
    {
         let stb = UIStoryboard(name: "Main", bundle: nil)
        
        if HomeViewController.mediaItem.MediaType == .sound
        {
            let musicPlayerViewController = stb.instantiateViewController(withIdentifier: "MusicPlayerViewController") as! MusicPlayerViewController
            
            UIApplication.topViewController()?.present(musicPlayerViewController, animated: false) {
                
            }
        }
//        else
//        {
//            let videoPlayerViewController = stb.instantiateViewController(withIdentifier: "VideoPlayerViewController") as! VideoPlayerViewController
//            videoPlayerViewController.mediaItem = HomeViewController.mediaItem
//            
//            UIApplication.topViewController()?.present(videoPlayerViewController, animated: false) {
//                
//            }
//        }
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
