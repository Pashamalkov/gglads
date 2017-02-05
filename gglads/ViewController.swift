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
import BTNavigationDropdownMenu

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    var activityIndicator: UIActivityIndicatorView?
    var activitiView : UIView?
    var refreshControl: UIRefreshControl!
    var menuView : BTNavigationDropdownMenu!
    
    
    var categories = [Category]()
    var posts = [String : [Post]]()
    var currentCat = ""
    var currentIndex: IndexPath?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.menuView = BTNavigationDropdownMenu(title: "Tech", items: ["Tech" as AnyObject])
        self.menuView.cellTextLabelColor = UIColor.white
        self.navigationItem.titleView = self.menuView
        self.menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
            self?.getPosts(self!.categories[indexPath].slug)
        }
        
        self.errorLabel.isHidden = true
        self.activityIndicator?.hidesWhenStopped = true
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(ViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(self.refreshControl)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 90
        
        self.getPosts("tech")
        self.getCategoriesRequest()
        
    }
    
    func refresh(_ sender:AnyObject) {
        // Code to refresh table view
        self.getPostsRequest(self.currentCat)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        for posts in self.posts.values {
            for post in posts {
                post.thumbnail.image = nil
            }
        }
    }
    
    func getCategoriesRequest() {
        
        Alamofire.request("https://api.producthunt.com/v1/categories", headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                print("Get Categories Request Successful")
                
                if let json = response.result.value as? [String : AnyObject] {
                    if let rows = json["categories"] as? [[String : AnyObject]] {
                        
                        var items = [String]()
                        for row in rows {
                            self.categories.append( Category.init(
                                color: row["color"] as! String,
                                id: row["id"] as! Int,
                                item_name: row["item_name"] as! String,
                                name: row["name"] as! String,
                                slug: row["slug"] as! String
                            ))
                            
                            items.append(row["name"] as! String)
                        }
                        
                        self.menuView.updateItems(items as [AnyObject])
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
        
        if self.currentCat == category {
            return
        }
        
        self.currentCat = category
        
        if posts.keys.contains(category) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            getPostsRequest(category)
        }
        
    }
    
    func getPostsRequest(_ category: String) {
        
        if !self.refreshControl.isRefreshing {
            self.startActivitiIndicator()
        }
        Alamofire.request("https://api.producthunt.com/v1/categories/\(category)/posts?days_ago=5", headers: headers).responseJSON { response in
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
                                    thumbnail: Thumbnail.init(id: thumb["id"] as! Int, media_type: thumb["media_type"] as! String, image_url: thumb["image_url"] as! String),
                                    redirect_url: row["redirect_url"] as! String,
                                    screenshot_url: (row["screenshot_url"] as! [String : String])["850px"]!,
                                    screenshot_url_mini: (row["screenshot_url"] as! [String : String])["300px"]!
                            ))
                        }
                        
                        self.posts.updateValue(postsForOneCat, forKey: category)
                        
                        if postsForOneCat.count == 0 {
                            self.errorLabel.text = "There is no posts today..."
                            self.errorLabel.isHidden = false
                        } else {
                            self.errorLabel.isHidden = true
                        }
                        
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
            self.activityIndicator?.stopAnimating()
            self.activitiView?.isHidden = true
            self.refreshControl.endRefreshing()
        }
    }
    
    func startActivitiIndicator() {
        
        
        if activitiView == nil {
            activitiView = UIView.init(frame: CGRect.init(x: self.view.frame.width/2-40, y: self.view.frame.height/2-40, width: 80, height: 80))
            self.activitiView?.backgroundColor = UIColor.hex("0x444444", alpha: 0.6)
            self.activitiView?.clipsToBounds = true
            self.activitiView?.layer.cornerRadius = 10
            
            self.view.addSubview(activitiView!)
        }
        if activityIndicator == nil {
            activityIndicator = UIActivityIndicatorView.init(frame: CGRect.init(x: (self.activitiView?.frame.width)!/2-30, y: (self.activitiView?.frame.height)!/2-30, width: 60, height: 60))
            
            self.activitiView?.addSubview(activityIndicator!)
        }
        
        self.activitiView?.isHidden = false
        self.activityIndicator?.startAnimating()
    }

}


// MARK: - UITableViewDataSource and UITableViewDelegate
extension ViewController: UITableViewDataSource,UITableViewDelegate {
    // table view data source methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.posts[self.currentCat]?.count == nil || self.posts[self.currentCat]?.count == 0 {
            
            self.tableView.isHidden = true
            
            return 0
        }
        
        self.tableView.isHidden = false
        return (self.posts[self.currentCat]?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: TableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let currentPosts = self.posts[self.currentCat]!
        
        cell.name.text = currentPosts[indexPath.row].name
        cell.name.numberOfLines = 0
        cell.name.lineBreakMode = .byWordWrapping
        
        cell.tagline.text = currentPosts[indexPath.row].tagline
        cell.tagline.numberOfLines = 0
        cell.tagline.lineBreakMode = .byWordWrapping
        
        cell.votesCountButton.setTitle("\(currentPosts[indexPath.row].votes_count!)", for: .normal)
        cell.votesCountButton.layer.borderWidth = 1
        cell.votesCountButton.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        cell.votesCountButton.layer.cornerRadius = 3
        
        cell.thumbnail.image = nil
        
        func downloadGif() {
            DispatchQueue.global().async {
                let image = UIImage.gif(url: (currentPosts[indexPath.row].thumbnail.image_url)!)
                DispatchQueue.main.async {
                    
                    if cell.name.text == currentPosts[indexPath.row].name {
                        cell.thumbnail.image = nil
                        cell.thumbnail.image = image
                    }
                }
            }
        }
        
        if currentPosts[indexPath.row].thumbnail.image == nil {
            
            DispatchQueue.global().async {
                
                self.download(url: (currentPosts[indexPath.row].thumbnail.image_url)!, completion: { (image: UIImage?) in
                    
                    if image != nil {
                        currentPosts[indexPath.row].thumbnail.image = image!
                        cell.thumbnail.image = (currentPosts[indexPath.row].thumbnail.image)!
                        downloadGif()
                    }
                })
            }
            
        } else {
            cell.thumbnail.image = (currentPosts[indexPath.row].thumbnail.image)!
            downloadGif()
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.currentIndex = indexPath
        performSegue(withIdentifier: "SegueToInfo", sender: self)
        
    }
    
    func download(url: String, completion: @escaping (_ image: UIImage?) -> Void) {
        
        Alamofire.request(url).responseData { response in
            if let data = response.result.value {
                completion(UIImage(data: data))
            }
        }
        completion(nil)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SegueToInfo" {
            
            if let viewController: InfoViewController = segue.destination as? InfoViewController {
                
                viewController.post = self.posts[self.currentCat]![(self.currentIndex?.row)!]
                
            }
        }
    }
    
}

extension UIColor {
    
    static func hex (_ hexStr : NSString, alpha : CGFloat) -> UIColor {
        
        let realHexStr = hexStr.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: realHexStr as String)
        var color: UInt32 = 0
        if scanner.scanHexInt32(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r,green:g,blue:b,alpha:alpha)
        } else {
            print("invalid hex string", terminator: "")
            return UIColor.white
        }
    }
}


