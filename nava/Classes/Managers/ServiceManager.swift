//
//  ServiceManager.swift
//  nava
//
//  Created by Mohsenian on 7/22/1395 AP.
//  Copyright © 1395 manshor. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import SCLAlertView

class ServiceManager: NSObject
{
    private static var baseURl : String = "http://hadsahang.arsinit.com/skysounds/index/"
    
    ///mediaType, ServiceType, madah ID, page
    private static var ParametersWithSingerURL = "itemlist/%@/%@/madah/%@/20/%@"
    
    ///mediaType, ServiceType, page
    private static var ParametersWithoutSingerURL = "itemlist/%@/%@/20/%@"
    
    private static var ParametersForLikeOrDownload = "%@/%@"
    
    private static var ParametersForSearchTypeList = "%@"
    
    private static var ParametersForSearch = "search/%@/%@/%@/%@/20/%@"
    

    
    static func GetMediaList(mediaType : NavaEnums.ServiceMediaType, serviceType : NavaEnums.ServiceType, pageNo : Int, callBack : @escaping (Bool, [MediaItem]) -> Void  )
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
                
                callBack(true, self.GetMediaFromResponse(json: json, mediaType: mediaType, serviceType: serviceType))
            case .failure(let error):
                print(error)
            }

        }
    }
    
    static func GetMediaListByArtist(mediaItem : MediaItem, mediaType : NavaEnums.ServiceMediaType, serviceType : NavaEnums.ServiceType, pageNo : Int, callBack : @escaping (Bool, [MediaItem]) -> Void  )
    {
        let urlString = String(format: ServiceManager.baseURl + ServiceManager.ParametersWithSingerURL, mediaType.rawValue, mediaItem.ArtistId, serviceType.rawValue, String(pageNo))
        
        Alamofire.request(urlString).responseJSON { (response) in
            print("Request: \(response.request)")
            print("Response: \(response.response)")
            print("Data: \(response.data)")
            print("Error: \(response.result)")
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                callBack(true, self.GetMediaFromResponse(json: json, mediaType: mediaType, serviceType: serviceType))
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    static func DownloadMedia(mediaItem: MediaItem, callBack : @escaping (Bool) -> Void  ) {
        
        var localPath : URL?
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            
            if mediaItem.MediaType == .sound {
                documentsURL.appendPathComponent("MyMedia/." + mediaItem.MediaID + ".mp3")
            }
            else
            {
                documentsURL.appendPathComponent("MyMedia/." + mediaItem.MediaID + ".mp4")
            }
            
            localPath = documentsURL
            
            return (documentsURL ,[.removePreviousFile, .createIntermediateDirectories])
        }
        
        
        Alamofire.download(mediaItem.MediaUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!, to: destination).downloadProgress(closure: { (prog) in
            print("Download Progress: \(prog.fractionCompleted * 100)")
            
            var fileInfo = [String:String]()
            fileInfo[Tools.StaticVariables.MediaIdNotificationsKey] = String(mediaItem.MediaID)
            fileInfo[Tools.StaticVariables.ProgressNotificationsKey] = String(Int(round(prog.fractionCompleted * 100)))
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Tools.StaticVariables.DownloadProgressNotificationKey), object: nil, userInfo: fileInfo)
       
            
            
        }).responseData { response in
            
            switch response.result {
            case .success:
                
                mediaItem.MediaUrl = localPath!.absoluteString
                
                MediaManager.AddNewMediaToDB(mediaItems: [mediaItem])
                
                callBack(true)
                
            case .failure(let error):
                print(error)
                callBack(false)
            }
        }
        
    }
    
    private static func GetMediaFromResponse(json: JSON, mediaType : NavaEnums.ServiceMediaType, serviceType: NavaEnums.ServiceType) -> [MediaItem]
    {
        
        var mediaItemArray = [MediaItem]()
        
        
        for (_,subJson):(String, JSON) in json {
            let mediaItem = MediaItem()
            
            mediaItem.MediaName = subJson["musicName"].stringValue
            mediaItem.ArtistName = subJson["artistName"].stringValue
            mediaItem.ArtistId = subJson["artistId"].stringValue
            mediaItem.MediaID = subJson["musicID"].stringValue
            mediaItem.MediaType = mediaType
            mediaItem.MediaServiceType = serviceType
            mediaItem.MediaUrl = subJson["url"].stringValue
            mediaItem.LargpicUrl = subJson["largpicUrl"].stringValue
            mediaItem.SmallpicUrl = subJson["smallpicUrl"].stringValue
            mediaItem.Time = subJson["time"].stringValue
            mediaItem.ShareUrl = subJson["shareUrl"].stringValue
            mediaItem.Like = subJson["like"].stringValue
            mediaItem.Download = subJson["download"].stringValue
            mediaItem.IrancellCode = subJson["irancellCode"].stringValue
            mediaItem.HamrahavalCode = subJson["hamrahavalCode"].stringValue
            
            mediaItemArray.append(mediaItem)
        }
        

        
        return mediaItemArray
    }
    
    static func LikeOrDwonloadCountAdd(mediaItem : MediaItem, isLike: Bool, callBack : @escaping (Bool) -> Void  )
    {
        
        var likeOrDownloadString = ""
        
        if isLike {
            likeOrDownloadString = "like"
        }else{
            likeOrDownloadString = "download"
        }
        
        
        let urlString = String(format: ServiceManager.baseURl + ServiceManager.ParametersForLikeOrDownload, likeOrDownloadString, String(mediaItem.MediaID))
        
        Alamofire.request(urlString).responseJSON { (response) in
            print("Request: \(response.request)")
            print("Response: \(response.response)")
            print("Data: \(response.data)")
            print("Error: \(response.result)")
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                callBack(true)
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    static func GetSearchTypeList(searchType : NavaEnums.SearchType,callBack : @escaping (Bool, [SearchTypeItem]) -> Void  )
    {
        let urlString = String(format: ServiceManager.baseURl + ServiceManager.ParametersForSearchTypeList, searchType.rawValue)
        
        Alamofire.request(urlString).responseJSON { (response) in
            print("Request: \(response.request)")
            print("Response: \(response.response)")
            print("Data: \(response.data)")
            print("Error: \(response.result)")
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                callBack(true, self.GetSearchTypeListFromResponse(json: json,searchListType: searchType))
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    private static func GetSearchTypeListFromResponse(json: JSON, searchListType : NavaEnums.SearchType) -> [SearchTypeItem]
    {
        
        var searchTypeList = [SearchTypeItem]()
        
        var superKey = ""
        var subIDKey = ""
        var subNameKey = ""
        
        
        switch searchListType {
        case .categories:
            
            superKey = "categorylist"
            subIDKey = "categoryId"
            subNameKey = "categoryName"
            
        case .imamlist:
            superKey = "imamlist"
            subIDKey = "imamId"
            subNameKey = "imamName"
        case .madahlist:
            superKey = "madahlist"
            subIDKey = "artistId"
            subNameKey = "artistName"
        case .typesearchlist:
            superKey = "viewtypelist"
            subIDKey = "viewId"
            subNameKey = "viewName"
        default:
            superKey = "None"
            subIDKey = "None"
            subNameKey = "None"
        }
        
        
        if let arrayJson = json.dictionaryValue[superKey]
        {
            
            for (_,subJson):(String, JSON) in arrayJson {
                //Do something you want
                let searchType = SearchTypeItem()
                
                searchType.TypeID = subJson[subIDKey].stringValue
                searchType.TypeName = subJson[subNameKey].stringValue
                
                searchTypeList.append(searchType)
            }
        }

        return searchTypeList
    }
    
    
    static func GetSearchList(searchParams: Array<String>, callBack : @escaping (Bool, [MediaItem]) -> Void  )
    {
        let urlString = String(format: ServiceManager.baseURl + ServiceManager.ParametersForSearch, searchParams[0], searchParams[1], searchParams[2], searchParams[3], searchParams[4])
        
        Alamofire.request(urlString).responseJSON { (response) in
            print("Request: \(response.request)")
            print("Response: \(response.response)")
            print("Data: \(response.data)")
            print("Error: \(response.result)")
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                //callBack(true, self.GetMediaFromResponse(json: json, mediaType: mediaType, serviceType: serviceType))
            case .failure(let error):
                print(error)
            }
            
        }
    }
}
