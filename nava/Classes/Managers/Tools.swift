//
//  Tools.swift
//  nava
//
//  Created by Mohammad Lashgarbolouk on 10/27/16.
//  Copyright © 2016 manshor. All rights reserved.
//


import UIKit

class Tools
{
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    
    static let YDiffer = Tools.screenHeight * 0.03
    
    static  func MakeUIButtonWithAttributes(btnName: String,fontSize: CGFloat) -> UIButton
    {
        if let font = UIFont(name: Tools.StaticVariables.AppFont, size: fontSize)
        {
            _ = [NSFontAttributeName: font]
            // do something with attributes
        } else {
            // The font "Raleway-SemiBold" is not found
        }
        
        let attrs = [//NSFontAttributeName : UIFont(name: Tools.StaticVariables.AppFont, size: fontSize),
                     NSForegroundColorAttributeName : UIColor.white,
                     NSUnderlineStyleAttributeName : 0] as [String : Any]
        
        let attrs2 = [//NSFontAttributeName : UIFont(name: Tools.StaticVariables.AppFont, size: fontSize),
                      NSForegroundColorAttributeName : UIColor.green,
                      NSUnderlineStyleAttributeName : 0] as [String : Any]
        
        let attributedString = NSMutableAttributedString(string:"")
        let buttonTitleStr = NSMutableAttributedString(string:btnName, attributes:attrs)
        
        let attributedString2 = NSMutableAttributedString(string:"")
        let buttonTitleStr2 = NSMutableAttributedString(string:btnName, attributes:attrs2)
        
        
        attributedString.append(buttonTitleStr)
        attributedString2.append(buttonTitleStr2)
        
        let newButton = UIButton()
        newButton.setAttributedTitle(attributedString, for: .normal)
        newButton.setAttributedTitle(attributedString2, for: .highlighted)
        
        return newButton
        
        
    }
    
    static func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
    
    
    class StaticVariables
    {
        
        //Assets
        static let SearchTabImage = "SearchTab"
        
        //Cell and TableView
        static let cellReuseIdendifier = "cell"
        
        
        //components Labels 
        static let AddToFavoriteButtonTitle = "افزودن به لیست علاقه مندی ها"
        static let DeleteFromFavoriteButtonTitle = "حذف از لیست علاقه مندی ها"
        static let SearchDefaultTitle = "جست و جو"
        static let SortButtonTitle = "نحوه نمایش"
        static let CategoryButtonTitle = "دسته بندی"
        static let InSayingButton = "در وصف"
        static let SingerButtonTitle = "نام ذاکر"
        
        //DataBase
        static let FavoriteTableName = "Favorites"
        
        //Notifications
        static let DownloadProgressNotificationKey = "DownloadProgressNotification"
        static let MediaIdNotificationsKey = "MediaId"
        static let ProgressNotificationsKey = "Progress"
        
        
        static let ChangeDelegateKey = "ChangeDelegate"
        static let ChangedKey = "Changed"
        
        static let AppFont = "IRANSansMobile"
        
        

    }
    
}
