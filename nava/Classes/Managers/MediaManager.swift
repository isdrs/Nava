//
//  ContactsManager.swift
//  salamiha
//
//  Created by Admin on ۱۳۹۵/۵/۱۸ ه‍.ش..
//  Copyright © ۱۳۹۵ ه‍.ش. mhmhb. All rights reserved.
//

import UIKit
import Foundation
import GRDB

class MediaManager: NSObject {

    static func IsFavoritedMedia (mediaItem : MediaItem) -> Bool
    {
        let mediaItems = GetFavoriteMedia(mediaType: mediaItem.MediaType)
        
        for item in mediaItems {
            if mediaItem.MediaID == item.MediaID {
                if mediaItem.MediaType == item.MediaType {
                    if mediaItem.MediaServiceType == item.MediaServiceType {
                        return true
                    }
                }
            }
        }
        
        return false

    }
    
    static func IsDownloadedMedia( mediaItem : MediaItem ) -> MediaItem?
    {
        let mediaItems = GetDBMedia(mediaType: mediaItem.MediaType)
        
        for item in mediaItems {
            if mediaItem.MediaID == item.MediaID {
                if mediaItem.MediaType == item.MediaType {
                    if mediaItem.MediaServiceType == item.MediaServiceType {
                        return item
                    }
                }
            }
        }
        
        return nil
    }

    static func IsLikedMedia( mediaItem : MediaItem) -> Bool
    {
        let mediaItems = GetDBLikes(mediaType: mediaItem.MediaType)
        
        for item in mediaItems {
            if mediaItem.MediaID == item.MediaID {
                if mediaItem.MediaType == item.MediaType {
                    if mediaItem.MediaServiceType == item.MediaServiceType {
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    ///Get local contacts from databse
    static func GetDBMedia(mediaType : NavaEnums.ServiceMediaType) -> [MediaItem]
    {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        
        let databasePath = documentsPath.appendingPathComponent("/media_item.sqlite")
        
        let dbQueue = try! DatabaseQueue(path: databasePath)
        
        var dbMedia = [MediaItem]()
        
        dbQueue.inDatabase { db in
            do
            {
                let rows = try Row.fetchAll(db,
                                            "SELECT * FROM Media WHERE media_type = ?",
                                            arguments: [mediaType.rawValue])
                
                for row in rows
                {
                    
                    let mediaItem = MediaItem()
                    
                    mediaItem.MediaName = row.value(named: "media_name")
                    mediaItem.ArtistName = row.value(named: "media_singer")
                    mediaItem.ArtistId = row.value(named: "media_singer_id")
                    mediaItem.MediaID = row.value(named: "media_id")
                    mediaItem.MediaType = NavaEnums.ServiceMediaType.GetFromString(typeString: row.value(named: "media_type"))
                    mediaItem.MediaServiceType = NavaEnums.ServiceType.GetFromString(typeString: row.value(named: "media_service_type"))
                    mediaItem.MediaUrl = row.value(named: "media_url")
                    mediaItem.LargpicUrl = row.value(named: "media_pic")
                    //mediaItem.LargpicUrl = mediaItem.LargpicUrl
                    mediaItem.Time = row.value(named: "media_time")
                    mediaItem.ShareUrl = row.value(named: "media_share")
                    mediaItem.IrancellCode = row.value(named: "media_irancell")
                    mediaItem.HamrahavalCode = row.value(named: "media_hamrahaval")
                    
                    dbMedia.append(mediaItem)
                }
            }
            catch
            {
                
            }
        }
        
        return dbMedia
    }

    static func GetFavoriteMedia(mediaType : NavaEnums.ServiceMediaType) -> [MediaItem]
    {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        
        let databasePath = documentsPath.appendingPathComponent("/media_item.sqlite")
        
        let dbQueue = try! DatabaseQueue(path: databasePath)
        
        var dbMedia = [MediaItem]()
        
        dbQueue.inDatabase { db in
            
            do
            {
                let rows = try Row.fetchAll(db,
                                            "SELECT * FROM " + Tools.StaticVariables.FavoriteTableName + " WHERE media_type = ?",
                                            arguments: [mediaType.rawValue])
                
                for row in rows
                {
                    
                    let mediaItem = MediaItem()
                    
                    mediaItem.MediaName = row.value(named: "media_name")
                    mediaItem.ArtistName = row.value(named: "media_singer")
                    mediaItem.ArtistId = row.value(named: "media_singer_id")
                    mediaItem.MediaID = row.value(named: "media_id")
                    mediaItem.MediaType = NavaEnums.ServiceMediaType.GetFromString(typeString: row.value(named: "media_type"))
                    mediaItem.MediaServiceType = NavaEnums.ServiceType.GetFromString(typeString: row.value(named: "media_service_type"))
                    mediaItem.MediaUrl = row.value(named: "media_url")
                    mediaItem.LargpicUrl = row.value(named: "media_pic")
                    //mediaItem.LargpicUrl = mediaItem.LargpicUrl
                    mediaItem.Time = row.value(named: "media_time")
                    mediaItem.ShareUrl = row.value(named: "media_share")
                    mediaItem.IrancellCode = row.value(named: "media_irancell")
                    mediaItem.HamrahavalCode = row.value(named: "media_hamrahaval")
                    
                    dbMedia.append(mediaItem)
                }
            }
            catch
            {
                
            }
        }
        
        return dbMedia
    }

    
    static func DeleteDBMeida(mediaItem: MediaItem) -> Bool
    {
        var res = false
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        
        let databasePath = documentsPath.appendingPathComponent("/media_item.sqlite")
        
        let dbQueue = try! DatabaseQueue(path: databasePath)
        
        dbQueue.inDatabase { db in
            
            do {
                try Media.deleteOne(db, key: ["media_id": mediaItem.MediaID])
                
                res = true
            }
            catch
            {
                res = false
            }
        }
        
        return res
    }

    static func DeleteDBFavorites(mediaItem: MediaItem) -> Bool
    {
        var res = false
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        
        let databasePath = documentsPath.appendingPathComponent("/media_item.sqlite")
        
        let dbQueue = try! DatabaseQueue(path: databasePath)
        
        dbQueue.inDatabase { db in
            
            do {
                try Favorites.deleteOne(db, key: ["media_id": mediaItem.MediaID])
                
                res =  true
            }
            catch
            {
                res =  false
            }
        }
        
        return res
    }
    
    static func GetDBLikes(mediaType : NavaEnums.ServiceMediaType) -> [MediaItem]
    {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        
        let databasePath = documentsPath.appendingPathComponent("/media_item.sqlite")
        
        let dbQueue = try! DatabaseQueue(path: databasePath)
        
        var dbMedia = [MediaItem]()
        
        dbQueue.inDatabase { db in
            
            do
            {
                let rows = try Row.fetchAll(db,
                                             "SELECT * FROM Likes WHERE media_type = ?",
                                            arguments: [mediaType.rawValue])
                
                for row in rows
                {
                    
                    let mediaItem = MediaItem()
                    
                    
                    mediaItem.MediaID = row.value(named: "media_id")
                    mediaItem.MediaType = NavaEnums.ServiceMediaType.GetFromString(typeString: row.value(named: "media_type"))
                    mediaItem.MediaServiceType = NavaEnums.ServiceType.GetFromString(typeString: row.value(named: "media_service_type"))
                    
                    
                    dbMedia.append(mediaItem)
                }
            }
            catch
            {
                
            }
        }
        
        return dbMedia
    }
    
    static func DeleteDBLikes(mediaItem: MediaItem) -> Bool
    {
        var isInserted = false
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        
        let databasePath = documentsPath.appendingPathComponent("/media_item.sqlite")
        
        let dbQueue = try! DatabaseQueue(path: databasePath)
        
               dbQueue.inDatabase { db in
            
            do {
                try Like.deleteOne(db, key: ["media_id": mediaItem.MediaID])
                
                isInserted = true
            }
            catch
            {
                isInserted = false
            }
        }
        
        return isInserted
    }

    ///Add array of user item as new contact to databse
    static func AddNewMediaToDB(mediaItems: [MediaItem])
    {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        
        let databasePath = documentsPath.appendingPathComponent("/media_item.sqlite")
        
        let dbQueue = try! DatabaseQueue(path: databasePath)
        
        do
        {
            try dbQueue.inDatabase { db in
                
                for mediaItem in mediaItems
                {
                    let media = Media(
                        mediaName : mediaItem.MediaName,
                        artistName : mediaItem.ArtistName,
                        artistId : mediaItem.ArtistId,
                        mediaID : mediaItem.MediaID,
                        mediaType : mediaItem.MediaType,
                        mediaServiceType : mediaItem.MediaServiceType,
                        mediaUrl : mediaItem.MediaUrl,
                        largpicUrl : mediaItem.LargpicUrl,
                        time : mediaItem.Time,
                        shareUrl : mediaItem.ShareUrl,
                        hamrahavalCode : mediaItem.HamrahavalCode,
                        irancellCode : mediaItem.IrancellCode
                    )
                    
                    try media.insert(db)
                }
            }
        }catch
        {
        }
    }

    ///Add array of user item as new contact to databse
    static func AddNewFavoriteToDB(mediaItems: [MediaItem]) -> Bool
    {
        var res = false
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        
        let databasePath = documentsPath.appendingPathComponent("/media_item.sqlite")
        
        let dbQueue = try! DatabaseQueue(path: databasePath)
        
        do
        {
            try dbQueue.inDatabase { db in
                
                for mediaItem in mediaItems
                {
                    let favorites = Favorites(
                        mediaName : mediaItem.MediaName,
                        artistName : mediaItem.ArtistName,
                        artistId : mediaItem.ArtistId,
                        mediaID : mediaItem.MediaID,
                        mediaType : mediaItem.MediaType,
                        mediaServiceType : mediaItem.MediaServiceType,
                        mediaUrl : mediaItem.MediaUrl,
                        largpicUrl : mediaItem.LargpicUrl,
                        time : mediaItem.Time,
                        shareUrl : mediaItem.ShareUrl,
                        hamrahavalCode : mediaItem.HamrahavalCode,
                        irancellCode : mediaItem.IrancellCode
                    )
                    
                    try favorites.insert(db)
                    res = true
                    
                }
            }
        }catch
        {
            res = false
        }
        return res
    }
    
    ///Add array of user item as new contact to databse
    static func AddNewLikeToDB(mediaItem: MediaItem)
    {
        let documentsPath : String = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString) as String
        
        let databasePath = documentsPath.appending("/media_item.sqlite")
        
        let dbQueue = try! DatabaseQueue(path: databasePath)
        
        
        do
        {
            try dbQueue.inDatabase { db in
                
                let like = Like(
                    
                    mediaID : mediaItem.MediaID,
                    mediaType : mediaItem.MediaType,
                    mediaServiceType : mediaItem.MediaServiceType
                )
                
                try like.insert(db)
                
            }
        }catch
        {
        }
    }
    


    ///Database custom class row
    class Media : Record
    {
        var mediaName : String
        var artistName : String
        var artistId : String
        var mediaID : String
        var mediaType : NavaEnums.ServiceMediaType
        var mediaServiceType : NavaEnums.ServiceType
        var mediaUrl : String
        var largpicUrl : String
        var time : String
        var shareUrl : String
        var hamrahavalCode : String
        var irancellCode : String
        
        override class var databaseTableName: String {
            return "Media"
        }
        
        init(
            mediaName : String,
            artistName : String,
            artistId : String,
            mediaID : String,
            mediaType : NavaEnums.ServiceMediaType,
            mediaServiceType : NavaEnums.ServiceType,
            mediaUrl : String,
            largpicUrl : String,
            time : String,
            shareUrl : String,
            hamrahavalCode : String,
            irancellCode : String)
        {
            self.mediaName = mediaName
            self.artistName = artistName
            self.artistId = artistId
            self.mediaID = mediaID
            self.mediaType = mediaType
            self.mediaServiceType = mediaServiceType
            self.mediaUrl = mediaUrl
            self.largpicUrl = largpicUrl
            self.time = time
            self.shareUrl = shareUrl
            self.hamrahavalCode = hamrahavalCode
            self.irancellCode = irancellCode
                
            super.init()
        }
        
        required init(_ row: Row) {
            
            mediaName = row.value(named: "media_name")
            artistName = row.value(named: "media_singer")
            artistId = row.value(named: "media_singer_id")
            mediaID = row.value(named: "media_id")
            mediaType = NavaEnums.ServiceMediaType.GetFromString(typeString: row.value(named: "media_type"))
            mediaServiceType = NavaEnums.ServiceType.GetFromString(typeString: row.value(named: "media_service_type"))
            mediaUrl = row.value(named: "media_url")
            largpicUrl = row.value(named: "media_pic")
            time = row.value(named: "media_time")
            shareUrl = row.value(named: "media_share")
            irancellCode = row.value(named: "media_irancell")
            hamrahavalCode = row.value(named: "media_hamrahaval")
            
            super.init(row: row)
        }
        
        required init(row: Row) {
            fatalError("init(row:) has not been implemented")
        }


        /// The values persisted in the database
        override var persistentDictionary: [String: DatabaseValueConvertible?] {
            return [
                "media_name" : mediaName,
                "media_singer" : artistName,
                "media_singer_id" : artistId,
                "media_id" : mediaID,
                "media_type" : mediaType.rawValue,
                "media_service_type" : mediaServiceType.rawValue,
                "media_url" : mediaUrl,
                "media_pic" : largpicUrl,
                "media_time" : time,
                "media_share" : shareUrl,
                "media_irancell" : hamrahavalCode,
                "media_hamrahaval" : irancellCode
            ]
        }
    }
    
    ///Database custom class row
    class Favorites : Record
    {
        var mediaName : String
        var artistName : String
        var artistId : String
        var mediaID : String
        var mediaType : NavaEnums.ServiceMediaType
        var mediaServiceType : NavaEnums.ServiceType
        var mediaUrl : String
        var largpicUrl : String
        var time : String
        var shareUrl : String
        var hamrahavalCode : String
        var irancellCode : String
        
        override class var databaseTableName: String {
            return Tools.StaticVariables.FavoriteTableName
        }
        
        init(
            mediaName : String,
            artistName : String,
            artistId : String,
            mediaID : String,
            mediaType : NavaEnums.ServiceMediaType,
            mediaServiceType : NavaEnums.ServiceType,
            mediaUrl : String,
            largpicUrl : String,
            time : String,
            shareUrl : String,
            hamrahavalCode : String,
            irancellCode : String)
        {
            self.mediaName = mediaName
            self.artistName = artistName
            self.artistId = artistId
            self.mediaID = mediaID
            self.mediaType = mediaType
            self.mediaServiceType = mediaServiceType
            self.mediaUrl = mediaUrl
            self.largpicUrl = largpicUrl
            self.time = time
            self.shareUrl = shareUrl
            self.hamrahavalCode = hamrahavalCode
            self.irancellCode = irancellCode
            
            super.init()
        }
        
        required init(_ row: Row) {
            
            mediaName = row.value(named: "media_name")
            artistName = row.value(named: "media_singer")
            artistId = row.value(named: "media_singer_id")
            mediaID = row.value(named: "media_id")
            mediaType = NavaEnums.ServiceMediaType.GetFromString(typeString: row.value(named: "media_type"))
            mediaServiceType = NavaEnums.ServiceType.GetFromString(typeString: row.value(named: "media_service_type"))
            mediaUrl = row.value(named: "media_url")
            largpicUrl = row.value(named: "media_pic")
            time = row.value(named: "media_time")
            shareUrl = row.value(named: "media_share")
            irancellCode = row.value(named: "media_irancell")
            hamrahavalCode = row.value(named: "media_hamrahaval")
            
            super.init(row: row)
        }
        
        required init(row: Row) {
            fatalError("init(row:) has not been implemented")
        }
        
        
        /// The values persisted in the database
        override var persistentDictionary: [String: DatabaseValueConvertible?] {
            return [
                "media_name" : mediaName,
                "media_singer" : artistName,
                "media_singer_id" : artistId,
                "media_id" : mediaID,
                "media_type" : mediaType.rawValue,
                "media_service_type" : mediaServiceType.rawValue,
                "media_url" : mediaUrl,
                "media_pic" : largpicUrl,
                "media_time" : time,
                "media_share" : shareUrl,
                "media_irancell" : hamrahavalCode,
                "media_hamrahaval" : irancellCode
            ]
        }
    }
    
    
    ///Database custom class row
    class Like : Record
    {

        var mediaID : String
        var mediaType : NavaEnums.ServiceMediaType
        var mediaServiceType : NavaEnums.ServiceType

        override class var databaseTableName: String {
            return "Likes"
        }
        
        init(

            mediaID : String,
            mediaType : NavaEnums.ServiceMediaType,
            mediaServiceType : NavaEnums.ServiceType)
        {

            self.mediaID = mediaID
            self.mediaType = mediaType
            self.mediaServiceType = mediaServiceType

            
            super.init()
        }
        
        required init(_ row: Row) {
            

            mediaID = row.value(named: "media_id")
            mediaType = NavaEnums.ServiceMediaType.GetFromString(typeString: row.value(named: "media_type"))
            mediaServiceType = NavaEnums.ServiceType.GetFromString(typeString: row.value(named: "media_service_type"))

            
            super.init(row: row)
        }
        
        required init(row: Row) {
            fatalError("init(row:) has not been implemented")
        }
        
        
        /// The values persisted in the database
        override var persistentDictionary: [String: DatabaseValueConvertible?] {
            return [

                "media_id" : mediaID,
                "media_type" : mediaType.rawValue,
                "media_service_type" : mediaServiceType.rawValue,

            ]
        }
    }
    
    
    
    static func DeleteMedia(mediaItem : MediaItem, completion: (Bool) -> Void)
    {
        var localPath : URL?
        
        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        if mediaItem.MediaType == .sound {
            documentsURL.appendPathComponent("MyMedia/." + mediaItem.MediaID + ".mp3")
        }
        else
        {
            documentsURL.appendPathComponent("MyMedia/." + mediaItem.MediaID + ".mp4")
        }
        
        localPath = documentsURL
        
        do
        {
            try FileManager().removeItem(at: localPath!)
            
           _ = DeleteDBMeida(mediaItem: mediaItem)
            
            completion(true)
        }
        catch
        {
            completion(false)
        }
        
        
    }
}

