//
//  CellHeaderView.swift
//  Instagram
//
//  Created by Satoru Sasozaki on 2/4/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

import UIKit

class CellHeaderView : UIView {
    
    var profilePhoto : UIImageView?
    var userName : UILabel?
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        self.backgroundColor = UIColor(white: 1, alpha: 0.9)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureProfile(URL : NSURL) {
        profilePhoto = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profilePhoto!.clipsToBounds = true
        profilePhoto!.layer.cornerRadius = 15;
        profilePhoto!.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
        profilePhoto!.layer.borderWidth = 1;
        profilePhoto?.setImageWithUrl(URL)
        self.addSubview(profilePhoto!)
    }
    
    func configureUserName(name : String) {
        userName = UILabel(frame: CGRect(x: 60, y: 10, width: 335, height: 30))
        userName!.font = UIFont(name: "HelvaticaNeue", size: 17)
        userName?.text = name
        self.addSubview(userName!)
        
    }
    
}
