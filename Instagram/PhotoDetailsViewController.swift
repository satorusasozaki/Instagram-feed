//
//  PhotoDetailsViewController.swift
//  Instagram
//
//  Created by Satoru Sasozaki on 2/3/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

import UIKit

class PhotoDetailsViewController : UIViewController {
    
    var imageURL : NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure image
        let photoView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, 320))
        photoView.userInteractionEnabled = true
        photoView.setImageWithUrl(imageURL!)
        self.view.addSubview(photoView)
        
    }
}
