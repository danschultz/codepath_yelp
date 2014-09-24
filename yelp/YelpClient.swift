//
//  YelpClient.swift
//  yelp
//
//  Created by Dan Schultz on 9/18/14.
//  Copyright (c) 2014 Dan Schultz. All rights reserved.
//

import Foundation

class YelpClient: BDBOAuth1RequestOperationManager {
    
    init(consumerKey: NSString, consumerSecret: NSString, accessToken: NSString, accessSecret: NSString) {
        super.init(baseURL: NSURL(string: "http://api.yelp.com/v2/"), consumerKey: consumerKey, consumerSecret: consumerSecret)
        
        var token = BDBOAuthToken(token: accessToken, secret: accessSecret, expiration: nil)
        requestSerializer.saveAccessToken(token)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func search(term: NSString, location: NSString, handler: ((AnyObject!, NSError!) -> Void)!) -> AFHTTPRequestOperation {
        return searchWithParams(["term": term, "location": location], handler: handler)
    }
    
    func searchWithParams(params: [NSString: AnyObject], handler: ((AnyObject!, NSError!) -> Void)!) -> AFHTTPRequestOperation {
        return GET("search", parameters: params,
            success: { (operation, data) in
                handler(data, nil)
            },
            failure: { (operation, error) in
                handler(nil, error)
            })
    }
}
