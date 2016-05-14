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
    var preGestureTransform: CGAffineTransform?
    
    @IBOutlet weak var userImageView: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let userImageURL = userImageURL,
          imageData = NSData(contentsOfURL: userImageURL) {
            userImageView.image = UIImage(data: imageData)
        }
    }

    @IBAction func handlePanGesture(sender: UIPanGestureRecognizer) {
        if sender.state == .Began {
            preGestureTransform = userImageView.transform
        }
        if sender.state == .Began ||
          sender.state == .Changed {
            let translation = sender.translationInView(userImageView)
            let translatedTransform = CGAffineTransformTranslate(preGestureTransform!, translation.x, translation.y)
            userImageView.transform = translatedTransform
        }
    }

    @IBAction func handleDoubleTapGesture(sender: UITapGestureRecognizer) {
        userImageView.transform = CGAffineTransformIdentity
    }
    
}
