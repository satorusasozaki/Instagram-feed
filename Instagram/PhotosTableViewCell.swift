//
//  PhotosTableViewCell.swift
//  Instagram
//
//  Created by Satoru Sasozaki on 2/2/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

import UIKit

class PhotosTableViewCell: UITableViewCell {
    
    var photoView : UIImageView?
    var photoURL : String?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // How to get tableView.rowHeight to make cell height the same size
        // photoView = UIImageView(frame: CGRectMake(10, 15, self.frame.width, self.frame.height))
        photoView = UIImageView(frame: CGRectMake(0, 0, self.frame.width, 320))
        self.contentView.addSubview(photoView!)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
//    func height() -> CGFloat{
//        return (photoView?.frame.height)!
//    }

    func configureImage(imageURL : NSURL) {
//        photoView?.setImageWithURL(URL : String?)
        photoView?.setImageWithUrl(imageURL)
    
    }

}
