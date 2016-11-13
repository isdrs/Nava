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
    static var mediaItem = MediaItem()
    
    static var singerMediaItems : [MediaItem] = [MediaItem]()
    
    static var totalMusicPlayer : GeneralMusicPlayerView!
    
    static var jukebox = Jukebox()
    
    var isHidden = false
    
    static var musicPlayerYOrigin = CGFloat()
    
    //var sideMenu : ENSideMenu!
    //var GeneralPlayeView : UIView!
   
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
            UIView.animate(withDuration: 0.5) {
                HomeViewController.totalMusicPlayer.frame.origin.y = HomeViewController.musicPlayerYOrigin
            }
            isHidden = false
        }
        else
        {
            UIView.animate(withDuration: 0.5) {
                HomeViewController.totalMusicPlayer.frame.origin.y = Tools.screenHeight
            }
            isHidden = true
        }
    }
    
    static func ReOriginPlayerView(tabbarHeight: CGFloat)
    {
        
        let viewSize = Tools.screenHeight
        
        let playerViewSize = HomeViewController.totalMusicPlayer.frame.size.height
        
        let p = viewSize - playerViewSize - tabbarHeight
        
        musicPlayerYOrigin = p
        
        HomeViewController.totalMusicPlayer.frame.origin = CGPoint(x: 0, y: p)
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        HomeViewController.totalMusicPlayer = GeneralMusicPlayerView()
        
        self.view.addSubview(HomeViewController.totalMusicPlayer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SetJukeBoxDelegate), name: NSNotification.Name(rawValue: Tools.StaticVariables.ChangeDelegateKey), object: nil)
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
            MPMediaItemPropertyArtist: HomeViewController.mediaItem.ArtistName,
            MPMediaItemPropertyTitle: HomeViewController.mediaItem.MediaName,
            MPNowPlayingInfoPropertyPlaybackRate: NSNumber(value: 1)
        ]
        
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
    
    func jukeboxDidLoadItem(_ jukebox: Jukebox, item: JukeboxItem) {
        print("Jukebox did load: \(item.URL.lastPathComponent)")
        
        
    }
    
    func jukeboxPlaybackProgressDidChange(_ jukebox: Jukebox) {
       
        SetMediaInfo()
        
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
            HomeViewController.totalMusicPlayer.SetNavigateButtonImage(urlString: HomeViewController.mediaItem.SmallpicUrl)
        }
        
        print("Jukebox state changed to \(jukebox.state)")
    }
    
    func jukeboxDidUpdateMetadata(_ jukebox: Jukebox, forItem: JukeboxItem) {
        print("Item updated:\n\(forItem)")
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        
        let ctiem = CMTime(seconds: (HomeViewController.jukebox?.currentItem?.currentTime)!, preferredTimescale: CMTimeScale.allZeros)
        
        if event?.type == .remoteControl {
            switch event!.subtype {
            case .remoteControlPlay :
                HomeViewController.jukebox?.play()
                MPNowPlayingInfoCenter.default().nowPlayingInfo![MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds(ctiem)
                MPNowPlayingInfoCenter.default().nowPlayingInfo![MPNowPlayingInfoPropertyPlaybackRate] = 1
            case .remoteControlPause :
                HomeViewController.jukebox?.pause()
                MPNowPlayingInfoCenter.default().nowPlayingInfo![MPNowPlayingInfoPropertyPlaybackRate] = 0
                MPNowPlayingInfoCenter.default().nowPlayingInfo![MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds(ctiem)
                
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
    
    
//    @IBAction func ToggleMenuAction(_ sender: AnyObject) {
//        
//        sideMenu.toggleMenu()
//    }
    
//    
//    // MARK: - ENSideMenu Delegate
//    func sideMenuWillOpen() {
//        print("sideMenuWillOpen")
//    }
//    
//    func sideMenuWillClose() {
//        print("sideMenuWillClose")
//    }
//    
//    func sideMenuShouldOpenSideMenu() -> Bool {
//        print("sideMenuShouldOpenSideMenu")
//        return true
//    }
//    
//    func sideMenuDidClose() {
//        print("sideMenuDidClose")
//    }
//    
//    func sideMenuDidOpen() {
//        print("sideMenuDidOpen")
//    }

}
