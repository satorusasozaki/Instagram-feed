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
    var data: NSArray?
    var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // API Call
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        // Initialize data array for the later use
        self.data = NSArray()
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            
                            // Assign the results from the API Call to data array
                            self.data = responseDictionary["data"]! as? NSArray
                            
                            // After this block function is finished (API call is finished and the jason data is stored into data array,
                            // Refresh the tableView so that the content will be displayed
                            self.tableView?.reloadData()
                    }
                }
        });
        task.resume()

        // Create tableView with the size of screen
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width:UIScreen.mainScreen().bounds.width , height: UIScreen.mainScreen().bounds.height), style: UITableViewStyle.Plain)
        tableView!.rowHeight = 320
        tableView!.registerClass(PhotosTableViewCell.self, forCellReuseIdentifier: "dataCell")
        tableView!.dataSource = self
        self.view.addSubview(tableView!)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If data is empty, then nothing will show except tableView row line.
        // If data is filled with jason data
        return (data?.count)!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dataCell = tableView.dequeueReusableCellWithIdentifier("dataCell", forIndexPath: indexPath) as! PhotosTableViewCell
        
        // get image URL from datas array
        let dataDic = data![indexPath.row]
        let imageDic = dataDic["images"]
        let standardResolutionDic = imageDic!!["standard_resolution"]
        let urlString = standardResolutionDic!!["url"] as! String
        let imageUrl : NSURL = NSURL(string: urlString)!

        // set the image by using the image URL to photoView
        dataCell.configureImage(imageUrl)
        return dataCell
        
    }


}

