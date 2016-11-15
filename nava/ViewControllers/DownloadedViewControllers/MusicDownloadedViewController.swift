//
//  MusicDownloadedViewController.swift
//  nava
//
//  Created by Mohsenian on 7/24/1395 AP.
//  Copyright © 1395 manshor. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MusicDownloadedViewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource, DownloadCellItemDelegate {
    
    var downlodedMusic = [MediaItem]()
  
    var refreshControl : UIRefreshControl!
    
    private var musicTbl: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        SetTableView()
        
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.LoadData), for: UIControlEvents.valueChanged)
        musicTbl.addSubview(refreshControl)
    }
    
    func SetTableView()
    {
        // set tableview properties
        musicTbl = UITableView()
        musicTbl = UITableView(frame: .zero, style: .plain)
        musicTbl.register(DownloadCellItem.self, forCellReuseIdentifier: Tools.StaticVariables.cellReuseIdendifier)
        musicTbl.rowHeight = DownloadCellItem.cellHeight
        musicTbl.backgroundColor = .black
        musicTbl.dataSource = self
        musicTbl.delegate = self
        musicTbl.frame = self.view.frame
        musicTbl.separatorStyle = .none
        musicTbl.contentInset = UIEdgeInsetsMake(0, 0, 165, 0);
        self.view.addSubview(musicTbl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if self.refreshControl.isRefreshing
        {
            self.refreshControl.endRefreshing()
        }
        
        LoadData()
    }
    
    func  LoadData()
    {
        downlodedMusic = MediaManager.GetDBMedia(mediaType: .sound)
        musicTbl.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "موسیقی")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downlodedMusic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Tools.StaticVariables.cellReuseIdendifier) as! DownloadCellItem
        
        let mediaItem = downlodedMusic[indexPath.row]
        
        cell.cellMedia = mediaItem
        
        cell.MusicTitleLabel = mediaItem.MediaName
        cell.SingerNameLabel = mediaItem.ArtistName
        cell.delegate = self
        
        //cell.time.text = mediaItem.Time
        
        cell.musicImage.af_setImage(withURL: NSURL(string: mediaItem.LargpicUrl) as! URL)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let stb = UIStoryboard(name: "Main", bundle: nil)
        
        let musicPlayerViewController = stb.instantiateViewController(withIdentifier: "MusicPlayerViewController") as! MusicPlayerViewController
        HomeViewController.mediaItem = downlodedMusic[indexPath.row]
        
        self.present(musicPlayerViewController, animated: true) {
            
        }
        
        //self.navigationController?.pushViewController(musicPlayerViewController, animated: false)
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
