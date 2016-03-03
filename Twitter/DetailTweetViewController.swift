//
//  DetailTweetViewController.swift
//  Twitter
//
//  Created by Lily Tran on 2/25/16.
//  Copyright © 2016 Lily Tran. All rights reserved.
//

import UIKit

class DetailTweetViewController: UIViewController, ReplyViewControllerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    var tweetID = ""
    
    var tweet: Tweet!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Edit navigation bar
        self.title = "Tweet"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 133/255, green: 181/255, blue: 232/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor();
        
        //Set text
        if let tweetText = tweet.text as? String {
            tweetTextLabel.text = tweetText
        }
        
        //Set the time stamp
        timeStampLabel.text = tweet.timestamp!
        
        //Username
        nameLabel.text = tweet.name!
        screenNameLabel.text = "@\(tweet.screenname!)"
        
        //Profile Image
        if let profileImg = tweet.profileImageURL {
            profileImageView.setImageWithURL(profileImg)
        }
        else {
            //Default image if profile image is nil
            profileImageView.image = UIImage(named: "Twitter_logo_blue_48")
        }
        retweetCountLabel.text = "\(tweet.retweetCount)"
        favoriteCountLabel.text = "\(tweet.favoriteCount)"
        
        //Get the tweet id
        tweetID = tweet.tweetID!

        if (tweet.retweeted! == false) {
            if let image = UIImage(named: "retweet-action") {
                retweetButton.setImage(image, forState: .Normal)
            }
        }
        else {
            if let image = UIImage(named: "retweet-action-on") {
                retweetButton.setImage(image, forState: .Normal)
            }
        }
        
        if (tweet.favorited! == false) {
            if let image = UIImage(named: "like-action") {
                favoriteButton.setImage(image, forState: .Normal)
            }
        }
        else {
            if let image = UIImage(named: "like-action-on") {
                favoriteButton.setImage(image, forState: .Normal)
            }
        }

        //Setting max width layout
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        screenNameLabel.preferredMaxLayoutWidth = screenNameLabel.frame.size.width
        tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.frame.size.width
        retweetCountLabel.preferredMaxLayoutWidth = retweetCountLabel.frame.size.width
        favoriteCountLabel.preferredMaxLayoutWidth = favoriteCountLabel.frame.size.width
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func replyButtonTapped(sender: AnyObject) {
    }
    
    @IBAction func retweetButtonTapped(sender: AnyObject) {
        if (tweet.retweeted! == false) {
            TwitterClient.sharedInstance.retweet(tweetID)
            tweet.retweeted! = true
        }
        else {
            TwitterClient.sharedInstance.unretweet(tweetID)
            tweet.retweeted! = false
        }
        updateRetweetButton()
    }
    
    //update retweet button image
    private func updateRetweetButton() {
        if (tweet.retweeted! == false) {
            retweetCountLabel.text = "\(--tweet.retweetCount)"
            if let image = UIImage(named: "retweet-action") {
                retweetButton.setImage(image, forState: .Normal)
            }
        }
        else {
            retweetCountLabel.text = "\(++tweet.retweetCount)"
            if let image = UIImage(named: "retweet-action-on") {
                retweetButton.setImage(image, forState: .Normal)
            }
        }
    }

    @IBAction func favButtonTapped(sender: AnyObject) {
        if (tweet.favorited! == false) {
            //set status to like
            TwitterClient.sharedInstance.favorite(tweetID)
            tweet.favorited! = true
            
        }
        else {
            //set status to dislike
            TwitterClient.sharedInstance.unfavorite(tweetID)
            tweet.favorited! = false
        }
        updateFavoriteButton()
    }
    
    //Update favorite button image
    private func updateFavoriteButton() {
        if (tweet.favorited! == false) {
            favoriteCountLabel.text = "\(--tweet.favoriteCount)"
            if let image = UIImage(named: "like-action") {
                favoriteButton.setImage(image, forState: .Normal)
            }
        }
        else {
            favoriteCountLabel.text = "\(++tweet.favoriteCount)"
            if let image = UIImage(named: "like-action-on") {
                favoriteButton.setImage(image, forState: .Normal)
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let navController = segue.destinationViewController as? UINavigationController {
            let vc = navController.topViewController as! ReplyViewController
            vc.tweet = tweet
            vc.delegate = self
        }
    }
    
    func updateTweet(replyViewController: ReplyViewController, reply: String) {
        TwitterClient.sharedInstance.postMessage(reply, id: tweet.tweetID!)
    }

}
