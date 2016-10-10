//
//  MusicTableView.swift
//  nava
//
//  Created by Mohsenian on 7/19/1395 AP.
//  Copyright © 1395 manshor. All rights reserved.
//

import UIKit

class MusicTableView: UITableView {

    enum MusicType {
        case Shahadat
        case Ayad
        case Moharram
        case Favorites
    }
    
    var _musicType : MusicType = .Shahadat
    
    var musicData : [MusicObj] = []
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func numberOfRows(inSection section: Int) -> Int {
        return musicData.count
    }
    
    override func cellForRow(at indexPath: IndexPath) -> UITableViewCell? {
        let cell = self.dequeueReusableCell(withIdentifier: "MusicCell") as! MusicTableViewCell
        
        return cell
    }
}
