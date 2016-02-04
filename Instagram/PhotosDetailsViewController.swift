//
//  PhotoDetailsViewController.swift
//  Instagram
//
//  Created by Satoru Sasozaki on 2/3/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

import UIKit

class PhotosDetailsViewController : UIViewController {
    
    var imageURL : NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set title
        self.navigationItem.title = "Details"
        
        // Configure image
        // Height and width are set to 375, because I'm testing on iPhone 6
        let photoView = UIImageView(frame: CGRectMake(0, 64, 375, 375))
        photoView.userInteractionEnabled = true
        photoView.setImageWithUrl(imageURL!)
        self.view.addSubview(photoView)
        
    }
}
