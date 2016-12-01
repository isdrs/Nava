//
//  HomeViewController.swift
//  nava
//
//  Created by Mohsenian on 7/18/1395 AP.
//  Copyright © 1395 manshor. All rights reserved.
//

import UIKit
//import ENSwiftSideMenu
import Jukebox
import MediaPlayer



class HomeViewController: UIViewController ,JukeboxDelegate//, ENSideMenuDelegate {
{
    
    @IBOutlet weak var myNavigationBar: UINavigationItem!
    static var totalMusicPlayer : GeneralMusicPlayerView!
    
    static var jukebox = Jukebox()
    
    static var viewHeight = CGFloat()
    
    var isHidden = false
    
    static var musicPlayerYOrigin = CGFloat()
    
        
    var btnPrev : UIButton!
    var btnPlayPause : UIButton!
    var btnNext : UIButton!
    var btnNavigate : UIButton!
    
    @IBOutlet weak var ContainerView: UIView!
    
    @IBAction func LookAction(_ sender: AnyObject)
    {
        ShowHideMusicPlayer()
    }
    
    func ShowHideMusicPlayer()
    {
        if isHidden
        {
            UIView.animate(withDuration: 0.4) {
                HomeViewController.totalMusicPlayer.alpha = 1
            }
            UIView.animate(withDuration: 0.25) {
                HomeViewController.totalMusicPlayer.frame.origin.y = HomeViewController.musicPlayerYOrigin
                
            }
            isHidden = false
        }
        else
        {
            UIView.animate(withDuration: 0.25) {
                
                HomeViewController.totalMusicPlayer.alpha = 0
            }
            
            UIView.animate(withDuration: 0.5) {
                HomeViewController.totalMusicPlayer.frame.origin.y = Tools.screenHeight
                
            }
            isHidden = true
        }
    }
    
    static func ReOriginPlayerView(tabbarHeight: CGFloat)
    {
        let playerViewSize = HomeViewController.totalMusicPlayer.frame.size.height
        
        musicPlayerYOrigin = HomeViewController.viewHeight - playerViewSize - tabbarHeight
        
        HomeViewController.totalMusicPlayer.frame.origin = CGPoint(x: 0, y: musicPlayerYOrigin )
     }
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        
        HomeViewController.viewHeight = self.view.frame.size.height - (self.navigationController?.navigationBar.frame.size.height)! - Tools.YDiffer
        
        HomeViewController.totalMusicPlayer = GeneralMusicPlayerView()
        
        self.view.addSubview(HomeViewController.totalMusicPlayer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SetJukeBoxDelegate), name: NSNotification.Name(rawValue: Tools.StaticVariables.ChangeDelegateKey), object: nil)
        
        HomeViewController.PrevAndNextButtonEnableDisable()
        
        SetTitleViewForNavigationBar()

        
        for familyName in UIFont.familyNames {
            
            for fontname in UIFont.fontNames(forFamilyName: familyName)
            {
            print("\(familyName) : \(fontname)")
            }
        }
        
        let myFont = UIFont(name: Tools.StaticVariables.AppFont, size: 5)
        
        UILabel.appearance().defaultFont =  myFont
        
        UIButton.appearance().titleLabel?.font = myFont!
        
    }
    
    func SetTitleViewForNavigationBar() {
        
        let titleFrame = CGRect(x: 0, y: 0, width: Tools.screenWidth * 0.25, height: Tools.screenHeight * 0.05)//self.navigationController?.navigationItem.titleView?.frame
        
        let titleView = UIView(frame: titleFrame)
        
        let titleImage = UIImageView(frame: titleFrame)
        
        titleImage.image = UIImage(named: "Title")
        
        titleView.addSubview(titleImage)
        
        self.myNavigationBar.titleView = titleView//UIImageView(image: UIImage(named: "Title"))//titleView
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        HomeViewController.PrevAndNextButtonEnableDisable()
        
        _ = self.becomeFirstResponder()
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    @objc func SetJukeBoxDelegate()
    {
        if HomeViewController.jukebox?.state == .playing
        {
            HomeViewController.jukebox?.delegate = nil
            
            HomeViewController.jukebox?.delegate = self
          
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func SetMediaInfo()
    {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyArtist: PlayingMediaManager.PlayingMediaItem.ArtistName,
            MPMediaItemPropertyTitle: PlayingMediaManager.PlayingMediaItem.MediaName,
            MPNowPlayingInfoPropertyPlaybackRate: NSNumber(value: 1)
        ]
        
        if let p = PlayingMediaManager.CurrentMediaImage
        {
            MPNowPlayingInfoCenter.default().nowPlayingInfo? [MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: p)
        }
        
        print(MPNowPlayingInfoCenter.default().nowPlayingInfo)
    }
    
    static func PlayPause()
    {
        switch HomeViewController.jukebox?.state.rawValue
        {
        case Jukebox.State.ready.rawValue? :
            HomeViewController.jukebox?.play(atIndex: 0)
        case Jukebox.State.playing.rawValue? :
            HomeViewController.jukebox?.pause()
            totalMusicPlayer.SetPlayButtonImage(isPlaying: false)
        case Jukebox.State.paused.rawValue? :
            HomeViewController.jukebox?.play()
            totalMusicPlayer.SetPlayButtonImage(isPlaying: true)
        default:
            HomeViewController.jukebox?.stop()
        }
    }
    
    static func NextTrack(isInRoot: Bool)
    {
        if PlayingMediaManager.CurrentMusicIndex < PlayingMediaManager.PlayingArtistMediaItems.count - 1
        {
            jukebox?.stop()
            
            PlayingMediaManager.CurrentMusicIndex += 1
            
            HomeViewController.PrevAndNextButtonEnableDisable()
            
            let oldItem = jukebox?.currentItem
            
            PlayingMediaManager.PlayingMediaItem = PlayingMediaManager.PlayingArtistMediaItems[PlayingMediaManager.CurrentMusicIndex]
            
            if isInRoot
            {
                
                let jukeBoxitem = JukeboxItem(URL: HomeViewController.LoadData(mediaitem: PlayingMediaManager.PlayingMediaItem))
                
                jukebox?.append(item: jukeBoxitem, loadingAssets: false)
                
                jukebox?.remove(item: oldItem!)
                
                let url = PlayingMediaManager.PlayingMediaItem.LargpicUrl
                
                HomeViewController.totalMusicPlayer.SetNavigateButtonImage(urlString: url)
                
                HomeViewController.totalMusicPlayer.SetNavigateButtonImage(urlString: PlayingMediaManager.PlayingMediaItem.LargpicUrl)
                HomeViewController.totalMusicPlayer.ArtistNameLabel = PlayingMediaManager.PlayingMediaItem.ArtistName
                HomeViewController.totalMusicPlayer.MusicTitleLabel = PlayingMediaManager.PlayingMediaItem.MediaName
                jukebox?.play()
            }
        }
    }
    
    static func LoadData(mediaitem: MediaItem) -> URL
    {
        var myUrl : URL
        
        if let myMedia = MediaManager.IsDownloadedMedia(mediaItem: mediaitem)
        {
            PlayingMediaManager.PlayingMediaItem = myMedia
            
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            
            documentsURL.appendPathComponent("MyMedia/." + PlayingMediaManager.PlayingMediaItem.MediaID + ".mp3")
            
            myUrl = documentsURL//JukeboxItem(URL: documentsURL)
            
        }
        else
        {
            
            myUrl = URL(string: PlayingMediaManager.PlayingMediaItem.MediaUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!)!
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            if appDelegate.downloadQueue[String(PlayingMediaManager.PlayingMediaItem.MediaID)] != nil {
              
            }
            else
            {
              
            }
            
        }
        
        return myUrl
    }
    
    static func PrevTrack(isInRoot: Bool)
    {
        if PlayingMediaManager.CurrentMusicIndex > 0
        {
            jukebox?.stop()
            
            let oldItem = jukebox?.currentItem
            
            PlayingMediaManager.CurrentMusicIndex -= 1

            HomeViewController.PrevAndNextButtonEnableDisable()

            PlayingMediaManager.PlayingMediaItem = PlayingMediaManager.PlayingArtistMediaItems[PlayingMediaManager.CurrentMusicIndex]
            
            if isInRoot
            {
                
                let jukeBoxitem = JukeboxItem(URL: HomeViewController.LoadData(mediaitem: PlayingMediaManager.PlayingMediaItem))
                
                jukebox?.append(item: jukeBoxitem, loadingAssets: false)
                
                jukebox?.remove(item: oldItem!)
                
                let url = PlayingMediaManager.PlayingMediaItem.LargpicUrl
                
                HomeViewController.totalMusicPlayer.SetNavigateButtonImage(urlString: url)
                
                HomeViewController.totalMusicPlayer.SetNavigateButtonImage(urlString: PlayingMediaManager.PlayingMediaItem.LargpicUrl)
                HomeViewController.totalMusicPlayer.ArtistNameLabel = PlayingMediaManager.PlayingMediaItem.ArtistName
                HomeViewController.totalMusicPlayer.MusicTitleLabel = PlayingMediaManager.PlayingMediaItem.MediaName
                
                jukebox?.play()
            }
        }
    }
    
    static func PlayCurrentMusic()
    {
        
    }
    
    func jukeboxDidLoadItem(_ jukebox: Jukebox, item: JukeboxItem) {
        print("Jukebox did load: \(item.URL.lastPathComponent)")
        
        
    }
    
    func jukeboxPlaybackProgressDidChange(_ jukebox: Jukebox) {
       
        if let currentTime = jukebox.currentItem?.currentTime, let duration = PlayingMediaManager.PlayingMediaItem.TimeDouble
        {
            //let value = Float(currentTime / duration)
            print("\n current " + String(currentTime) + "   duration  " + String(duration))
            if currentTime >= duration
            {
                if !PlayingMediaManager.IsCurrentMediaLast()
                {
                    HomeViewController.NextTrack(isInRoot: true)
                }
            }
        }
    }
    
    func jukeboxStateDidChange(_ jukebox: Jukebox) {
        
       
        if jukebox.state == .ready
        {
            HomeViewController.totalMusicPlayer.btnPlayPause.setImage(UIImage(named: "Play"), for: .normal)
        }
        else if jukebox.state == .loading
        {
            HomeViewController.totalMusicPlayer.btnPlayPause.setImage(UIImage(named: "pause"), for: .normal)
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
            
            HomeViewController.totalMusicPlayer.SetPlayButtonImage(isPlaying: imageName == "Pause" ? true : false)
            
        }
        
        SetMediaInfo()
        
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
            case .remoteControlPause :
                HomeViewController.jukebox?.pause()
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
    
    static func PrevAndNextButtonEnableDisable()
    {
        //PlayingMediaManager.CurrentMusicIndex = PlayingMediaManager.FindPlayingMediaItemInPlayingList()
        
        print("Prev Index " + String(PlayingMediaManager.CurrentMusicIndex))
        
        if PlayingMediaManager.PlayingArtistMediaItems.count > 1
        {
            if PlayingMediaManager.IsCurrentMediaFirst()
            {
                HomeViewController.totalMusicPlayer.btnPrev.isEnabled = false
                HomeViewController.totalMusicPlayer.btnNext.isEnabled = true
            }
            else if PlayingMediaManager.IsCurrentMediaLast()
            {
                HomeViewController.totalMusicPlayer.btnPrev.isEnabled = true
                HomeViewController.totalMusicPlayer.btnNext.isEnabled = false
            }
            else if PlayingMediaManager.CurrentMusicIndex == -1
            {
                HomeViewController.totalMusicPlayer.btnNext.isEnabled = false
                HomeViewController.totalMusicPlayer.btnPrev.isEnabled = false
            }
            else{
                HomeViewController.totalMusicPlayer.btnNext.isEnabled = true
                HomeViewController.totalMusicPlayer.btnPrev.isEnabled = true
            }
        }
        else
        {
            HomeViewController.totalMusicPlayer.btnNext.isEnabled = false
            HomeViewController.totalMusicPlayer.btnPrev.isEnabled = false
            
        }
    }

    
    }
