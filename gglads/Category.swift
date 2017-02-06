//
//  Category.swift
//  gglads
//
//  Created by Паша on 04.02.17.
//  Copyright © 2017 Паша. All rights reserved.
//

import UIKit

final class Categories: ResponseObjectSerializable {
    
    var cats = [Category]()
    
    required init?(response: HTTPURLResponse, representation: AnyObject) {
        self.cats = Category.collection(response:response, representation: representation.value(forKey: "categories")! as AnyObject)
    }
}

final class Category: ResponseObjectSerializable {
    
    var color: String!
    var id: Int!
    var item_name: String!
    var name: String!
    var slug: String!

    required init?(response: HTTPURLResponse, representation: AnyObject) {
        self.color = representation.value(forKey:"color") as! String
        self.id = representation.value(forKey:"id") as! Int
        self.item_name = representation.value(forKey:"item_name") as! String
        self.name = representation.value(forKey:"name") as! String
        self.slug = representation.value(forKey:"slug") as! String
    }
    
    public static func collection(response: HTTPURLResponse, representation: AnyObject) -> [Category] {
        let catsArray = representation as! [AnyObject]
        // using the map function we are able to instantiate Post while reusing our init? method above
        return catsArray.map({ Category(response:response, representation: $0 as AnyObject)! })
    }
}
