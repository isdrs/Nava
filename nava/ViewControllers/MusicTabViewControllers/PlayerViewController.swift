//
//  PlayerViewController.swift
//  nava
//
//  Created by Mohammad Lashgarbolouk on 11/8/16.
//  Copyright © 2016 manshor. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class PlayerViewController: UIViewController {

    private var playerController : AVPlayerViewController!
    private var playerView : UIView!
    private var btnBack : UIButton!
    
    var myUrl : URL!
    
    func BackAction()
    {
        self.dismiss(animated: true,completion: {});
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        let W = Tools.screenWidth
        let H =  Tools.screenHeight * 0.65
        let X = CGFloat()
        let Y = Tools.screenHeight * 0.03
        let WPercent = W / 100.0
        let HPercent = H / 100.0
        
        playerView = UIView()
        
        playerView.frame.size.height = HPercent * 95
        playerView.frame.size.width = self.view.frame.size.width
        playerView.frame.origin.x = 0
        playerView.frame.origin.y = HPercent * 5
        
        self.view.addSubview(playerView)
        
        PlayVideo()
        
        self.btnBack = UIButton()
        self.btnBack.frame = CGRect(x: X + WPercent * 3 , y: HPercent * 5 , width: WPercent * 7 , height: WPercent * 7)
        self.btnBack.setImage(UIImage(named: "Back"), for: .normal)
        self.btnBack.addTarget(self, action: #selector(self.BackAction), for: .touchUpInside)
        
        self.view.addSubview(btnBack)

        // Do any additional setup after loading the view.
    }
    
    
    func PlayVideo()
    {
        
        //self.view.bringSubview(toFront: btnBack)
        
    
        let player = AVPlayer(url: myUrl!)
        
        self.playerController = AVPlayerViewController()
        
        self.playerController!.view.frame = playerView.frame
        
        self.playerController!.player = player
        
        self.view.addSubview(self.playerController!.view)
        
        self.playerController!.player?.play()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
