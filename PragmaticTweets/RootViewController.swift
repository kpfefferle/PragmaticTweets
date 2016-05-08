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

class RootViewController: UITableViewController, UISplitViewControllerDelegate {
    
    var parsedTweets: [ParsedTweet] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        reloadTweets()
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(RootViewController.handleRefresh(_:)), forControlEvents: .ValueChanged)
        refreshControl = refresher
        if let splitViewController = splitViewController {
            splitViewController.delegate = self
            addShowSplitPrimaryButton(splitViewController)
        }
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
        cell.avatarImageView.image = nil
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), {
            if let url = parsedTweet.userAvatarURL,
                imageData = NSData(contentsOfURL: url)
                where cell.userNameLabel.text == parsedTweet.userName {
                    dispatch_async(dispatch_get_main_queue(), {
                        cell.avatarImageView.image = UIImage(data: imageData)
                    })
            }
        })
        return cell
    }

    func reloadTweets() {
        let twitterParams = ["count": "100"]
        guard let twitterAPIURL = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json") else {
            return
        }
        sendTwitterRequest(twitterAPIURL,
          params: twitterParams,
          completion: { (data, urlResponse, error) -> Void in
            self.handleTwitterData(data, urlResponse: urlResponse, error: error)
        })
    }

    @IBAction func handleTweetButtonTapped(sender: AnyObject) {
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
                parsedTweet.tweetIdString = tweetDict["id_str"] as? String
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
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        } catch let error as NSError {
            NSLog("JSON error: \(error)")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTweetDetailsSegue" {
            if let row = tableView?.indexPathForSelectedRow?.row,
              tweetDetailsVC = segue.destinationViewController as? TweetDetailViewController {
                let parsedTweet = parsedTweets[row]
                tweetDetailsVC.tweetIdString = parsedTweet.tweetIdString
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let parsedTweet = parsedTweets[indexPath.row]
        if let splitViewController = splitViewController where splitViewController.viewControllers.count > 1 {
            if let tweetDetailNav = splitViewController.viewControllers[1] as? UINavigationController,
              tweetDetailVC = tweetDetailNav.viewControllers[0] as? TweetDetailViewController {
                tweetDetailVC.tweetIdString = parsedTweet.tweetIdString
            }
        } else {
            if let storyboard = storyboard,
              detailVC = storyboard.instantiateViewControllerWithIdentifier("TweetDetailVC") as? TweetDetailViewController {
                detailVC.tweetIdString = parsedTweet.tweetIdString
                splitViewController?.showDetailViewController(detailVC, sender: self)
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func splitViewController(splitViewController: UISplitViewController,
      collapseSecondaryViewController secondaryViewController: UIViewController,
      ontoPrimaryViewController primaryViewController: UIViewController)
      -> Bool {
        return true
    }
    
    func addShowSplitPrimaryButton(splitViewController: UISplitViewController) {
        let barButtonItem = splitViewController.displayModeButtonItem()
        if let detailNav = splitViewController.viewControllers.last as? UINavigationController {
            detailNav.topViewController?.navigationItem.leftBarButtonItem = barButtonItem
        }
    }
    
    func splitViewController(svc: UISplitViewController,
      willChangeToDisplayMode displayMode: UISplitViewControllerDisplayMode) {
        if displayMode == .PrimaryHidden {
            addShowSplitPrimaryButton(svc)
        }
    }

}

