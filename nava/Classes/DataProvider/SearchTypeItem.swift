//
//  SearchTypeItem.swift
//  nava
//
//  Created by Mohammad Lashgarbolouk on 11/9/16.
//  Copyright © 2016 manshor. All rights reserved.
//

import UIKit

class SearchTypeItem: NSObject
{
    
    private var typeID : String!
    private var typeName : String!
    
    public var TypeID : String
        {
        get
        {
            return self.typeID
        }
        set(newValue)
        {
            self.typeID = newValue
        }
    }
    
    public var TypeName : String
        {
        get
        {
            return self.typeName
        }
        set(newValue)
        {
            self.typeName = newValue
        }
    }
}
