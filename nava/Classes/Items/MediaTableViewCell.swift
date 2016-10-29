//
//  MediaTableViewCell.swift
//  nava
//
//  Created by Mohsenian on 7/19/1395 AP.
//  Copyright © 1395 manshor. All rights reserved.
//

import UIKit

class MediaTableViewCell: UITableViewCell {
    @IBOutlet weak var imgMusicThumb: UIImageView!
    @IBOutlet weak var lblMusicName: UILabel!
    @IBOutlet weak var lblSinger: UILabel!
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var lblMusicTime: UILabel!
    @IBOutlet weak var lblDownloadCount: UILabel!



    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
