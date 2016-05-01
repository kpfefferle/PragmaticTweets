//
//  TweetDetailViewController.swift
//  PragmaticTweets
//
//  Created by Kevin Pfefferle on 4/29/16.
//  Copyright © 2016 Kevin Pfefferle. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var userImageButton: UIButton!
    @IBOutlet weak var userRealNameLabel: UILabel!
    @IBOutlet weak var userScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetImageView: UIImageView!

    var tweetIdString: String? {
        didSet {
            reloadTweetDetails()
        }
    }
    
    func reloadTweetDetails() {
    }
    
}
