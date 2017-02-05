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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func downloadImage() {
        self.download(url: self.post.screenshot_url_mini, completion: { (image: UIImage?) in
            
            if image != nil {
                self.imageView.image = image!
            }
            
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


