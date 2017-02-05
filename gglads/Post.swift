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
    var thumbnail: Thumbnail!
    
    var redirect_url: String!
    var screenshot_url: String!
    var screenshot_url_mini: String!
    
    init(id: Int, name: String, tagline: String, votes_count: Int, thumbnail: Thumbnail, redirect_url: String, screenshot_url: String, screenshot_url_mini: String) {
        super.init()
        
        self.id = id
        self.name = name
        self.tagline = tagline
        self.votes_count = votes_count
        self.thumbnail = thumbnail
        
        self.redirect_url = redirect_url
        self.screenshot_url = screenshot_url
        self.screenshot_url_mini = screenshot_url_mini
        
    }
    
}
