//
//  User.swift
//  Twitter
//
//  Created by Lily Tran on 2/16/16.
//  Copyright © 2016 Lily Tran. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var screenname: String?
    var profileImageURL: NSURL?
    var backgroundImageURL: NSURL?
    var tagline: String?
    var dictionary: NSDictionary?
    var followerCount: Int = 0
    var tweetCount: Int = 0
    var followingCount: Int = 0
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        
        let profileURL = dictionary["profile_image_url_https"] as? String
        if let profileURL = profileURL {
            profileImageURL = NSURL(string: profileURL)
        }
        
        let backgroundURL = dictionary["profile_background_image_url_https"] as? String
        if let backgroundURL = backgroundURL {
            backgroundImageURL = NSURL(string: backgroundURL)
        }
        
        followerCount = (dictionary["followers_count"] as! Int) ?? 0
        tweetCount = (dictionary["statuses_count"] as! Int) ?? 0
        followingCount = (dictionary["friends_count"] as! Int) ?? 0
        
        tagline = dictionary["description"] as? String
    }
    
    static var _currentUser: User?
    static let userDidLogoutNotification = "UserDidLogout"
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                
                let userData = defaults.objectForKey("currentUserData") as? NSData
                if let userData = userData {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                defaults.setObject(data, forKey: "currentUserData")
            }
            else {
                 defaults.setObject(nil, forKey: "currentUserData")
            }
           
            defaults.synchronize()
        }
    }
}
