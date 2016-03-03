//
//  ReplyViewController.swift
//  Twitter
//
//  Created by Lily Tran on 2/28/16.
//  Copyright © 2016 Lily Tran. All rights reserved.
//

import UIKit

protocol ReplyViewControllerDelegate: class {
    func updateTweet(replyViewController: ReplyViewController, reply: String)
}

class ReplyViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var replyTextView: UITextView!
    @IBOutlet weak var countLabel: UILabel!
    var stringLength: Int = 0
    var tweet: Tweet!
    weak var delegate: ReplyViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = tweet.screenname!
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 133/255, green: 181/255, blue: 232/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor();
        
        //Set text
        if let tweetText = tweet.text as? String {
            tweetTextLabel.text = tweetText
        }
        
        //Username and screenname
        nameLabel.text = tweet.name!
        screenNameLabel.text = "@\(tweet.screenname!)"
        
        //Profile Image
        if let profileImg = tweet.profileImageURL {
            profileImageView.setImageWithURL(profileImg)
        }
        
        replyTextView.text = "@\(tweet.screenname!) "
        stringLength = replyTextView.text.characters.count
        countLabel.text = "\(140 - stringLength)"
        replyTextView.becomeFirstResponder()
        
        //Setting max width layout
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        screenNameLabel.preferredMaxLayoutWidth = screenNameLabel.frame.size.width
        tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.frame.size.width
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tweetButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        let tweet = replyTextView.text
        let encodedString = tweet.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        delegate?.updateTweet(self, reply: encodedString!)
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Set text limit to 140 and update count label
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let newLength = textView.text.characters.count + text.characters.count - range.length
        if(newLength <= 140){
            countLabel.text = "\(140 - newLength)"
            return true
        }else{
            return false
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
