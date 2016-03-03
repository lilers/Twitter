//
//  Tweetsswift
//  Twitter
//
//  Created by Lily Tran on 2/21/16.
//  Copyright © 2016 Lily Tran. All rights reserved.
//

import UIKit

class TweetsCell: UITableViewCell {

    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoritedCountLabel: UILabel!
    var tweetID = ""
    
    var tweet: Tweet! {
        didSet {
            //Set the tweet text
            if let tweetText = tweet.text as? String {
                tweetLabel.text = tweetText
            }
            
            //Set the time stamp
            timeStampLabel.text = tweet.hour!
            
            //Username
            userName.text = tweet.name!
            
            //Profile Image
            if let profileImg = tweet.profileImageURL {
                profileImage.setImageWithURL(profileImg)
            }
            else {
                //Default image if profile image is nil
                profileImage.image = UIImage(named: "Twitter_logo_blue_48")
            }
            
            //Get the tweet id
            tweetID = tweet.tweetID!

            if (tweet.retweeted! == false) {
                retweetCountLabel.textColor = UIColor.grayColor()
                if let image = UIImage(named: "retweet-action") {
                    retweetButton.setImage(image, forState: .Normal)
                }
            }
            else {
                retweetCountLabel.textColor = UIColor.greenColor()
                if let image = UIImage(named: "retweet-action-on") {
                    retweetButton.setImage(image, forState: .Normal)
                }
            }
            
            if (tweet.favorited! == false) {
                favoritedCountLabel.textColor = UIColor.grayColor()
                if let image = UIImage(named: "like-action") {
                    favoriteButton.setImage(image, forState: .Normal)
                }
            }
            else {
                favoritedCountLabel.textColor = UIColor.redColor()
                if let image = UIImage(named: "like-action-on") {
                    favoriteButton.setImage(image, forState: .Normal)
                }
            }
            
            retweetCountLabel.text = "\(tweet.retweetCount)"
            favoritedCountLabel.text = "\(tweet.favoriteCount)"
        }
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
            retweetCountLabel.textColor = UIColor.grayColor()
            if let image = UIImage(named: "retweet-action") {
                retweetButton.setImage(image, forState: .Normal)
            }
        }
        else {
            retweetCountLabel.text = "\(++tweet.retweetCount)"
            retweetCountLabel.textColor = UIColor.greenColor()
            if let image = UIImage(named: "retweet-action-on") {
                retweetButton.setImage(image, forState: .Normal)
            }
        }
    }
    
    @IBAction func favoriteButtonTapped(sender: AnyObject) {
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
            favoritedCountLabel.text = "\(--tweet.favoriteCount)"
            favoritedCountLabel.textColor = UIColor.grayColor()
            if let image = UIImage(named: "like-action") {
                favoriteButton.setImage(image, forState: .Normal)
            }
        }
        else {
            favoritedCountLabel.text = "\(++tweet.favoriteCount)"
            favoritedCountLabel.textColor = UIColor.redColor()
            if let image = UIImage(named: "like-action-on") {
                favoriteButton.setImage(image, forState: .Normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImage.layer.cornerRadius = 3
        profileImage.clipsToBounds = true
        
        tweetLabel.preferredMaxLayoutWidth = tweetLabel.frame.size.width
        favoritedCountLabel.preferredMaxLayoutWidth = favoritedCountLabel.frame.size.width
        retweetCountLabel.preferredMaxLayoutWidth = retweetCountLabel.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tweetLabel.preferredMaxLayoutWidth = tweetLabel.frame.size.width
        favoritedCountLabel.preferredMaxLayoutWidth = favoritedCountLabel.frame.size.width
        retweetCountLabel.preferredMaxLayoutWidth = retweetCountLabel.frame.size.width
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
