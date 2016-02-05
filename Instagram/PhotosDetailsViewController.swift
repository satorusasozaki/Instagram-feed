//
//  PhotoDetailsViewController.swift
//  Instagram
//
//  Created by Satoru Sasozaki on 2/3/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

import UIKit

class PhotosDetailsViewController : UIViewController, UIScrollViewDelegate {
    
    var imageURL : NSURL?
    var photoView : UIImageView?
    var scrollViewForZoom : UIScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set title
        self.navigationItem.title = "Details"
        self.view.backgroundColor = UIColor.whiteColor()
        
        // set UIScrollView for zooming
        scrollViewForZoom = UIScrollView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        self.scrollViewForZoom?.minimumZoomScale = 1.0
        self.scrollViewForZoom?.maximumZoomScale = 6.0
        scrollViewForZoom?.delegate = self
        self.view.addSubview(scrollViewForZoom!)

        // Configure image
        // Height and width are set to 375, because I'm testing on iPhone 6
        photoView = UIImageView(frame: CGRectMake(0, 75, 375, 375))
        photoView!.setImageWithUrl(imageURL!)
        self.scrollViewForZoom!.addSubview(photoView!)
    }
    
    // enable zooming
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.photoView
    }
}
