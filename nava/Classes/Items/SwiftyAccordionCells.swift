//
//  SwiftyAccordionCells.swift
//  SwiftyAccordionCells
//
//  Created by Fischer, Justin on 9/24/15.
//  Copyright © 2015 Justin M Fischer. All rights reserved.
//

import Foundation

class SwiftyAccordionCells {
    
    enum MenuAction : Int {
        case LiveMakke
        case LiveMadine
        case LiveNajaf
        case LiveKarbala
        case LiveMashhad
        case QuranTV
        case RadioQuran
        case RadioMaaref
        case RadioTelavat
        case Section1
        case Help
        case AboutUs
        case Review
        case None
    }
    
    fileprivate (set) var items = [Item]()
    
    class Item {
        var isHidden: Bool
        var value: String
        var isChecked: Bool
        var menuAction = MenuAction.None
        
        
        init(_ hidden: Bool = true, value: String, checked: Bool = false, _menuAction: MenuAction) {
            self.isHidden = hidden
            self.value = value
            self.isChecked = checked
            self.menuAction = _menuAction
        }
    }
    
    class HeaderItem: Item {
        init (value: String) {
            super.init(false, value: value, checked: false, _menuAction: .None)
        }
    }
    
    func append(_ item: Item) {
        self.items.append(item)
    }
    
    func removeAll() {
        self.items.removeAll()
    }
    
    func expand(_ headerIndex: Int) {
        self.toogleVisible(headerIndex, isHidden: false)
    }
    
    func collapse(_ headerIndex: Int) {
        self.toogleVisible(headerIndex, isHidden: true)
    }
    
    private func toogleVisible(_ headerIndex: Int, isHidden: Bool) {
        var headerIndex = headerIndex
        headerIndex += 1
        
        while headerIndex < self.items.count && !(self.items[headerIndex] is HeaderItem) {
            self.items[headerIndex].isHidden = isHidden
            
            headerIndex += 1
        }
    }
}
