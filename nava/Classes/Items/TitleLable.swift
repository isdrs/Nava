//
//  TitleLable.swift
//  nava
//
//  Created by Mohammad Lashgarbolouk on 11/14/16.
//  Copyright © 2016 manshor. All rights reserved.
//

import UIKit

class TitleLable: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    
    init(tagNum: Int) {
        
        super.init(frame: CGRect())
        self.SetTag(tagNum: tagNum)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
       
    }
    
    private func SetTag(tagNum: Int)
    {
        self.tag = tagNum
    }
}
