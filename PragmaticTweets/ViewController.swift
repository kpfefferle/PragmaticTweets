//
//  ViewController.swift
//  PragmaticTweets
//
//  Created by Kevin Pfefferle on 3/28/16.
//  Copyright © 2016 Kevin Pfefferle. All rights reserved.
//

import UIKit
import Social

let defaultAvatarURL = NSURL(string: "https://abs.twimg.com/sticky/default_profile_images/default_profile_6_200x200.png")

class ViewController: UITableViewController {
    
    var parsedTweets: [ParsedTweet] = [
        ParsedTweet(tweetText: "iOS 9 SDK Development now in print. Swift programming FTW!",
            userName: "@pragprog",
            createdAt: "2015-09-09 15:44:30 EDT",
            userAvatarURL: defaultAvatarURL),
        ParsedTweet(tweetText: "But was that really such a good idea?",
            userName: "@redqueencoder",
            createdAt: "2014-12-04 22:15:55 CST",
            userAvatarURL: defaultAvatarURL),
        ParsedTweet(tweetText: "Struct all the things!",
            userName: "@invalidname",
            createdAt: "2015-07-31 05:39:39 EDT",
            userAvatarURL: defaultAvatarURL)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.reloadTweets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parsedTweets.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
        let parsedTweet = parsedTweets[indexPath.row]
        cell.textLabel?.text = parsedTweet.tweetText
        return cell
    }

    func reloadTweets() {
    }

    @IBAction func handleTweetButtonTapped(sender: UIButton) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let tweetVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            tweetVC.setInitialText("I just finished the first project in iOS 9 SDK Development. #pragios9")
            self.presentViewController(tweetVC, animated: true, completion: nil)
        } else {
            NSLog("Can't send tweet")
        }
    }

}

