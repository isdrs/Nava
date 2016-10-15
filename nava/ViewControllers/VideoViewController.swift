//
//  VideoViewController.swift
//  nava
//
//  Created by Mohsenian on 7/18/1395 AP.
//  Copyright © 1395 manshor. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class VideoViewController: ButtonBarPagerTabStripViewController {
    
    override func viewDidLoad() {
        
        
        self.settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        self.settings.style.buttonBarLeftContentInset = 0
        self.settings.style.buttonBarRightContentInset = 0
        self.settings.style.buttonBarItemLeftRightMargin = 0
        self.settings.style.selectedBarBackgroundColor = .red
        self.settings.style.buttonBarItemBackgroundColor = .black
        self.settings.style.selectedBarHeight = 0.5
        
        
        super.viewDidLoad()
        moveToViewControllerAtIndex(3)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //moveToViewControllerAtIndex(3)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(self.view.frame.origin.y)
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let stb = UIStoryboard(name: "Main", bundle: nil)
        
        let page_Shahadat = stb.instantiateViewController(withIdentifier: "ShahadatViewController") as! ShahadatViewController
        page_Shahadat.mediaType = .video
        
        let page_Ayad = stb.instantiateViewController(withIdentifier: "AyadViewController") as! AyadViewController
        page_Ayad.mediaType = .video
        
        let page_Moharram = stb.instantiateViewController(withIdentifier: "MoharramViewController") as! MoharramViewController
        page_Moharram.mediaType = .video
        
        let page_Favorites = stb.instantiateViewController(withIdentifier: "FavoritesViewController") as! FavoritesViewController
        page_Favorites.mediaType = .video
        
        return [page_Favorites, page_Moharram, page_Ayad, page_Shahadat ]//[page_Shahadat, page_Ayad, page_Moharram, page_Favorites]
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    

}
