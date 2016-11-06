//
//  SearchViewController.swift
//  nava
//
//  Created by Mohsenian on 7/18/1395 AP.
//  Copyright © 1395 manshor. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    

    
    private var singerMediaItems : [MediaItem] = [MediaItem]()
    private let pickerItems : [String] = ["Salma","سلام","3"]
    
    private var searchBarView : UIView!
    private var searchBtn : UIButton!
    private var searchTxt : UITextField!
    private var redLineView : UIView!
    
    private var searchCatView : UIView!
    private var seperatorview1 : UIView!
    private var seperatorview2 : UIView!
    private var seperatorview3 : UIView!
    private var singerBtn : UIButton!
    private var inSayBtn : UIButton!
    private var catBtn : UIButton!
    private var sortBtn : UIButton!
    
    private var dataPickerView : UIPickerView!
    private var viewSizePercent : CGSize!
    
    private var searchView : UIView!
    private var tableview : UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSizePercent = CGSize(width: Tools.GetScreenWidthPercent() , height: Tools.GetScreenHeightPercent())
        
        self.view.backgroundColor = UIColor.clear
        
        self.hideKeyboardWhenTappedAround()
        
        // Do any additional setup after loading the view.
        
        SetSearchBarView()
        SetSearchCatView()
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
        self.searchBarView.frame.origin = CGPoint(x: 0, y: 0)
        
        
        //Set Search Text
        self.searchTxt = UITextField()
        self.searchBarView.addSubview(self.searchTxt)
        self.searchTxt.frame.size = CGSize(width: viewSizePercent.width * 70, height: viewSizePercent.height * 6.5)
        self.searchTxt.frame.origin = CGPoint(x: viewSizePercent.width * 5, y: (self.searchTxt.superview?.frame.size.height)! * 0.1 )
        self.searchTxt.text = Tools.StaticVariables.SearchDefaultTitle
        self.searchTxt.textColor = UIColor.white
        self.searchTxt.textAlignment = .right
        searchTxt.addTarget(self, action: #selector(self.textFieldEditingDidBegin), for: UIControlEvents.editingDidBegin)

        
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
        self.searchCatView.backgroundColor = UIColor.gray
        self.searchCatView.layer.borderColor = UIColor.white.cgColor
        self.searchCatView.layer.borderWidth = 1
        
        //Sort Button
        self.sortBtn = Tools.MakeUIButtonWithAttributes(btnName: Tools.StaticVariables.SortButtonTitle,fontSize: 14.0)
        self.sortBtn.frame.size = CGSize(width: viewSizePercent.width * 24.5, height: self.searchCatView.frame.size.height)
        self.sortBtn.frame.origin = CGPoint(x: 0, y: 0)
        self.searchCatView.addSubview(self.sortBtn)
       
        
        //Seperator one
        self.seperatorview1 = UIView()
        self.seperatorview1.frame.size = CGSize(width:viewSizePercent.width * 0.5, height: self.searchCatView.frame.size.height * 0.75)
        self.seperatorview1.backgroundColor = UIColor.white
        self.seperatorview1.frame.origin = CGPoint(x: self.sortBtn.frame.size.width, y: 0)
        self.seperatorview1.center.y = self.searchCatView.frame.size.height / 2
       
        
        //Category Button
        self.catBtn = Tools.MakeUIButtonWithAttributes(btnName: Tools.StaticVariables.CategoryButtonTitle,fontSize: 14.0)
        self.catBtn.frame.size = self.sortBtn.frame.size
        self.catBtn.frame.origin = CGPoint(x: self.seperatorview1.frame.origin.x
                                              + self.seperatorview1.frame.size.width, y: 0)
        self.searchCatView.addSubview(self.catBtn)
        
        
        //Seperator two
        self.seperatorview2 = UIView()
        self.seperatorview2.frame.size = self.seperatorview1.frame.size
        self.seperatorview2.backgroundColor = UIColor.white
        self.seperatorview2.frame.origin = CGPoint(x: self.catBtn.frame.origin.x
                                                    + self.catBtn.frame.size.width , y: 0)
        self.seperatorview2.center.y = self.searchCatView.frame.size.height / 2
        
        
        //In Saying Button
        self.inSayBtn = Tools.MakeUIButtonWithAttributes(btnName: Tools.StaticVariables.InSayingButton,fontSize: 14.0)
        self.inSayBtn.frame.size = self.sortBtn.frame.size
        self.inSayBtn.frame.origin = CGPoint(x: self.seperatorview2.frame.origin.x
            + self.seperatorview2.frame.size.width, y: 0)
        self.searchCatView.addSubview(self.inSayBtn)
        
        
        //Seperator three
        self.seperatorview3 = UIView()
        self.seperatorview3.frame.size = self.seperatorview1.frame.size
        self.seperatorview3.backgroundColor = UIColor.white
        self.seperatorview3.frame.origin = CGPoint(x: self.inSayBtn.frame.origin.x + self.inSayBtn.frame.size.width, y: 0)
        self.seperatorview3.center.y = self.searchCatView.frame.size.height / 2
        
        
        //In Saying Button
        self.singerBtn = Tools.MakeUIButtonWithAttributes(btnName: Tools.StaticVariables.SingerButtonTitle,fontSize: 14.0)
        self.singerBtn.frame.size = self.sortBtn.frame.size
        self.singerBtn.frame.origin = CGPoint(x: self.seperatorview3.frame.origin.x
            + self.seperatorview3.frame.size.width, y: 0)
        self.searchCatView.addSubview(self.singerBtn)
        
        
        //UI Picker View
        self.dataPickerView = UIPickerView()
        self.dataPickerView.isHidden = false
        self.dataPickerView.dataSource = self
        self.dataPickerView.delegate = self
        self.dataPickerView.frame = CGRect(x: 0, y: viewSizePercent.height * 30, width: self.searchCatView.frame.size.width, height: viewSizePercent.height * 30)
        self.dataPickerView.backgroundColor = UIColor.white
        self.dataPickerView.contentMode = .center
        
        
        
        //Add Component
        self.searchCatView.addSubview(self.sortBtn)
        self.searchCatView.addSubview(self.seperatorview1)
        self.searchCatView.addSubview(self.catBtn)
        self.searchCatView.addSubview(self.seperatorview2)
        self.searchCatView.addSubview(self.inSayBtn)
        self.searchCatView.addSubview(self.seperatorview3)
        self.searchCatView.addSubview(self.singerBtn)
        self.searchCatView.addSubview(self.dataPickerView)
        
        //Add View to Main View
        self.view.addSubview(self.searchCatView)

    }
    
    @objc private func textFieldEditingDidBegin()
    {
        self.searchTxt.becomeFirstResponder()
        self.searchTxt.text = ""
    }
    
    
    @objc private func Search()
    {
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return singerMediaItems.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellSize = CGSize(width: Tools.screenWidth, height: Tools.GetScreenHeightPercent() * 25)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Tools.StaticVariables.cellReuseIdendifier, for: indexPath as IndexPath) as! MediaCell
        
        
        print("Cell Height: \(cell.frame.size.height)")
        
        cell.frame.size = cellSize
        
        let p =  URL(string:singerMediaItems[indexPath.row].LargpicUrl)!
        
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
        return pickerItems[row] as String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //pickerView.text = pickerItems[row]
        pickerView.isHidden = true
       
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
