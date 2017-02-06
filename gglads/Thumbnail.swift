//
//  Thumbnail.swift
//  gglads
//
//  Created by Паша on 04.02.17.
//  Copyright © 2017 Паша. All rights reserved.
//

import UIKit

class Thumbnail: ResponseObjectSerializable {
    
    var id: Int!
    var media_type: String!
    var image_url: String!
    var image : UIImage?
    
//    init(id: Int, media_type: String, image_url: String) {
//        super.init()
//        
//        self.id = id
//        self.media_type = media_type
//        self.image_url = image_url
//        
//    }
    
    required init?(response: HTTPURLResponse, representation: AnyObject) {
        // map the values to the instance
        self.id = representation.value(forKey:"id") as! Int
        self.media_type = representation.value(forKey:"media_type") as! String
        self.image_url = representation.value(forKey:"image_url") as! String
    }

}
