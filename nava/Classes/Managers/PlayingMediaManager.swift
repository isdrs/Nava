//
//  PlayingMediaManager.swift
//  nava
//
//  Created by Mohammad Lashgarbolouk on 11/29/16.
//  Copyright © 2016 manshor. All rights reserved.
//

import UIKit

class PlayingMediaManager: NSObject {
    
    static var CurrentMusicIndex = 0
    
    static var CurrentMediaImage : UIImage!
   
    static var ShowingMediaItem = MediaItem()
    
    static var ShowingArtistMediaItems = [MediaItem]()
    
    static var PlayingMediaItem = MediaItem()
    
    static var PlayingArtistMediaItems : [MediaItem] = [MediaItem]()
    
    
    
    static func CheckPlayingMediaItemIsShowing() -> Bool
    {
        if PlayingMediaManager.PlayingMediaItem.MediaID == PlayingMediaManager.ShowingMediaItem.MediaID
//            &&       PlayingMediaManager.PlayingMediaItem.ArtistId == PlayingMediaManager.ShowingArtistMediaItems[0].ArtistId
        {
            return true
        }
        return false
    }
    
    static func FindShowingMediaItemInShowingList() -> Int
    {
        var index = 0
        for item in ShowingArtistMediaItems {
            if item.MediaID == ShowingMediaItem.MediaID
            {
                return index
            }
            index += 1
        }
        return -1
    }
    
    static func FindPlayingMediaItemInPlayingList() -> Int
    {
        var index = 0
        for item in PlayingArtistMediaItems {
            if item.MediaID == PlayingMediaItem.MediaID
            {
                return index
            }
            index += 1
        }
        return -1
    }
    
    static func IsCurrentMediaLast() -> Bool
    {
        if PlayingMediaManager.CurrentMusicIndex == PlayingMediaManager.PlayingArtistMediaItems.count - 1
        {
            return true
        }
        return false
    }
    static func IsCurrentMediaFirst() -> Bool
    {
        if PlayingMediaManager.CurrentMusicIndex == 0
        {
            return true
        }
        return false
    }
    
    static func SetShowingMediaItemToPlaying()
    {
        //PlayingMediaManager.CurrentMusicIndex = FindShowingMediaItemInShowingList()
        PlayingMediaItem = ShowingMediaItem
        PlayingArtistMediaItems = ShowingArtistMediaItems
    }
    
    static func SetPlayingMediaItemToShow()
    {
        PlayingMediaItem = ShowingMediaItem
        PlayingArtistMediaItems = ShowingArtistMediaItems
    }

}
