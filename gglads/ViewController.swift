//
//  ViewController.swift
//  gglads
//
//  Created by Паша on 04.02.17.
//  Copyright © 2017 Паша. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    var categories = [Category]()
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.navigationBar.topItem?.title = "Tech"
        
        getCategoriesRequest()
        getPostsRequest(category: "tech")
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getCategoriesRequest() {
        
        Alamofire.request("https://api.producthunt.com/v1/categories", headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                print("Get Categories Request Successful")
                
                if let json = response.result.value as? [String : AnyObject] {
                    if let rows = json["categories"] as? [[String : AnyObject]] {
                        
                        for row in rows {
                            self.categories.append( Category.init(
                                color: row["color"] as! String,
                                id: row["id"] as! Int,
                                item_name: row["item_name"] as! String,
                                name: row["name"] as! String,
                                slug: row["slug"] as! String
                            ))
                        }
                    }
                } else {
                    print("Error with Json")
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func getPostsRequest(category: String) {
        
        Alamofire.request("https://api.producthunt.com/v1/categories/\(category)/posts", headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                print("Get Posts Request Successful")
                
                if let json = response.result.value as? [String : AnyObject] {
                    if let rows = json["posts"] as? [[String : AnyObject]] {
                        
                        for row in rows {
                            let thumb = (row["thumbnail"] as! [String : AnyObject])
                            self.posts.append( Post.init(
                                id: row["id"] as! Int,
                                name: row["name"] as! String,
                                tagline: row["tagline"] as! String,
                                votes_count: row["votes_count"] as! Int,
                                thumbnail: Thumbnail.init(id: thumb["id"] as! Int, media_type: thumb["media_type"] as! String, image_url: thumb["image_url"] as! String)
                            ))
                        }
                    }
                } else {
                    print("Error with Json")
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    


}


// MARK: - UITableViewDataSource and UITableViewDelegate
extension ViewController: UITableViewDataSource,UITableViewDelegate {
    // table view data source methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


