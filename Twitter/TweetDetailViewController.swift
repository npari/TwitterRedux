//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Pari, Nithya on 4/17/17.
//  Copyright © 2017 Pari, Nithya. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    var tweet: Tweet!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!

    @IBOutlet weak var tweetLabel: UILabel!
    
    @IBOutlet weak var favoritesCountLabel: UILabel!
    @IBOutlet weak var retweetsCountLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    @IBOutlet weak var replyImage: UIButton!
    
    
    @IBOutlet weak var retweetImage: UIButton!
    
    
    @IBOutlet weak var favoriteImage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(tweet)
        updateTweet()
        // Do any additional setup after loading the view.
    }
    
    func updateTweet() {
        var currentTweet = tweet
        if let tweetedStatus = currentTweet?.retweetedStatus {
            if currentTweet?.user?.id == User.currentUser?.id {
                currentTweet = tweetedStatus
                self.retweetImage.imageView?.image = UIImage(named: "retweet-on")
            }
        }
        tweetLabel.text = currentTweet?.text
        if let user = currentTweet?.user {
            nameLabel.text = user.name
            usernameLabel.text = user.screenname
            profileImage.setImageWith(user.profileUrl as! URL)
        }
        if tweet.favorited {
            self.favoriteImage.imageView?.image = UIImage(named: "like-on")
        } else {
            self.favoriteImage.imageView?.image = UIImage(named: "like-off")
        }
//        if tweet.retweeted {
//            self.retweetImage.imageView?.image = UIImage(named: "retweet-on")
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onHomeTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func onReplyImageTapped(_ sender: AnyObject) {
    }
    

    @IBAction func onRetweetImageTapped(_ sender: AnyObject) {
        let twitterClient = TwitterClient.sharedInstance
        twitterClient?.retweet(tweet: self.tweet, success: { (newTweet: Tweet) in
            self.tweet = newTweet
            self.updateTweet()
            }, failure: { (error: Error) in
                print(error.localizedDescription)
        })
    }
    
    
    @IBAction func onFavoriteImageTapped(_ sender: AnyObject) {
        let twitterClient = TwitterClient.sharedInstance
        if !self.tweet.favorited {
            twitterClient?.favorite(tweet: self.tweet, success: { (newTweet: Tweet) in
                newTweet.favorited = true
                self.tweet = newTweet
                self.updateTweet()
                }, failure: { (error: Error) in
                    print(error.localizedDescription)
            })
        } else {
            twitterClient?.dislike(tweet: self.tweet, success: { (newTweet: Tweet) in
                newTweet.favorited = false
                self.tweet = newTweet
                self.updateTweet()
                }, failure: { (error: Error) in
                    print(error.localizedDescription)
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        if identifier == "replyTweet" {
            let navController = segue.destination as! UINavigationController
            let newTweetController = navController.topViewController as! NewTweetViewController
            newTweetController.inReplyToUser = self.tweet.user
            newTweetController.inReplyToStatus = self.tweet
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
