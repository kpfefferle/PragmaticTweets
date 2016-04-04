//
//  ViewController.swift
//  PragmaticTweets
//
//  Created by Kevin Pfefferle on 3/28/16.
//  Copyright © 2016 Kevin Pfefferle. All rights reserved.
//

import UIKit
import Social
import Accounts

let defaultAvatarURL = NSURL(string: "https://abs.twimg.com/sticky/default_profile_images/default_profile_6_200x200.png")

class ViewController: UITableViewController {
    
    var parsedTweets: [ParsedTweet] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        reloadTweets()
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(ViewController.handleRefresh(_:)), forControlEvents: .ValueChanged)
        refreshControl = refresher
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
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomTweetCell") as! ParsedTweetCell
        let parsedTweet = parsedTweets[indexPath.row]
        cell.userNameLabel.text = parsedTweet.userName
        cell.tweetTextLabel.text = parsedTweet.tweetText
        cell.createdAtLabel.text = parsedTweet.createdAt
        if let url = parsedTweet.userAvatarURL, imageData = NSData(contentsOfURL: url) {
            cell.avatarImageView.image = UIImage(data: imageData)
        }
        return cell
    }

    func reloadTweets() {
        let accountStore = ACAccountStore()
        let twitterAccountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(twitterAccountType,
            options: nil,
            completion: {
                (granted: Bool, error: NSError!) -> Void in
                guard granted else {
                    NSLog("account access not granted")
                    return
                }
                let twitterAccounts = accountStore.accountsWithAccountType(twitterAccountType)
                guard twitterAccounts.count > 0 else {
                    NSLog("no twitter accounts configured")
                    return
                }
                let twitterParams = [
                    "count": "100"
                ]
                let twitterAPIURL = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
                let request = SLRequest(forServiceType: SLServiceTypeTwitter,
                    requestMethod: .GET,
                    URL: twitterAPIURL,
                    parameters: twitterParams)
                request.account = twitterAccounts.first as! ACAccount
                request.performRequestWithHandler({
                    (data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) -> Void in
                    self.handleTwitterData(data, urlResponse: urlResponse, error: error)
                })
        })
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
    
    @IBAction func handleRefresh(sender: AnyObject?) {
        reloadTweets()
        refreshControl?.endRefreshing()
    }
    
    private func handleTwitterData(data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) {
        guard let data = data else {
            NSLog("handleTwitterData() recieved no data")
            return
        }
        NSLog("handleTwitterData(), \(data.length) bytes")
        do {
            let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions([]))
            guard let jsonArray = jsonObject as? [[String : AnyObject]] else {
                NSLog("handleTwitterData() didn't get an array")
                return
            }
            parsedTweets.removeAll()
            for tweetDict in jsonArray {
                var parsedTweet = ParsedTweet()
                parsedTweet.tweetText = tweetDict["text"] as? String
                parsedTweet.createdAt = tweetDict["created_at"] as? String
                if let userDict = tweetDict["user"] as? [String : AnyObject] {
                    parsedTweet.userName = userDict["name"] as? String
                    if let avatarURLString = userDict["profile_image_url_https"] as? String {
                        parsedTweet.userAvatarURL = NSURL(string: avatarURLString)
                    }
                }
                parsedTweets.append(parsedTweet)
            }
            tableView.reloadData()
        } catch let error as NSError {
            NSLog("JSON error: \(error)")
        }
    }

}

