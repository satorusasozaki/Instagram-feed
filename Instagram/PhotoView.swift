//
//  PhotoView.swift
//  Instagram
//
//  Created by Satoru Sasozaki on 2/4/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

import UIKit

class PhotoView : UIImageView {
    override init(frame: CGRect) {
        super.init(frame : frame)
        self.userInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
