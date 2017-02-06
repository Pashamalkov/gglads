//
//  InfoViewController.swift
//  gglads
//
//  Created by Паша on 05.02.17.
//  Copyright © 2017 Паша. All rights reserved.
//

import UIKit
import Alamofire

class InfoViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var tagline: UILabel!
    @IBOutlet weak var votesCountButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var getItButton: UIButton!
    
    var post: Post!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.tintColor = UIColor.white

        self.downloadImage()
        
        self.name.text = self.post.name
        self.name.numberOfLines = 0
        self.name.lineBreakMode = .byWordWrapping
        
        self.tagline.text = self.post.tagline
        self.tagline.numberOfLines = 0
        self.tagline.lineBreakMode = .byWordWrapping
        
        self.votesCountButton.setTitle("\(self.post.votes_count!)", for: .normal)
        self.votesCountButton.layer.borderWidth = 1
        self.votesCountButton.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        self.votesCountButton.layer.cornerRadius = 3
        
        self.getItButton.layer.cornerRadius = self.votesCountButton.layer.cornerRadius
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.scrollView.contentSize = CGSize.init(width: self.view.frame.width, height: self.view.frame.height - (navigationController?.navigationBar.frame.width)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getItButtonAction(_ sender: Any) {
        openLink(link: post.redirect_url)
    }
    
    func openLink(link: String) {
        if let url = NSURL(string: link){
            if #available(iOS 10.0, *) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(URL(string: link)!)
            }
        }
    }
    
    func downloadImage() {
        //download small image
        self.download(url: self.post.screenshot_url_mini, completion: { (image: UIImage?) in
            
            if image != nil {
                self.imageView.image = image!
            }
            //download big image
            self.download(url: self.post.screenshot_url, completion: { (image: UIImage?) in
                
                if image != nil {
                    self.imageView.image = image!
                }
            })
        })
    }
    
    func download(url: String, completion: @escaping (_ image: UIImage?) -> Void) {
        Alamofire.request(url).responseData { response in
            if let data = response.result.value {
                completion(UIImage(data: data))
            }
        }
        completion(nil)
    }
}
