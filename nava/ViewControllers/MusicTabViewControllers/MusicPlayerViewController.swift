//
//  MusicPlayerViewController.swift
//  nava
//
//  Created by Mohsenian on 7/19/1395 AP.
//  Copyright © 1395 manshor. All rights reserved.
//

import UIKit
import AVFoundation

class MusicPlayerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var viwPlayerController: UIView!
    @IBOutlet weak var lblMusicTotalTime: UILabel!
    @IBOutlet weak var lblMusicCurrentTime: UILabel!
    @IBOutlet weak var slrMusicDuration: UISlider!
    @IBOutlet weak var lblMusicName: UILabel!
    @IBOutlet weak var lblSinger: UILabel!
    @IBOutlet weak var imgMusicImage: UIImageView!
    @IBOutlet weak var btnLikeOutlet: UIButton!
    
    @IBAction func LikeAction(_ sender: AnyObject) {
    }
   
    @IBAction func DownloadAction(_ sender: AnyObject) {
    }
    
    @IBAction func MusicSliderValueChange(_ sender: AnyObject)
    {
        musicPlayer.play(atTime: TimeInterval((sender as! UISlider).value))
    }
    var musicPlayer : AVAudioPlayer = AVAudioPlayer()
    var musicObj : MusicObj?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var updateTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: Selector(("updateTime")), userInfo: nil, repeats: true)
        var timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(MusicPlayerViewController.updateSlider), userInfo: nil, repeats: true)
        
        let pathString = Bundle.main.path(forResource: "agnes", ofType: "mp3")
        
        if let pathString = pathString {
            
            let pathURL = NSURL(fileURLWithPath: pathString)
            
            do {
                
                try musicPlayer = AVAudioPlayer(contentsOf: pathURL as URL)
                
            } catch {
                
                print("error")
            }
            
            
        }
        
        slrMusicDuration.maximumValue = Float(musicPlayer.duration)
    }
    
    func updateSlider() {
        slrMusicDuration.value = Float(musicPlayer.currentTime)
    }
    
    

    
    func updateTime() {
        let currentTime = Int(musicPlayer.currentTime)
        let duration = Int(musicPlayer.duration)
        let total = currentTime - duration
        let totalString = String(total)
        
        let minutes = currentTime/60
        let seconds = currentTime - minutes / 60
        
        lblMusicCurrentTime.text = NSString(format: "%02d:%02d", minutes,seconds) as String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicCell") as! MusicTableViewCell
        
        return cell
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
