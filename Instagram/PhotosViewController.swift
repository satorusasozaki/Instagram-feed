//
//  ViewController.swift
//  Instagram
//
//  Created by Satoru Sasozaki on 2/2/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UITableViewDataSource {
    
    var jasonDic: NSDictionary?
    var datas: NSArray?
    var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        self.datas = NSArray()
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            //NSLog("response: \(responseDictionary)")
//                            self.jasonDic = responseDictionary as! NSDictionary
//                            self.datas = NSArray(objects: [responseDictionary["data"]!])
                            self.datas = responseDictionary["data"]! as? NSArray
                            NSLog("datas: \(self.jasonDic)")
                            NSLog("responseDictionary: \(responseDictionary["data"]!)")
                            self.tableView?.reloadData()
                    }
                }
        });
        task.resume()
        NSLog("datas outside of completionHandler:  \(self.datas)")
      //  self.datas = NSArray(objects: self.jasonDic["data"]!)
  //      NSLog("jasonDic: \(self.jasonDic!)")
//        dispatch_async(dispatch_get_main_queue(), {
//            //reload table view
//            self.tableView!.reloadData()
//        })

        tableView = UITableView(frame: CGRect(x: 0, y: 0, width:UIScreen.mainScreen().bounds.width , height: UIScreen.mainScreen().bounds.height), style: UITableViewStyle.Plain)
        tableView!.rowHeight = 320
        tableView!.registerClass(PhotosTableViewCell.self, forCellReuseIdentifier: "dataCell")
        tableView!.dataSource = self
        tableView!.allowsSelection = false
        self.view.addSubview(tableView!)
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (datas?.count)!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dataCell = tableView.dequeueReusableCellWithIdentifier("dataCell", forIndexPath: indexPath) as! PhotosTableViewCell
//        let testImage: UIImage = UIImage(named: "/Users/satoru/Dropbox/IMAGES/IMG_5009_Fotor.png")!
//        dataCell.imageView!.image = testImage
//        UIImageView(image: testImage)
//        dataCell.photoView?.image = testImage
        
        // get image URL from datas array
        var dataDic = datas![indexPath.row]
        var imageDic = dataDic["images"]
        var standardResolutionDic = imageDic!!["standard_resolution"]
        var urlString = standardResolutionDic!!["url"] as! String
        var imageUrl : NSURL = NSURL(string: urlString)!

      //  var urlString = self.datas![indexPath.row]["image"]["standard_resolution"]["url"] as! String
        
        
        dataCell.configureImage(imageUrl)
        return dataCell
        
    }


}

