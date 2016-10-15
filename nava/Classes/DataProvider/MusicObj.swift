//
//  MusicObj.swift
//  nava
//
//  Created by Mohsenian on 7/19/1395 AP.
//  Copyright © 1395 manshor. All rights reserved.
//

import UIKit

class MusicObj: NSObject
{
    private var musicName : String = ""
    private var artistName : String = ""
    private var artistId : String = ""
    private var itemID : String = ""
    private var url : String = ""
    private var largpicUrl : String = ""
    private var smallpicUrl : String = ""
    private var time : String = ""
    private var shareUrl : String = ""
    private var like : String = ""
    private var download : String = ""
    private var hamrahavalCode : String = ""
    private var irancellCode : String = ""
    
    public var MusicName : String
        {
        get
        {
            return self.musicName
        }
        set(newValue)
        {
            self.musicName = newValue
        }
    }
    
    public var ArtistName : String
        {
        get
        {
            return self.artistName
        }
        set(newValue)
        {
            self.artistName = newValue
        }
    }
    
    public var ArtistId : String
        {
        get
        {
            return self.artistId
        }
        set(newValue)
        {
            self.artistId = newValue
        }
    }
    
    public var ItemID : String
        {
        get
        {
            return self.itemID
        }
        set(newValue)
        {
            self.itemID = newValue
        }
    }
    
    public var Url : String
        {
        get
        {
            return self.url
        }
        set(newValue)
        {
            self.url = newValue
        }
    }
    
    public var LargpicUrl : String
        {
        get
        {
            return self.largpicUrl
        }
        set(newValue)
        {
            self.largpicUrl = newValue
        }
    }
    
    public var SmallpicUrl : String
        {
        get
        {
            return self.smallpicUrl
        }
        set(newValue)
        {
            self.smallpicUrl = newValue
        }
    }
    
    public var Time : String
        {
        get
        {
            return self.time
        }
        set(newValue)
        {
            self.time = newValue
        }
    }
    
    public var ShareUrl : String
        {
        get
        {
            return self.shareUrl
        }
        set(newValue)
        {
            self.shareUrl = newValue
        }
    }
    
    public var Like : String
        {
        get
        {
            return self.like
        }
        set(newValue)
        {
            self.like = newValue
        }
    }
    
    public var Download : String
        {
        get
        {
            return self.download
        }
        set(newValue)
        {
            self.download = newValue
        }
    }
    
    public var HamrahavalCode : String
        {
        get
        {
            return self.hamrahavalCode
        }
        set(newValue)
        {
            self.hamrahavalCode = newValue
        }
    }
    
    public var IrancellCpde : String
        {
        get
        {
            return self.irancellCode
        }
        set(newValue)
        {
            self.irancellCode = newValue
        }
    }
}
