//
//  MusicObj.swift
//  nava
//
//  Created by Mohsenian on 7/19/1395 AP.
//  Copyright © 1395 manshor. All rights reserved.
//

import UIKit

class MediaItem: NSObject
{
    private var mediaName : String = ""
    private var artistName : String = ""
    private var artistId : String = ""
    private var mediaID : String = ""
    private var mediaType : NavaEnums.ServiceMediaType = NavaEnums.ServiceMediaType.all
    private var mediaServiceType : NavaEnums.ServiceType = NavaEnums.ServiceType.shahadat
    private var mediaUrl : String = ""
    private var largpicUrl : String = ""
    private var smallpicUrl : String = ""
    private var time : String = ""
    private var shareUrl : String = ""
    private var like : String = ""
    private var download : String = ""
    private var hamrahavalCode : String = ""
    private var irancellCode : String = ""
    
    public var MediaName : String
        {
        get
        {
            return self.mediaName
        }
        set(newValue)
        {
            self.mediaName = newValue
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
    
    public var MediaID : String
        {
        get
        {
            return self.mediaID
        }
        set(newValue)
        {
            self.mediaID = newValue
        }
    }
    
    public var MediaType : NavaEnums.ServiceMediaType
        {
        get
        {
            return self.mediaType
        }
        set(newValue)
        {
            self.mediaType = newValue
        }
    }
    
    public var MediaServiceType : NavaEnums.ServiceType
        {
        get
        {
            return self.mediaServiceType
        }
        set(newValue)
        {
            self.mediaServiceType = newValue
        }
    }
    
    public var MediaUrl : String
        {
        get
        {
            return self.mediaUrl
        }
        set(newValue)
        {
            self.mediaUrl = newValue
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
    
    public var TimeDouble : Double!
        {
        get
        {
            
            if var min : Int = Int(self.Time.components(separatedBy: ":")[0])
            {
                min = min * 60
                
                if let sec : Int = Int(self.Time.components(separatedBy: ":")[1])
                {
                    return Double(min + sec)
                }
            }
            
            return 0
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
    
    public var IrancellCode : String
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
