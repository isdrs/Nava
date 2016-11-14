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
    
    static var viewHeight = CGFloat()
    
    var isHidden = false
    
    static var musicPlayerYOrigin = CGFloat()
    
    static var currentMusicIndex = 0
    
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
        
        

        self.navigationController?.navigationBar.topItem?.title = "نواهای آسمانی"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: Tools.StaticVariables.AppFont, size: 20)!,  NSForegroundColorAttributeName: UIColor.white]

        
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
    
    @objc func SetJukeBoxDelegate()
    {
        if HomeViewController.jukebox?.state == .playing
        {
            HomeViewController.jukebox?.delegate = nil
            
            HomeViewController.jukebox?.delegate = self
            
//            let commandCenter = MPRemoteCommandCenter.shared()
//            commandCenter.nextTrackCommand.isEnabled = true
//            commandCenter.nextTrackCommand.addTarget(self, action: #selector(HomeViewController.NextTrack))
//            
//            commandCenter.previousTrackCommand.isEnabled = true
//            commandCenter.previousTrackCommand.addTarget(self, action: #selector(HomeViewController.PrevTrack))
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
    
    static func NextTrack(isInRoot: Bool)
    {
        if currentMusicIndex < singerMediaItems.count - 1
        {
            jukebox?.stop()
            
            currentMusicIndex += 1
            
            let oldItem = jukebox?.currentItem
            
            mediaItem = singerMediaItems[currentMusicIndex]
            
            if isInRoot
            {
//                let myUrl = URL(string: HomeViewController.mediaItem.MediaUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!)
//                
                let jukeBoxitem = JukeboxItem(URL: HomeViewController.LoadData(mediaitem: HomeViewController.mediaItem))
                
                jukebox?.append(item: jukeBoxitem, loadingAssets: false)
                
                jukebox?.remove(item: oldItem!)
                
                let url = HomeViewController.mediaItem.SmallpicUrl
                
                HomeViewController.totalMusicPlayer.SetNavigateButtonImage(urlString: url)
                
                jukebox?.play()
            }
        }
    }
    
    static func LoadData(mediaitem: MediaItem) -> URL
    {
        var myUrl : URL
        
        if let myMedia = MediaManager.IsDownloadedMedia(mediaItem: mediaitem)
        {
            HomeViewController.mediaItem = myMedia
            
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            
            documentsURL.appendPathComponent("MyMedia/." + HomeViewController.mediaItem.MediaID + ".mp3")
            
            myUrl = documentsURL//JukeboxItem(URL: documentsURL)
            
                    }
        else
        {
            
            myUrl = URL(string: HomeViewController.mediaItem.MediaUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!)!
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            if appDelegate.downloadQueue[String(HomeViewController.mediaItem.MediaID)] != nil {
              
            }
            else
            {
              
            }
            
        }
        
        return myUrl
        
        // jukebox.play()
    }
    
    static func PrevTrack(isInRoot: Bool)
    {
        if currentMusicIndex > 0
        {
            jukebox?.stop()
            
            let oldItem = jukebox?.currentItem
            
            currentMusicIndex -= 1
            
            mediaItem = singerMediaItems[currentMusicIndex]
            
            if isInRoot
            {
                
                let jukeBoxitem = JukeboxItem(URL: HomeViewController.LoadData(mediaitem: HomeViewController.mediaItem))
                
                jukebox?.append(item: jukeBoxitem, loadingAssets: false)
                
                jukebox?.remove(item: oldItem!)
                
                let url = HomeViewController.mediaItem.SmallpicUrl
                
                HomeViewController.totalMusicPlayer.SetNavigateButtonImage(urlString: url)
                
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
            HomeViewController.totalMusicPlayer.ArtistNameLabel = HomeViewController.mediaItem.ArtistName
            HomeViewController.totalMusicPlayer.MusicTitleLabel = HomeViewController.mediaItem.MediaName
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
