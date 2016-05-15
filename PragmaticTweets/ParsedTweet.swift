//
//  ParsedTweet.swift
//  PragmaticTweets
//
//  Created by Kevin Pfefferle on 3/31/16.
//  Copyright © 2016 Kevin Pfefferle. All rights reserved.
//

import Foundation

public struct ParsedTweet {
    public var tweetIdString: String?
    public var tweetText: String?
    public var userName: String?
    public var createdAt: String?
    public var userAvatarURL: NSURL?
    
    public init() {
    }
}
