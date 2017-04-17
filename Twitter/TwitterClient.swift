//
//  TwitterClient.swift
//  Twitter
//
//  Created by Pari, Nithya on 4/16/17.
//  Copyright © 2017 Pari, Nithya. All rights reserved.
//

import UIKit
import BDBOAuth1Manager


class TwitterClient: BDBOAuth1SessionManager {
    
    static let baseURL: NSURL = NSURL(string: "https://api.twitter.com")!
    static let consumerKey: String = "c23ErS86Q45ISyuvfSoFqTKaf"
    static let consumerSecret: String = "UvMdJL45Sx4D1CIQmyaAPJb7iboagO2caAqdx6ziuqXcnja0ak"
    static let callbackURL: NSURL = NSURL(string: "twitterdemo://oauth")!
    static let sharedInstance = TwitterClient(baseURL: baseURL as URL!, consumerKey: consumerKey, consumerSecret: consumerSecret)
    
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    
     //Get the user's tweets
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            
            let tweetDictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: tweetDictionaries)
            success(tweets)
            
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
        })
    }
    
    //Get the current user's details
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
        
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
        })
        
    }
    
    //Login
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        
        self.loginSuccess = success
        self.loginFailure = failure
        
        deauthorize()
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: TwitterClient.callbackURL as URL!, scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            print(requestToken?.token)
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")!
            UIApplication.shared.open(url as URL)
            
            //Handle Success
            
            
            }, failure: { (error: Error?) in
                failure(error!)
                
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.UserDidLogOut), object: nil)
    }
    
    func handleUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query!)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
                }, failure: { (error: Error) in
                    self.loginFailure?(error)
            })
            
            
            }, failure: { (error: Error?) in
                self.loginFailure?(error!)
        })
    }
}
