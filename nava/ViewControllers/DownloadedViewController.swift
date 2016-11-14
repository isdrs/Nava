//
//  DownloadedViewController.swift
//  nava
//
//  Created by Mohsenian on 7/18/1395 AP.
//  Copyright © 1395 manshor. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class DownloadedViewController: ButtonBarPagerTabStripViewController
{
   
   
    
    override func viewDidLoad() {
        
        
        self.settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        self.settings.style.buttonBarLeftContentInset = 0
        self.settings.style.buttonBarRightContentInset = 0
        self.settings.style.buttonBarItemLeftRightMargin = 0
        self.settings.style.selectedBarBackgroundColor = .red
        self.settings.style.buttonBarItemBackgroundColor = .black
        self.settings.style.selectedBarHeight = 0.5
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        moveToViewControllerAtIndex(1)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        
        let page_Music = stb.instantiateViewController(withIdentifier: "MusicDownloadedViewController") as! MusicDownloadedViewController
        let page_Video = stb.instantiateViewController(withIdentifier: "VideoDownloadedViewController") as! VideoDownloadedViewController
        
        
        return [page_Video, page_Music ]//[page_Shahadat, page_Ayad, page_Moharram, page_Favorites]
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
