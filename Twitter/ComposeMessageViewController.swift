//
//  ComposeMessageViewController.swift
//  Twitter
//
//  Created by Lily Tran on 2/27/16.
//  Copyright © 2016 Lily Tran. All rights reserved.
//

import UIKit

protocol ComposeMessageViewControllerDelegate: class {
    func updateTweet(composeMessageViewController: ComposeMessageViewController, text: String)
}

class ComposeMessageViewController: UIViewController, UITextViewDelegate {
    weak var delegate: ComposeMessageViewControllerDelegate?

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    var countLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextView.delegate = self
        
        if let navigationBar = self.navigationController?.navigationBar {
            let countFrame = CGRect(x: navigationBar.frame.width/1.5, y: 0, width: navigationBar.frame.width/2, height: navigationBar.frame.height)
            
            countLabel = UILabel(frame: countFrame)
            countLabel.text = "140"
            
            
            navigationBar.addSubview(countLabel)
        }

        let user = User._currentUser
        if let user = user {
            profileImage.setImageWithURL(user.profileImageURL!)
            nameLabel.text! = user.name!
            screenNameLabel.text! = "@\(user.screenname!)"
        }
        tweetTextView.text = ""
        tweetTextView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tweetButtonTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
        //converting string to URL encoded format
        let tweet = tweetTextView.text
        let encodedString = tweet.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        
        delegate?.updateTweet(self, text: encodedString!)
    }
    
    //Go back to tweets view controller
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
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
