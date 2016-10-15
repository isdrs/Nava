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
    
    func GetMediaList(mediaType : ServiceMediaType, serviceType : ServiceType, pageNo : Int, callBack : @escaping (Bool, MusicObj) -> Void  )
    {
        let urlString = String(format: ServiceManager.baseURl + ServiceManager.ParametersWithoutSingerURL, mediaType.rawValue, serviceType.rawValue, String(pageNo))
        
        Alamofire.request(urlString).response { (response) in
            print("Request: \(response.request)")
            print("Response: \(response.response)")
            print("Data: \(response.data)")
            print("Error: \(response.error)")
            
            if response.error != nil
            {
//                if let err = response.error as? URLError where err == URLError.notConnectedToInternet {
//                    //SCLAlertView().showError("Error", subTitle: "No Internet")
//                }
//                else
//                {
//                    //SCLAlertView().showError("Error", subTitle: String((error?.localizedDescription)!))
//                    
//                    //print(error?.localizedDescription)
//                }
                
                //loadingBar.Hide()
                
                callBack(false,MusicObj())
            }
            else if response.response?.statusCode != 200
            {
//                if let dataString = String(data: response.data!, encoding: String.Encoding.utf8)
//                {
//                    SCLAlertView().showError("Error", subTitle: "Server Error Code " + String(response.response!.statusCode))
//                    
//                    print(dataString)
//                }
//                else
//                {
//                    SCLAlertView().showError("Error", subTitle: "Server Error with faild data ")
//                }
//                
//                loadingBar.Hide()
                
                callBack(false,MusicObj())
            }
            else if response.response?.statusCode == 200
            {
//                loadingBar.Hide()
                
                
                let musicObject = self.ParseResponse(json: JSON(data: response.data!))
                
                callBack(true,musicObject)
            }
            else
            {
//                SCLAlertView().showError("Error", subTitle: "Server error! Try later")
//                
//                loadingBar.Hide()
                
                callBack(false,MusicObj())
            }

        }
    }
    
    private func ParseResponse(json: JSON) -> MusicObj
    {
        let musicObj = MusicObj()
        
        musicObj.MusicName = json["musicName"].stringValue
        musicObj.MusicName = json["musicName"].stringValue
        musicObj.MusicName = json["artistName"].stringValue
        musicObj.MusicName = json["artistId"].stringValue
        musicObj.MusicName = json["musicID"].stringValue
        musicObj.MusicName = json["url"].stringValue
        musicObj.MusicName = json["largpicUrl"].stringValue
        musicObj.MusicName = json["smallpicUrl"].stringValue
        musicObj.MusicName = json["time"].stringValue
        musicObj.MusicName = json["shareUrl"].stringValue
        musicObj.MusicName = json["like"].stringValue
        musicObj.MusicName = json["download"].stringValue
        musicObj.MusicName = json["irancellCode"].stringValue
        musicObj.MusicName = json["hamrahavalCode"].stringValue
        
        return musicObj
    }
    
    
}
