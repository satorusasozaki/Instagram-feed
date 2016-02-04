//
//  PhotosTableViewCell.swift
//  Instagram
//
//  Created by Satoru Sasozaki on 2/2/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

import UIKit

//protocol PhotosTableViewCellDelegate {
//    func cellButtonTapped(cell: PhotosTableViewCell)
//}

class PhotosTableViewCell: UITableViewCell {
    
    var photoView : UIImageView?
    var imageURL : NSURL?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Add photoView to this Cell class
        photoView = UIImageView(frame: CGRectMake(0, 0, self.frame.width, 320))
        photoView?.userInteractionEnabled = true
        self.contentView.addSubview(photoView!)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // Add function to make it easier to set image from URL
    func configureImage(imageURL : NSURL) {
        self.imageURL = imageURL
        photoView?.setImageWithUrl(imageURL)    
    }
}
