//
//  Post.swift
//  gglads
//
//  Created by Паша on 04.02.17.
//  Copyright © 2017 Паша. All rights reserved.
//

import UIKit

class Post: NSObject {

    var id: Int!
    var name: String!
    var tagline: String!
    var votes_count: Int!
    var thumbnail : Thumbnail!
    
    init(id: Int, name: String, tagline: String, votes_count: Int, thumbnail: Thumbnail) {
        super.init()
        
        self.id = id
        self.name = name
        self.tagline = tagline
        self.votes_count = votes_count
        self.thumbnail = thumbnail
        
    }
    
}
