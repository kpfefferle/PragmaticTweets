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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "embedSplitViewSegue" {
            embeddedSplitVC = segue.destinationViewController as! UISplitViewController
        }
    }
    
}
