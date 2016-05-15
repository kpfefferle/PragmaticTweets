//
//  KeyboardViewController.swift
//  PragmaticTweepsKeyboard
//
//  Created by Kevin Pfefferle on 5/14/16.
//  Copyright © 2016 Kevin Pfefferle. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tweepNames: [String] = []

    @IBOutlet weak var nextKeyboardBarButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let twitterParams = ["count" : "100"]
        guard let twitterAPIURL = NSURL(string: "https://api.twitter.com/1.1/friends/list.json") else {
            return
        }
        sendTwitterRequest(twitterAPIURL,
          params: twitterParams,
          completion: { (data, urlResponse, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                self.handleTwitterData(data, urlResponse: urlResponse, error: error)
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    @IBAction func nextKeyboardBarButtonTapped(sender: UIBarButtonItem) {
        advanceToNextInputMode()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweepNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DefaultCell") as UITableViewCell!
        cell.textLabel?.text = "@\(tweepNames[indexPath.row])"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let atName = "@\(tweepNames[indexPath.row])"
        textDocumentProxy.insertText(atName)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func handleTwitterData(data: NSData!, urlResponse: NSHTTPURLResponse!, error: NSError!) {
        guard let data = data else {
            NSLog("handleTwitterData() recieved no data")
            return
        }
        NSLog("handleTwitterData(), \(data.length) bytes")
        do {
            let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions([]))
            guard let jsonDict = jsonObject as? [String : AnyObject],
              usersArray = jsonDict["users"] as? [ [String : AnyObject] ] else {
                NSLog("handleTwitterData() can't parse data")
                return
            }
            tweepNames.removeAll()
            for userDict in usersArray {
                if let tweepName = userDict["screen_name"] as? String {
                    tweepNames.append(tweepName)
                }
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        } catch let error as NSError {
            NSLog("JSON error: \(error)")
        }
    }
}
