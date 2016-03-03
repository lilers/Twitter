//
//  TwitterClient.swift
//  Twitter
//
//  Created by Lily Tran on 2/16/16.
//  Copyright © 2016 Lily Tran. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
     static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com"), consumerKey: "GZRTIrYChLbw91NBao1gS3vg8", consumerSecret: "qznQo09LWcqSw5ft8DgeICCHPTExUfFzPxVU113r8W6RcWtYxd")
    
    var loginSuccess: (()->())?
    var loginFailure: ((NSError)->())?
    
    func login(success: ()->(), failure: (NSError)->()) {
        loginSuccess = success
        loginFailure = failure
        //Fetch request token & redirect to authorization page
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterLily://oauth"), scope: nil, success: {(requestToken: BDBOAuth1Credential!) -> Void in
                let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                UIApplication.sharedApplication().openURL(authURL!)
            }) {(error: NSError!) -> Void in
                print("errpr: \(error.localizedDescription)")
                self.loginFailure?(error)
        }
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: {(accessToken: BDBOAuth1Credential!) -> Void in
                //Get user account/data
                self.currentAccount({ (user: User) -> () in
                        User.currentUser = user
                        self.loginSuccess?()
                    }, failure: { (error: NSError) -> () in
                        self.loginFailure?(error)
                })
            }) { (error: NSError!) -> Void in
                self.loginFailure?(error)
        }
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                //print("user: \(response)")
                let user = User(dictionary: response as! NSDictionary)
                success(user)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                failure(error)
        })
    }
    
    func homeTimeLine(success: ([Tweet] -> ()), failure: (NSError) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                success(tweets)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                failure(error)
        })
    }
    
//    func userTimeLine(username: String, tweet: [Tweet]) -> [Tweet] {
//        var update = tweet
//        GET("1.1/statuses/user_timeline.json?screen_name=\(username)", parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
//                let tweets = Tweet(dictionary: response as! NSDictionary)
//                update.append(tweets)
//            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
//                print("\(error.localizedDescription)")
//        })
//        return update
//    }
    
    func retweet(id: String) {
        POST("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                print("retweet")
            }) { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("\(error.localizedDescription)")
        }
    }
    
    func unretweet(id: String) {
        POST("1.1/statuses/unretweet/\(id).json", parameters: nil, progress: nil, success: { (operation:NSURLSessionDataTask!, response: AnyObject?) -> Void in
                print("unretweet")
            }) { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("\(error.localizedDescription)")
        }
    }
    
    func favorite(id: String) {
        POST("1.1/favorites/create.json?id=\(id)", parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                print("favorited")
            }) { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("\(error.localizedDescription)")
        }
    }
    
    func unfavorite(id: String) {
        POST("1.1/favorites/destroy.json?id=\(id)", parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                print("unfavorited")
            }) { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("\(error.localizedDescription)")
        }
    }
    
    func postMessage(msg: String, id: String) {
        if (id == "") {
            POST("1.1/statuses/update.json?status=\(msg)", parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                print("msg sent")
                }) { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                    print("\(error.localizedDescription)")
            }
        }
        else {
            POST("1.1/statuses/update.json?status=\(msg)&in_reply_to_status_id=\(id)", parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                print("reply sent")
                }) { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                    print("\(error.localizedDescription)")
            }
        }
        
    }
}
