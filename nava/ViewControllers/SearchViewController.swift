//
//  SearchViewController.swift
//  nava
//
//  Created by Mohsenian on 7/18/1395 AP.
//  Copyright © 1395 manshor. All rights reserved.
//

import UIKit
import SCLAlertView

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    

    
    private var singerMediaItems : [MediaItem] = [MediaItem]()
    
    private var categoryList : [SearchTypeItem] = []
    
    private var imamList : [SearchTypeItem] = []
    
    private var madahList : [SearchTypeItem] = []
    
    private var viewList : [SearchTypeItem] = []
    
    private var pickerItems : [SearchTypeItem] = []
    
    private var mediaItems : [MediaItem] = []
    
    private var loadingBar : SCLAlertViewResponder!
    
    private var searchBarView : UIView!
    private var searchBtn : UIButton!
    private var searchTxt : UITextField!
    private var redLineView : UIView!
    
    private var searchCatView : UIView!
    private var seperatorview1 : UIView!
    private var seperatorview2 : UIView!
    private var seperatorview3 : UIView!
    private var btnMadahList : UIButton!
    private var btnImamList : UIButton!
    private var btnCategoriesList : UIButton!
    private var btnTypeSearchList : UIButton!
    
    private var dataPickerView : UIPickerView!
    private var viewSizePercent : CGSize!
    
    private var searchView : UIView!
    private var tableView : UITableView!
    
    private var searchType : NavaEnums.SearchType  = .None
    
    private var isSearchTypeListLoaded : Array<Bool> = []
    
    private var searchParams : Array<String> = ["","","","","",""]
    
    private var pageNo = 0
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.searchParams[4] = String(pageNo)
        
        let appearance = SCLAlertView.SCLAppearance(
//            showCloseButton: false
        )
        
        loadingBar = SCLAlertView(appearance: appearance).showWait("بارگیری اطلاعات", subTitle: "لطفا شکیبا باشید")
        
        ServiceManager.GetSearchTypeList(searchType: .categories) { (status, searchTypeList) in
            if status
            {
                self.categoryList = searchTypeList
                
                self.searchParams[1] = searchTypeList[0].TypeID
            }
            
            self.isSearchTypeListLoaded.append(status)
        }
        
        ServiceManager.GetSearchTypeList(searchType: .imamlist) { (status, searchTypeList) in
            if status
            {
                self.imamList = searchTypeList
                self.searchParams[2] = searchTypeList[0].TypeID
            }
            
            self.isSearchTypeListLoaded.append(status)
        }
        
        ServiceManager.GetSearchTypeList(searchType: .madahlist) { (status, searchTypeList) in
            if status
            {
                self.madahList = searchTypeList
                self.searchParams[3] = searchTypeList[0].TypeID
            }
            
            self.isSearchTypeListLoaded.append(status)
        }
        
        ServiceManager.GetSearchTypeList(searchType: .typesearchlist) { (status, searchTypeList) in
            if status
            {
                self.viewList = searchTypeList
                
                self.searchParams[0] = searchTypeList[0].TypeID
            }
            self.isSearchTypeListLoaded.append(status)
        }
        
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
            
            while(true)
            {
                if self.isSearchTypeListLoaded.count == 4
                {
                    DispatchQueue.main.async {
                        print("This is run on the main queue, after the previous code in outer block")
                        self.loadingBar.close()
                    }
                    
                    break
                }
            }
        }
        
        
        viewSizePercent = CGSize(width: self.view.layer.frame.size.width / 100 , height: (self.view.layer.frame.size.height) / 100)
        
        self.view.backgroundColor = UIColor.clear
        
        //self.hideKeyboardWhenTappedAround()
        
        // Do any additional setup after loading the view.
        
        SetSearchBarView()
        SetSearchCatView()
        SetSearchListView()
        
        
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func SetSearchBarView ()
    {
        
        //Set Search Bar View Properties
        self.searchBarView = UIView()
        self.searchBarView.frame.size = CGSize(width: viewSizePercent.width * 100, height: viewSizePercent.height * 8)
        self.searchBarView.frame.origin = CGPoint(x: 0, y:0)
        self.searchBarView.backgroundColor = .black
        
        
        //Set Search Text
        self.searchTxt = UITextField()
        self.searchBarView.addSubview(self.searchTxt)
        self.searchTxt.frame.size = CGSize(width: viewSizePercent.width * 70, height: viewSizePercent.height * 6.5)
        self.searchTxt.frame.origin = CGPoint(x: viewSizePercent.width * 5, y: (self.searchTxt.superview?.frame.size.height)! * 0.1 )
        self.searchTxt.text = Tools.StaticVariables.SearchDefaultTitle
        self.searchTxt.textColor = UIColor.white
        self.searchTxt.textAlignment = .right
        self.searchTxt.returnKeyType = .search
        self.searchTxt.delegate = self
        
        //Set Red Line View
        self.redLineView = UIView()
        self.searchBarView.addSubview(self.redLineView)
        self.redLineView.frame.size = CGSize(width: self.searchTxt.frame.size.width, height: viewSizePercent.height * 0.1 )
        self.redLineView.frame.origin = CGPoint(x: self.searchTxt.frame.origin.x, y: self.searchTxt.frame.origin.y + self.searchTxt.frame.size.height )
        self.redLineView.backgroundColor = UIColor.red
        
        
        //Set Search Button
        self.searchBtn = UIButton()
        self.searchBarView.addSubview(self.searchBtn)
        self.searchBtn.frame.size = CGSize(width: viewSizePercent.width * 25, height: viewSizePercent.height * 8)
        self.searchBtn.frame.origin = CGPoint(x: self.searchBarView.frame.width - self.searchBtn.frame.size.width , y: 0)
        self.searchBtn.center.y = self.searchBarView.center.y
        self.searchBtn.setImage(UIImage(named:Tools.StaticVariables.SearchTabImage), for: .normal)
        self.searchBtn.imageEdgeInsets = UIEdgeInsets(top: 10 , left: 30, bottom: 10, right: 30)
        self.searchBtn.addTarget(self, action: #selector(self.Search), for: UIControlEvents.touchUpInside)
        
        
        self.view.addSubview(self.searchBarView)
        
    }
    
    func SetSearchCatView()
    {
        self.searchCatView = UIView()
        self.searchCatView.frame.size = CGSize(width: self.searchBarView.frame.size.width * 1.1, height: self.searchBarView.frame.size.height)
        self.searchCatView.frame.origin = CGPoint(x: -5, y: self.searchBarView.frame.size.height)
        self.searchCatView.backgroundColor = UIColor.black
//        self.searchCatView.layer.borderColor = UIColor.white.cgColor
//        self.searchCatView.layer.borderWidth = 1
        
        //Sort Button
        self.btnTypeSearchList = Tools.MakeUIButtonWithAttributes(btnName: Tools.StaticVariables.SortButtonTitle,fontSize: 14.0)
        self.btnTypeSearchList.frame.size = CGSize(width: viewSizePercent.width * 24.5, height: self.searchCatView.frame.size.height)
        self.btnTypeSearchList.frame.origin = CGPoint(x: 0, y: 0)
        self.btnTypeSearchList.addTarget(self, action: #selector(self.SortAction), for: .touchUpInside)
        self.searchCatView.addSubview(self.btnTypeSearchList)
       
        
        //Seperator one
        self.seperatorview1 = UIView()
        self.seperatorview1.frame.size = CGSize(width:viewSizePercent.width * 0.5, height: self.searchCatView.frame.size.height * 0.75)
        self.seperatorview1.backgroundColor = UIColor.red
        self.seperatorview1.frame.origin = CGPoint(x: self.btnTypeSearchList.frame.size.width, y: 0)
        self.seperatorview1.center.y = self.searchCatView.frame.size.height / 2
       
        
        //Category Button
        self.btnCategoriesList = Tools.MakeUIButtonWithAttributes(btnName: Tools.StaticVariables.CategoryButtonTitle,fontSize: 14.0)
        self.btnCategoriesList.frame.size = self.btnTypeSearchList.frame.size
        self.btnCategoriesList.frame.origin = CGPoint(x: self.seperatorview1.frame.origin.x
                                              + self.seperatorview1.frame.size.width, y: 0)
        self.btnCategoriesList.addTarget(self, action: #selector(self.CatAction), for: .touchUpInside)
        self.searchCatView.addSubview(self.btnCategoriesList)
        
        
        //Seperator two
        self.seperatorview2 = UIView()
        self.seperatorview2.frame.size = self.seperatorview1.frame.size
        self.seperatorview2.backgroundColor = UIColor.red
        self.seperatorview2.frame.origin = CGPoint(x: self.btnCategoriesList.frame.origin.x
                                                    + self.btnCategoriesList.frame.size.width , y: 0)
        
        self.seperatorview2.center.y = self.searchCatView.frame.size.height / 2
        
        
        //In Saying Button
        self.btnImamList = Tools.MakeUIButtonWithAttributes(btnName: Tools.StaticVariables.InSayingButton,fontSize: 14.0)
        self.btnImamList.frame.size = self.btnTypeSearchList.frame.size
        self.btnImamList.frame.origin = CGPoint(x: self.seperatorview2.frame.origin.x
            + self.seperatorview2.frame.size.width, y: 0)
        self.btnImamList.addTarget(self, action: #selector(self.InSayingAction), for: .touchUpInside)
        self.searchCatView.addSubview(self.btnImamList)
        
        
        //Seperator three
        self.seperatorview3 = UIView()
        self.seperatorview3.frame.size = self.seperatorview1.frame.size
        self.seperatorview3.backgroundColor = UIColor.red
        self.seperatorview3.frame.origin = CGPoint(x: self.btnImamList.frame.origin.x + self.btnImamList.frame.size.width, y: 0)
        self.seperatorview3.center.y = self.searchCatView.frame.size.height / 2
        
        
        //In Saying Button
        self.btnMadahList = Tools.MakeUIButtonWithAttributes(btnName: Tools.StaticVariables.SingerButtonTitle,fontSize: 14.0)
        self.btnMadahList.frame.size = self.btnTypeSearchList.frame.size
        self.btnMadahList.frame.origin = CGPoint(x: self.seperatorview3.frame.origin.x
            + self.seperatorview3.frame.size.width, y: 0)
        self.btnMadahList.addTarget(self, action: #selector(self.SingerAction), for: .touchUpInside)
        self.searchCatView.addSubview(self.btnMadahList)
        
        
        
        //Add Component
        self.searchCatView.addSubview(self.btnTypeSearchList)
        self.searchCatView.addSubview(self.seperatorview1)
        self.searchCatView.addSubview(self.btnCategoriesList)
        self.searchCatView.addSubview(self.seperatorview2)
        self.searchCatView.addSubview(self.btnImamList)
        self.searchCatView.addSubview(self.seperatorview3)
        self.searchCatView.addSubview(self.btnMadahList)
        //self.searchCatView.addSubview(self.dataPickerView)
        
        
        //Add View to Main View
        self.view.addSubview(self.searchCatView)

    }
    
    func SetSearchListView()
    {
        
        self.searchView = UIView()
        
        let p = self.tabBarController?.tabBar.layer.preferredFrameSize().height
        
        self.searchView.frame.size = CGSize(width: viewSizePercent.width * 100, height: viewSizePercent.height * 82 - p!)
        
        self.searchView.frame.origin = CGPoint(x: 0, y:self.searchBarView.frame.size.height + self.searchCatView.frame.size.height)
        
        
        // set tableview properties
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(MediaCell.self, forCellReuseIdentifier: Tools.StaticVariables.cellReuseIdendifier)
        tableView.rowHeight = MediaCell.cellHeight
        tableView.backgroundColor = .black
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = CGRect(x: 0, y: 0, width: searchView.frame.width , height: searchView.frame.height)
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 140, right: 0)
        
        //UI Picker View
        self.dataPickerView = UIPickerView()
        self.dataPickerView.dataSource = self
        self.dataPickerView.delegate = self
        self.dataPickerView.frame.size = CGSize(width: self.searchCatView.frame.size.width, height: self.viewSizePercent.height * 30)
        
        self.dataPickerView.frame.origin = CGPoint(x: 0, y: -1 * self.dataPickerView.frame.size.height)
        self.dataPickerView.backgroundColor = UIColor.darkGray
        self.dataPickerView.contentMode = .center
        
        self.searchView.addSubview(self.tableView)
        self.searchView.addSubview(self.dataPickerView)
        
        self.view.addSubview(self.searchView)
        
        self.view.bringSubview(toFront: searchBarView)
        self.view.bringSubview(toFront: self.searchCatView)
        
    }
    
    private func ShowAndHidePickerView(mySearchType : NavaEnums.SearchType)
    {
        
        if searchType == .None
        {
        
            searchType = mySearchType
            
            UIView.animate(withDuration: 0.2) {
                
                self.dataPickerView.frame.origin.y = 1
                
            }
            
        }
        else if searchType != .None && searchType != mySearchType
        {
            searchType = mySearchType
            
            UIView.animate(withDuration: 0.2)
            {
                self.dataPickerView.frame.origin.y = -1 * self.viewSizePercent.height * 30
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                // your code here
                UIView.animate(withDuration: 0.2) {
                    
                    self.dataPickerView.frame.origin.y = 1
                    
                }
                
            }
            
            
        }
        else if searchType == mySearchType
        {
            searchType = .None
            
            UIView.animate(withDuration: 0.2)
            {
                self.dataPickerView.frame.origin.y = -1 * self.viewSizePercent.height * 30
            }
        }
    }
    
    @objc private func SingerAction()
    {
        pickerItems = madahList
        dataPickerView.reloadAllComponents()
        ShowAndHidePickerView(mySearchType : .madahlist)
       
    }
    
    @objc private func InSayingAction()
    {
        pickerItems = imamList
        dataPickerView.reloadAllComponents()
        ShowAndHidePickerView(mySearchType :.imamlist)
       
    }
    
    @objc private func CatAction()
    {
        pickerItems = categoryList
        dataPickerView.reloadAllComponents()
        ShowAndHidePickerView(mySearchType :.categories)
       
    }
    
    @objc private func SortAction()
    {
        
        pickerItems = viewList
        dataPickerView.reloadAllComponents()
        ShowAndHidePickerView(mySearchType :.typesearchlist)

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.searchTxt.becomeFirstResponder()
        self.searchTxt.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTxt {
            textField.resignFirstResponder()
            Search()
            return false
        }
        return true
    }
    
    @objc private func Search()
    {
        
        view.endEditing(true)
        
        if pageNo == 0
        {
            pageNo += 1
            
            self.searchParams[4] = String(pageNo)
        }
        
        if searchTxt.text == "" {
            self.searchParams[5] = "all"
        }
        else
        {
            self.searchParams[5] = searchTxt.text!
        }
        
        
        ServiceManager.GetSearchList(searchParams: searchParams) { (status, myMedia) in
            if status
            {
                for item in myMedia
                {
                    self.mediaItems.append(item)
                }
                
                self.tableView.reloadData()
                
                self.pageNo += 1
                
                self.searchParams[4] = String(self.pageNo)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaItems.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let media = mediaItems[indexPath.row]
        
         let stb = UIStoryboard(name: "Main", bundle: nil)
        
        print(media.MediaType.rawValue)
        
        if media.MediaType == .sound
        {
            let musicPlayerViewController = stb.instantiateViewController(withIdentifier: "MusicPlayerViewController") as! MusicPlayerViewController
            HomeViewController.mediaItem = media
            
            self.present(musicPlayerViewController, animated: false) {
                
            }
        }
        else
        {
            let videoPlayerViewController = stb.instantiateViewController(withIdentifier: "VideoPlayerViewController") as! VideoPlayerViewController
            videoPlayerViewController.mediaItem = media
            
            self.present(videoPlayerViewController, animated: false) {
                
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellSize = CGSize(width: Tools.screenWidth, height: Tools.screenHeight * 0.25)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Tools.StaticVariables.cellReuseIdendifier, for: indexPath as IndexPath) as! MediaCell
        
        
        print("Cell Height: \(cell.frame.size.height)")
        
        cell.frame.size = cellSize
        
        let p =  URL(string:mediaItems[indexPath.row].LargpicUrl)!
        
        cell.musicImage.af_setImage(withURL:p)
        
        print("TableView Row Height: \(tableView.rowHeight)")
        
        print("TableView Row Height estimate: \(tableView.estimatedRowHeight)")
        
        print("Cell Height: \(cell.frame.size.height)")
        
        return cell
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerItems.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerItems[row].TypeName as String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
        view.endEditing(true)
        
        let myNormalAttributedTitle = NSAttributedString(string: pickerItems[row].TypeName,
                                                         attributes: [NSForegroundColorAttributeName : UIColor.white,NSUnderlineStyleAttributeName : 0])
        switch searchType {
        case .categories:
            self.searchParams[1] = pickerItems[row].TypeID
            self.btnCategoriesList.setAttributedTitle(myNormalAttributedTitle, for: .normal)
        case .imamlist:
            self.searchParams[2] = pickerItems[row].TypeID
            self.btnImamList.setAttributedTitle(myNormalAttributedTitle, for: .normal)
        case .madahlist:
            self.searchParams[3] = pickerItems[row].TypeID
            self.btnMadahList.setAttributedTitle(myNormalAttributedTitle, for: .normal)
        case .typesearchlist:
            self.searchParams[0] = pickerItems[row].TypeID
            self.btnTypeSearchList.setAttributedTitle(myNormalAttributedTitle, for: .normal)
        default:
            break
        }
        
        ///ShowAndHidePickerView(mySearchType : searchType)
        
        //        ShowAndHidePickerView(mySearchType: searchType)
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let string = pickerItems[row].TypeName as String
        return NSAttributedString(string: string, attributes: [NSForegroundColorAttributeName:UIColor.white])
    }
    
}
