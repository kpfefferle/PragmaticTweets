//
//  SizeClassOverrideViewController.swift
//  PragmaticTweets
//
//  Created by Kevin Pfefferle on 5/14/16.
//  Copyright © 2016 Kevin Pfefferle. All rights reserved.
//

import UIKit

class SizeClassOverrideViewController: UIViewController {
    
    var embeddedSplitVC: UISplitViewController!
    var screenNameForOpenURL: String?

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "embeddedSplitViewSegue" {
            embeddedSplitVC = segue.destinationViewController as! UISplitViewController
        } else if segue.identifier == "showUserFromURLSegue" {
            if let userDetailVC = segue.destinationViewController as? UserDetailViewController {
                userDetailVC.screenName = screenNameForOpenURL
            }
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize,
      withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if size.width > 480.0 {
            let overrideTraits = UITraitCollection(horizontalSizeClass: .Regular)
            setOverrideTraitCollection(overrideTraits, forChildViewController: embeddedSplitVC)
        } else {
            setOverrideTraitCollection(nil, forChildViewController: embeddedSplitVC)
        }
    }
    
    @IBAction func unwindToSizeClassOverrideVC(segue: UIStoryboardSegue) {
    }
    
}
