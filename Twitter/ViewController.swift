//
//  ViewController.swift
//  Twitter
//
//  Created by Lily Tran on 2/16/16.
//  Copyright © 2016 Lily Tran. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogin(sender: AnyObject) {
        TwitterClient.sharedInstance.login({ () -> () in
            print("I've logged in")
            self.performSegueWithIdentifier("loginSegue", sender: nil)
        }) { (error: NSError) -> () in
            print("error: \(error.localizedDescription)")
        }
    }

}

