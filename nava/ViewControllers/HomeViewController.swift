//
//  HomeViewController.swift
//  nava
//
//  Created by Mohsenian on 7/18/1395 AP.
//  Copyright © 1395 manshor. All rights reserved.
//

import UIKit
import ENSwiftSideMenu

class HomeViewController: UIViewController, ENSideMenuDelegate {

    var sideMenu : ENSideMenu!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let slideMenuVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SlideMenuViewController") as! SlideMenuViewController
        
        
        sideMenu = ENSideMenu(sourceView: self.view, menuViewController: slideMenuVC, menuPosition: .Left, blurStyle: .dark)
        
        sideMenu.menuWidth = self.view.frame.size.width / 2
        // show the navigation bar over the side menu view
        //view.bringSubviewToFront(navigationBar)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ToggleMenuAction(_ sender: AnyObject) {
        
        sideMenu.toggleMenu()
    }
    
    
    // MARK: - ENSideMenu Delegate
    func sideMenuWillOpen() {
        print("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        print("sideMenuWillClose")
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        print("sideMenuShouldOpenSideMenu")
        return true
    }
    
    func sideMenuDidClose() {
        print("sideMenuDidClose")
    }
    
    func sideMenuDidOpen() {
        print("sideMenuDidOpen")
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
