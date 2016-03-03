//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Lily Tran on 2/20/16.
//  Copyright © 2016 Lily Tran. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ComposeMessageViewControllerDelegate {
    var tweets: [Tweet]!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    
    @IBAction func onLogoutButton(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 133/255, green: 181/255, blue: 232/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        TwitterClient.sharedInstance.homeTimeLine({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: NSError) -> () in
            print(error.localizedDescription)
        })
        
        let user = User._currentUser
        if let user = user {
            backgroundImageView.setImageWithURL(user.backgroundImageURL!)
            profileImage.setImageWithURL(user.profileImageURL!)
            nameLabel.text! = user.name!
            screenNameLabel.text! = "@\(user.screenname!)"
            tweetCountLabel.text! = "\(user.tweetCount)"
            followerCountLabel.text! = "\(user.followerCount)"
            followingCountLabel.text! = "\(user.followingCount)"
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweet = tweets {
            return tweet.count
        }
        else {
            return 0
        }
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetsCell", forIndexPath: indexPath) as! TweetsCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //If action selected by tapping the tableviewcell
        if let cell = sender as? UITableViewCell {
            let indexPath = tableView.indexPathForCell(cell)
            let data = tweets![indexPath!.row]
            
            navigationItem.title = "Home"
            
            let detailViewController = segue.destinationViewController as! DetailTweetViewController
            detailViewController.tweet = data
        }
        if let navController = segue.destinationViewController as? UINavigationController {
            let vc = navController.topViewController as! ComposeMessageViewController
            vc.delegate = self
        }
    }
    
    //compose message view controller delegate filter
    func updateTweet(composeMessageViewController: ComposeMessageViewController, text: String) {
        TwitterClient.sharedInstance.postMessage(text, id: "")
//        let user = User._currentUser
//        if let user = user {
//            tweets = TwitterClient.sharedInstance.userTimeLine(user.screenname!, tweet: tweets)
//            tableView.reloadData()
//        }
        TwitterClient.sharedInstance.homeTimeLine({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            }, failure: { (error: NSError) -> () in
                print(error.localizedDescription)
        })
    }
}
