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
    var refreshControl: UIRefreshControl?
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
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView!.insertSubview(refreshControl!, atIndex: 0)
        
        // Initialize data array for the later use
        data = NSMutableArray()
        
        // callAPI for the first time
        callAPI(1)
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
        let name = userDic!!["username"] as! String
        headerView.configureUserName(name)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    // MARK: refresh control
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        callAPI(2)
    }
    
    // MARK: infinite scroll
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView!.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - (tableView!.bounds.size.height) * 2
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView!.dragging) {
                isMoreDataLoading = true
                //loadMoreData()
                callAPI(3)
            }
        }
    }
    
    // MARK: API call
    
    func callAPI (whichCall : Int) {
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
                            
                            // What to do inside here depends on when this function is called
                            switch whichCall {
                            // the very first call when viewDidLoad
                            case 1:
                                // array made from jason data is immutable by default even if you assign
                                // the jason data to mutable array
                                let bufferArray = responseDictionary["data"]!
                                self.data = NSMutableArray(array: bufferArray as! [AnyObject])
                                // this works too ---> self.data = bufferArray.mutableCopy() as! NSMutableArray
                                
                                
                            // the call when refresh control is toggled
                            case 2:
                                let bufferArray = responseDictionary["data"]!
                                self.data = NSMutableArray(array: bufferArray as! [AnyObject])
                                self.refreshControl!.endRefreshing()
                                
                            // the call when need to load more data (infinite scroll)
                            case 3:
                                var bufferArray : NSMutableArray = NSMutableArray()
                                bufferArray = (responseDictionary["data"]! as? NSMutableArray)!
                                self.data?.addObjectsFromArray(bufferArray as [AnyObject])
                                self.isMoreDataLoading = false
                                
                            default:
                                let bufferArray = responseDictionary["data"]!
                                self.data = NSMutableArray(array: bufferArray as! [AnyObject])
                            }
                            self.tableView?.reloadData()
                    }
                }
        });
        task.resume()
    }
}




