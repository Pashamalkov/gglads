//
//  Post.swift
//  gglads
//
//  Created by Паша on 04.02.17.
//  Copyright © 2017 Паша. All rights reserved.
//

import UIKit

final class Posts: ResponseObjectSerializable {
    
    var posts = [Post]()
    
    required init?(response: HTTPURLResponse, representation: AnyObject) {
        self.posts = Post.collection(response:response, representation: representation.value(forKey: "posts")! as AnyObject)
        
    }
    
}

final class Post: ResponseObjectSerializable, ResponseCollectionSerializable  {
    


    var id: Int!
    var name: String!
    var tagline: String!
    var votes_count: Int!
    var thumbnail: Thumbnail!
    
    var redirect_url: String!
    var screenshot_url: String!
    var screenshot_url_mini: String!
    
//    init(id: Int, name: String, tagline: String, votes_count: Int, thumbnail: Thumbnail, redirect_url: String, screenshot_url: String, screenshot_url_mini: String) {
//        super.init()
//        
//        self.id = id
//        self.name = name
//        self.tagline = tagline
//        self.votes_count = votes_count
//        self.thumbnail = thumbnail
//        
//        self.redirect_url = redirect_url
//        self.screenshot_url = screenshot_url
//        self.screenshot_url_mini = screenshot_url_mini
//        
//    }
    
    required init?(response: HTTPURLResponse, representation: AnyObject) {
        self.id = representation.value(forKey:"id") as! Int
        self.name = representation.value(forKey:"name") as! String
        self.tagline = representation.value(forKey:"tagline") as! String
        self.votes_count = representation.value(forKey:"votes_count") as! Int
        self.thumbnail = Thumbnail(response:response, representation: representation.value(forKey: "thumbnail")! as AnyObject)!
        
        self.redirect_url = representation.value(forKey:"redirect_url") as! String
        self.screenshot_url = (representation.value(forKey:"screenshot_url") as! [String : String])["850px"]!
        self.screenshot_url_mini = (representation.value(forKey:"screenshot_url") as! [String : String])["300px"]!
        
//            screenshot_url: (row["screenshot_url"] ,
        //                                    screenshot_url_mini: (row["screenshot_url"] as! [String : String])["300px"]!
    }
    
    public static func collection(response: HTTPURLResponse, representation: AnyObject) -> [Post] {
        let postArray = representation as! [AnyObject]
        // using the map function we are able to instantiate Post while reusing our init? method above
        return postArray.map({ Post(response:response, representation: $0 as AnyObject)! })
    }
    
    
}
