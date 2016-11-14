//
//  DataCacheManager.swift
//  salamiha
//
//  Created by Admin on ۱۳۹۵/۶/۱۷ ه‍.ش..
//  Copyright © ۱۳۹۵ ه‍.ش. mhmhb. All rights reserved.
//

import UIKit

import AlamofireImage

class DataCacheManager: NSObject
{
    
    static let ShareInstance = DataCacheManager()
    
    
    let photoCache = AutoPurgingImageCache(
        memoryCapacity: 100 * 1024 * 1024,
        preferredMemoryUsageAfterPurge: 60 * 1024 * 1024
    )
    
    
    //MARK: = Image Caching
    
    func cacheImage(image: Image, urlString: String)
    {
        let url = URL(string: urlString)
        
        let urlReq = URLRequest(url: url!)
       
        photoCache.add(image, for: urlReq)
    }
    
    func cachedImage(urlString: String) -> Image? {
        
        return photoCache.image(withIdentifier: urlString)
    }
}
