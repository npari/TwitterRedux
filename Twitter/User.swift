//
//  User.swift
//  Twitter
//
//  Created by Pari, Nithya on 4/16/17.
//  Copyright © 2017 Pari, Nithya. All rights reserved.
//

import UIKit

class User: NSObject {
    
    static let UserDidLogOut = "userDidLogOut"
    
    var id: String?
    var name: String?
    var screenname: String?
    var profileUrl: NSURL?
    var profileBannerUrl: NSURL?
    var tagline: String?
    var followersCount: Int = 0
    var statusesCount: Int = 0
    var friendsCount: Int = 0
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        id = dictionary["id_str"] as? String
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string: profileUrlString)
        }
        let profileBannerUrlString = dictionary["profile_banner_url"] as? String
        if let profileBannerUrlString = profileBannerUrlString {
            profileBannerUrl = NSURL(string: profileBannerUrlString)
        }

        tagline = dictionary["description"] as? String
        followersCount = (dictionary["followers_count"] as? Int) ?? 0
        statusesCount = (dictionary["statuses_count"] as? Int) ?? 0
        friendsCount = (dictionary["friends_count"] as? Int) ?? 0
    }
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? Data
                print(userData)
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                print(data)
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.set(nil, forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
}
