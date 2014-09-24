//
//  Business.swift
//  yelp
//
//  Created by Dan Schultz on 9/18/14.
//  Copyright (c) 2014 Dan Schultz. All rights reserved.
//

import Foundation

class Business {
    var id: NSString
    var name: NSString
    var reviewCount: Int
    var rating: Double
    var address: String
    var distance: Float?
    var categories: [NSString]
    var ratingImageUrl: NSURL
    var imageUrl: NSURL
    
    init(values: [NSString: AnyObject]) {
        id = values["id"] as NSString
        name = values["name"] as NSString
        reviewCount = values["review_count"]! as Int
        rating = values["rating"]! as Double
        ratingImageUrl = NSURL(string: values["rating_img_url"]! as NSString)
        imageUrl = NSURL(string: values["image_url"]! as NSString)
        
        var location = values["location"]! as [NSString: AnyObject]
        var addressValue = location["address"]! as [NSString]
        address = addressValue.count > 0 ? addressValue[0] : ""
        
        var tempCategories = values["categories"]! as [[NSString]]
        categories = tempCategories.map({ $0[0] }) as [NSString]
        
        if let distanceData = values["distance"] {
            distance = distanceData as? Float
        }
    }
}
