//
//  ViewController.swift
//  gglads
//
//  Created by Паша on 04.02.17.
//  Copyright © 2017 Паша. All rights reserved.
//

import UIKit
import Alamofire
import SwiftGifOrigin

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var categories = [Category]()
    var posts = [String : [Post]]()
    var currentCat = "tech"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.navigationBar.topItem?.title = "Tech"
        
        getCategoriesRequest()
        getPosts(currentCat)
        
        
        
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
    
    func getPosts(_ category: String) {
        
        if posts.keys.contains(category) {
            
            self.currentCat = category
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        } else {
            getPostsRequest(category)
        }
        
    }
    
    func getPostsRequest(_ category: String) {
        
        Alamofire.request("https://api.producthunt.com/v1/categories/\(category)/posts", headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                print("Get Posts Request Successful")
                
                if let json = response.result.value as? [String : AnyObject] {
                    if let rows = json["posts"] as? [[String : AnyObject]] {
                        
                        var postsForOneCat = [Post]()
                        
                        for row in rows {
                            let thumb = (row["thumbnail"] as! [String : AnyObject])
                            
                            postsForOneCat.append(
                                Post.init(
                                    id: row["id"] as! Int,
                                    name: row["name"] as! String,
                                    tagline: row["tagline"] as! String,
                                    votes_count: row["votes_count"] as! Int,
                                    thumbnail: Thumbnail.init(id: thumb["id"] as! Int, media_type: thumb["media_type"] as! String, image_url: thumb["image_url"] as! String)
                            ))
                        }
                        
                        self.posts.updateValue(postsForOneCat, forKey: category)
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
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
        return self.posts[self.currentCat]?.count == nil ? 0 : (self.posts[self.currentCat]?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: TableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let currentPosts = self.posts[self.currentCat]!
        
        cell.name.text = currentPosts[indexPath.item].name
        cell.tagline.text = currentPosts[indexPath.item].tagline
        cell.tagline.numberOfLines = 0
        cell.tagline.lineBreakMode = .byWordWrapping
        cell.votesCountButton.setTitle("\(currentPosts[indexPath.item].votes_count!)", for: .normal)
        
        if currentPosts[indexPath.item].thumbnail.image == nil {
            
            DispatchQueue.global().async {
                currentPosts[indexPath.item].thumbnail.image = UIImage.gif(url: (currentPosts[indexPath.item].thumbnail.image_url)!)
                DispatchQueue.main.async {
                    cell.thumbnail.image = (currentPosts[indexPath.item].thumbnail.image)!
                }
            }
            
        } else {
            cell.thumbnail.image = nil
            cell.thumbnail.image = (currentPosts[indexPath.item].thumbnail.image)!
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}


