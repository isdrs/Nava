//
//  ServiceManager.swift
//  nava
//
//  Created by Mohsenian on 7/22/1395 AP.
//  Copyright © 1395 manshor. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SCLAlertView_Objective_C

class ServiceManager: NSObject
{
    private static var baseURl : String = "http://hadsahang.arsinit.com/skysounds/index/itemlist"
    
    ///mediaType, ServiceType, madah ID, page
    private static var ParametersWithSingerURL = "/%@/%@/madah/%@/20/%@"
    
    ///mediaType, ServiceType, page
    private static var ParametersWithoutSingerURL = "/%@/%@/20/%@"
    
    enum ServiceType: String
    {
        case shahadat, moharam, eid
    }
    
    enum ServiceMediaType: String
    {
        case all, sound, video
    }
    
    static func GetMediaList(mediaType : ServiceMediaType, serviceType : ServiceType, pageNo : Int, callBack : @escaping (Bool, [MusicObj]) -> Void  )
    {
        let urlString = String(format: ServiceManager.baseURl + ServiceManager.ParametersWithoutSingerURL, mediaType.rawValue, serviceType.rawValue, String(pageNo))
        
        Alamofire.request(urlString).responseJSON { (response) in
            print("Request: \(response.request)")
            print("Response: \(response.response)")
            print("Data: \(response.data)")
            print("Error: \(response.result)")
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                callBack(true, self.ParseResponse(json: json))
            case .failure(let error):
                print(error)
            }

        }
    }
    
    private static func ParseResponse(json: JSON) -> [MusicObj]
    {
        
        var musicObjArray = [MusicObj]()
        
        
        for (_,subJson):(String, JSON) in json {
            let musicObj = MusicObj()
            
            musicObj.MusicName = subJson["musicName"].stringValue
            musicObj.ArtistName = subJson["artistName"].stringValue
            musicObj.ArtistId = subJson["artistId"].stringValue
            musicObj.MusicID = subJson["musicID"].stringValue
            musicObj.Url = subJson["url"].stringValue
            musicObj.LargpicUrl = subJson["largpicUrl"].stringValue
            musicObj.SmallpicUrl = subJson["smallpicUrl"].stringValue
            musicObj.Time = subJson["time"].stringValue
            musicObj.ShareUrl = subJson["shareUrl"].stringValue
            musicObj.Like = subJson["like"].stringValue
            musicObj.Download = subJson["download"].stringValue
            musicObj.IrancellCode = subJson["irancellCode"].stringValue
            musicObj.HamrahavalCode = subJson["hamrahavalCode"].stringValue
            
            musicObjArray.append(musicObj)
        }
        

        
        return musicObjArray
    }
    
    
}
