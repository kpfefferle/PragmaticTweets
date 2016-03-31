//
//  ParsedTweetCell.swift
//  PragmaticTweets
//
//  Created by Kevin Pfefferle on 3/31/16.
//  Copyright © 2016 Kevin Pfefferle. All rights reserved.
//

import UIKit

class ParsedTweetCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
