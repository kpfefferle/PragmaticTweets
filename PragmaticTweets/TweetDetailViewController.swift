//
//  TweetDetailViewController.swift
//  PragmaticTweets
//
//  Created by Kevin Pfefferle on 4/29/16.
//  Copyright © 2016 Kevin Pfefferle. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    var tweetIdString: String? {
        didSet {
            reloadTweetDetails()
        }
    }
    
    func reloadTweetDetails() {
    }
    
}
