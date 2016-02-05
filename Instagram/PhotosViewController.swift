//
//  ViewController.swift
//  Instagram
//
//  Created by Satoru Sasozaki on 2/2/16.
//  Copyright © 2016 Satoru Sasozaki. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    var data: NSMutableArray?  // jason data will be stored here
    var tableView: UITableView?
    var imageURL: NSURL? // set image with this URL to tableViewCell and detailView
    
    var isMoreDataLoading = false   // check if need to load data (call API)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set title
        self.navigationItem.title = "Instagram"
        
        // Create tableView with the size of screen
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width:UIScreen.mainScreen().bounds.width , height: UIScreen.mainScreen().bounds.height), style: UITableViewStyle.Plain)
        // Height is set to 375 because I'm testing on iPhone 6
        tableView!.rowHeight = 375
        tableView!.registerClass(PhotosTableViewCell.self, forCellReuseIdentifier: "dataCell")
        tableView!.dataSource = self
        tableView!.delegate = self
        self.view.addSubview(tableView!)
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView!.insertSubview(refreshControl, atIndex: 0)
        
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
        data = NSMutableArray()
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            
                            // Assign the results from the API Call to data array
                            self.data = responseDictionary["data"]! as? NSMutableArray
                            
                            // After this block function is finished (API call is finished and the jason data is stored into data array,
                            // Refresh the tableView so that the content will be displayed
                            self.tableView?.reloadData()
                    }
                }
        });
        task.resume()
    }

    // MARK: tableView dataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If data is empty, then nothing will show except tableView row line.
        // If data is filled with jason data
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (data?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dataCell = tableView.dequeueReusableCellWithIdentifier("dataCell", forIndexPath: indexPath) as! PhotosTableViewCell
        
        // get image URL from datas array
        let dataDic = data![indexPath.section]
        let imageDic = dataDic["images"]
        let standardResolutionDic = imageDic!!["standard_resolution"]
        let urlString = standardResolutionDic!!["url"] as! String
        imageURL = NSURL(string: urlString)!

        // set the image by using the image URL to photoView
        dataCell.configureImage(imageURL!)
        return dataCell
    }
    
    // MARK: tableView delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let photosDetailsViewController = PhotosDetailsViewController()
        // get selected cell from tableView to get the right image url
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as! PhotosTableViewCell
        photosDetailsViewController.imageURL = selectedCell.imageURL
        self.navigationController?.pushViewController(photosDetailsViewController, animated: true)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = CellHeaderView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        
        // get user info URL
        let dataDic = data![section]
        let userDic = dataDic["user"]
        let urlString = userDic!!["profile_picture"] as! String
        let profilePicURL = NSURL(string: urlString)!
        
        // set image to profileView
        headerView.configureProfile(profilePicURL)
        var name = userDic!!["username"] as! String
        headerView.configureUserName(name)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    // MARK: refresh control
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        // API Call
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            
                            // Assign the results from the API Call to data array
                            
                            var mustBeMutable : NSMutableArray = responseDictionary["data"]! as! NSMutableArray
                            self.data = responseDictionary["data"]! as? NSMutableArray
                            
                            // After this block function is finished (API call is finished and the jason data is stored into data array,
                            // Refresh the tableView so that the content will be displayed
                            self.tableView?.reloadData()
                            refreshControl.endRefreshing()
                    }
                }
        });
        task.resume()
    }
    
    // MARK: infinite scroll
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView!.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView!.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView!.dragging) {
                isMoreDataLoading = true
                loadMoreData()
            }
        }
    }
    
    // MARK: Load data
    func loadMoreData() {
        // API Call
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
//                            
//                            var bufferArray : NSMutableArray = NSMutableArray()
//                            bufferArray = (responseDictionary["data"]! as? NSMutableArray)!
////                            
////                            
////        //                    self.data += [bufferArray]
////                            self.data?.addObjectsFromArray([bufferArray])
//
//                            self.data?.addObjectsFromArray(bufferArray as [AnyObject])
//                            NSLog("self.date[0] \(self.data![0])")
//
//                            
                            self.isMoreDataLoading = false

                            self.tableView?.reloadData()
                    }
                }
        });
        task.resume()
    }
}




