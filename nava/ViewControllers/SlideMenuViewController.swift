//
//  SlideMenuViewController.swift
//  nava
//
//  Created by Mohammad Lashgarbolouk on 10/24/16.
//  Copyright © 2016 manshor. All rights reserved.
//

import UIKit

class SlideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var imgHeaderImage: UIImageView!
    @IBOutlet weak var tblMenu: UITableView!

    var previouslySelectedHeaderIndex: Int?
    var selectedHeaderIndex: Int?
    var selectedItemIndex: Int?
    
    var cells: SwiftyAccordionCells!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cells = SwiftyAccordionCells()
        self.setup()
        self.tblMenu.estimatedRowHeight = 45
        self.tblMenu.rowHeight = UITableViewAutomaticDimension
        self.tblMenu.allowsMultipleSelection = true
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tblMenu.reloadData()
    }
    
    func setup() {
        self.tblMenu.layer.cornerRadius = 4
        
        self.cells.append(SwiftyAccordionCells.HeaderItem(value: "اماکن متبرکه و زیارتی"))
        self.cells.append(SwiftyAccordionCells.Item(value: "مکه مکرمه", _menuAction: .LiveMakke))
        self.cells.append(SwiftyAccordionCells.Item(value: "مدینه منوره", _menuAction: .LiveMadine))
        self.cells.append(SwiftyAccordionCells.Item(value: "نجف اشرف", _menuAction: .LiveNajaf))
        self.cells.append(SwiftyAccordionCells.Item(value: "کربلا معلا", _menuAction: .LiveKarbala))
        self.cells.append(SwiftyAccordionCells.Item(value: "مشهد مقدس", _menuAction: .LiveMashhad))

        self.cells.append(SwiftyAccordionCells.HeaderItem(value: "پخش زنده تلویزیون"))
        self.cells.append(SwiftyAccordionCells.Item(value: "شبکه قرآن و معارف", _menuAction: .QuranTV))

        self.cells.append(SwiftyAccordionCells.HeaderItem(value: "رادیو"))
        self.cells.append(SwiftyAccordionCells.Item(value: "رادیو قرآن", _menuAction: .RadioQuran))
        self.cells.append(SwiftyAccordionCells.Item(value: "رادیو معارف", _menuAction: .RadioMaaref))
        self.cells.append(SwiftyAccordionCells.Item(value: "رادیو تلاوت", _menuAction: .RadioTelavat))
        
        self.cells.append(SwiftyAccordionCells.HeaderItem(value: "سایر بخش ها"))
        self.cells.append(SwiftyAccordionCells.Item(value: "بخش ۱", _menuAction: .Section1))
        self.cells.append(SwiftyAccordionCells.Item(value: "راهنما", _menuAction: .Help))
        self.cells.append(SwiftyAccordionCells.Item(value: "درباره ما", _menuAction: .AboutUs))
        self.cells.append(SwiftyAccordionCells.Item(value: "بازخورد", _menuAction: .Review))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cells.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.cells.items[(indexPath as NSIndexPath).row]
        let value = item.value
        let isChecked = item.isChecked as Bool
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell.textLabel?.text = value
            
            if item as? SwiftyAccordionCells.HeaderItem != nil {
                cell.backgroundColor = UIColor.lightGray
                cell.accessoryType = .none
            } else {
                
                if isChecked {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.cells.items[(indexPath as NSIndexPath).row]
        
        if item is SwiftyAccordionCells.HeaderItem {
            return 60
        } else if (item.isHidden) {
            return 0
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.cells.items[(indexPath as NSIndexPath).row]
        
        if item is SwiftyAccordionCells.HeaderItem {
            if self.selectedHeaderIndex == nil {
                self.selectedHeaderIndex = (indexPath as NSIndexPath).row
            } else {
                self.previouslySelectedHeaderIndex = self.selectedHeaderIndex
                self.selectedHeaderIndex = (indexPath as NSIndexPath).row
            }
            
            if let previouslySelectedHeaderIndex = self.previouslySelectedHeaderIndex {
                self.cells.collapse(previouslySelectedHeaderIndex)
            }
            
            if self.previouslySelectedHeaderIndex != self.selectedHeaderIndex {
                self.cells.expand(self.selectedHeaderIndex!)
            } else {
                self.selectedHeaderIndex = nil
                self.previouslySelectedHeaderIndex = nil
            }
            
            self.tblMenu.beginUpdates()
            self.tblMenu.endUpdates()
            
        } else {
            if (indexPath as NSIndexPath).row != self.selectedItemIndex {
                let cell = self.tblMenu.cellForRow(at: indexPath)
                cell?.accessoryType = UITableViewCellAccessoryType.checkmark
                
                if let selectedItemIndex = self.selectedItemIndex {
                    let previousCell = self.tblMenu.cellForRow(at: IndexPath(row: selectedItemIndex, section: 0))
                    previousCell?.accessoryType = UITableViewCellAccessoryType.none
                    cells.items[selectedItemIndex].isChecked = false
                }
                
                self.selectedItemIndex = (indexPath as NSIndexPath).row
                cells.items[self.selectedItemIndex!].isChecked = true
            }
        }
    }
    
    
    private func MenuActionDo(menuAction :SwiftyAccordionCells.MenuAction)
    {
        _ = UIStoryboard(name: "Main", bundle: nil)
        
        switch menuAction {
        case .LiveMakke:
            break
        case .LiveMadine:
            break
        case .LiveNajaf:
            break
        case .LiveKarbala:
            break
        case .LiveMashhad:
            break
        case .QuranTV:
            break
        case .RadioQuran:
            break
        case .RadioMaaref:
            break
        case .RadioTelavat:
            break
        case .Section1:
            break
        case .Help:
            break
        case .AboutUs:
            break
        case .Review:
            break
        case .None:
            break
        
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
