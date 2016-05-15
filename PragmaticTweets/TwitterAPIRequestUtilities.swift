 //
//  TwitterAPIRequestUtilities.swift
//  PragmaticTweets
//
//  Created by Kevin Pfefferle on 4/9/16.
//  Copyright © 2016 Kevin Pfefferle. All rights reserved.
//

import Foundation
import Social
import Accounts

public func sendTwitterRequest(requestURL: NSURL,
  params: [String: String],
  completion: SLRequestHandler) {
    let accountStore = ACAccountStore()
    let twitterAccountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
    accountStore.requestAccessToAccountsWithType(twitterAccountType,
      options: nil,
      completion: {
        (granted: Bool, error: NSError!) -> Void in
        guard granted else {
            NSLog("account access not granted")
            return
        }
        let twitterAccounts = accountStore.accountsWithAccountType(twitterAccountType)
        guard twitterAccounts.count > 0 else {
            NSLog("no twitter accounts configured")
            completion(nil,
              nil,
                NSError(domain: "PragmaticTweets",
                  code: 1000,
                  userInfo: [NSLocalizedDescriptionKey : "no Twitter accounts configured"])
            )
            return
        }
        let request = SLRequest(forServiceType: SLServiceTypeTwitter,
          requestMethod: .GET,
          URL: requestURL,
          parameters: params)
        request.account = twitterAccounts.first as! ACAccount
        request.performRequestWithHandler(completion)
    })
}