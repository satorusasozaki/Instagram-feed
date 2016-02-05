//
//  PhotosTableViewCell.swift
//  Instagram
//
//  Created by Satoru Sasozaki on 2/2/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

import UIKit

class PhotosTableViewCell: UITableViewCell {
    
    var photoView : PhotoView?
    var imageURL : NSURL?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Add photoView to this Cell class
        // Height and width are set to 375, because I'm testing on iPhone 6
        photoView = PhotoView(frame: CGRectMake(0, 0, 375, 375))
        self.contentView.addSubview(photoView!)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    // Add function to make it easier to set image from URL
    func configureImage(imageURL : NSURL) {
        self.imageURL = imageURL
        photoView?.setImageWithUrl(imageURL)    
    }
}
