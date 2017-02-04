//
//  Category.swift
//  gglads
//
//  Created by Паша on 04.02.17.
//  Copyright © 2017 Паша. All rights reserved.
//

import UIKit

class Category: NSObject {
    
    var color: String!
    var id: Int!
    var item_name: String!
    var name: String!
    var slug: String!
    
    init(color: String, id: Int, item_name: String, name: String, slug: String) {
        super.init()
        
        self.color = color
        self.id = id
        self.item_name = item_name
        self.name = name
        self.slug = slug
        
    }

}
