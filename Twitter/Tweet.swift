//
//  Tweet.swift
//  Twitter
//
//  Created by Pari, Nithya on 4/16/17.
//  Copyright © 2017 Pari, Nithya. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: String?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var favorited: Bool = false
    var retweeted: Bool = false
    var user: User?
    var id: String?
    var retweetedStatus: Tweet?
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["retweet_count"] as? Int) ?? 0
        let userData = dictionary["user"]
        user = User(dictionary: userData as! NSDictionary)
        favorited = (dictionary["favorited"] as? Bool) ?? false
        favorited = (dictionary["retweeted"] as? Bool) ?? false
        id = dictionary["id_str"] as? String
        let retweetedStatusResponse = dictionary["retweeted_status"]
        if let retweetedStatusResponse = retweetedStatusResponse {
            retweetedStatus = Tweet(dictionary: retweetedStatusResponse as! NSDictionary)
        }
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString) as NSDate?
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets: [Tweet] = []
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    
    }
    

}
