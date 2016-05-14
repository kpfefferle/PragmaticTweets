//
//  UserImageDetailViewController.swift
//  PragmaticTweets
//
//  Created by Kevin Pfefferle on 5/14/16.
//  Copyright © 2016 Kevin Pfefferle. All rights reserved.
//

import UIKit

class UserImageDetailViewController: UIViewController {
    
    var userImageURL: NSURL?
    
    @IBOutlet weak var userImageView: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let userImageURL = userImageURL,
          imageData = NSData(contentsOfURL: userImageURL) {
            userImageView.image = UIImage(data: imageData)
        }
    }
}
