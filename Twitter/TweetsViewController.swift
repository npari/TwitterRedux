//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Pari, Nithya on 4/17/17.
//  Copyright © 2017 Pari, Nithya. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource {

    var tweets : [Tweet] = []
    var refreshControl: UIRefreshControl!
    var mentionsView: Bool?
    var userId: String!
    var screenName: String!

    
    @IBOutlet weak var tweetsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        addRefreshControl()
        tweetsTableView.dataSource = self
        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        tweetsTableView.estimatedRowHeight = 120
        getTweets()
        // Do any additional setup after loading the view.
    }
    
    func getTweets() {
        if userId != nil && screenName != nil {
            TwitterClient.sharedInstance?.userTimeline(userId: userId, screenName: screenName, success: { (tweets:[Tweet]) in
                self.tweets = tweets
                self.tweetsTableView.reloadData()
                self.refreshControl.endRefreshing()
                }, failure: { (error: Error) in
                    self.refreshControl.endRefreshing()
            })
        } else if mentionsView != nil && mentionsView! {
            TwitterClient.sharedInstance?.mentionsTimeline(success: { (tweets:[Tweet]) in
                self.tweets = tweets
                self.tweetsTableView.reloadData()
                self.refreshControl.endRefreshing()
                }, failure: { (error: Error) in
                    self.refreshControl.endRefreshing()
                    
            })

        } else {
            TwitterClient.sharedInstance?.homeTimeline(success: { (tweets:[Tweet]) in
                self.tweets = tweets
                self.tweetsTableView.reloadData()
                self.refreshControl.endRefreshing()
                }, failure: { (error: Error) in
                    self.refreshControl.endRefreshing()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tweetCell = tweetsTableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        tweetCell.tweet = tweets[indexPath.row]
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.goToUserProfileAction(sender:)))
        tweetCell.profileImage.addGestureRecognizer(tapGestureRecognizer)
        return tweetCell
    }
    


    
    @IBAction func onLogOut(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.logout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        if identifier == "tweetDetail" {
            let detailViewController = segue.destination as! TweetDetailViewController
            let cell = sender as! TweetCell
            let indexPath = self.tweetsTableView.indexPath(for: cell)
            detailViewController.tweet = self.tweets[(indexPath?.row)!]
        }
    }
    
    func addRefreshControl() {
        
        //Initialize a UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(TweetsViewController.refreshControlAction), for: UIControlEvents.valueChanged)
        //add refresh control to table view
        tweetsTableView.insertSubview(refreshControl, at: 0)
    }
    
    
    func refreshControlAction() {
        getTweets()
    }
    
    func goToUserProfileAction(sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.tweetsTableView)
        let indexPath = self.tweetsTableView.indexPathForRow(at: location)
        if let indexPath = indexPath {
            let tweet = self.tweets[indexPath.row]
            let user = tweet.user
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationViewController") as! UINavigationController
            let profileView = profileViewController.topViewController as! ProfileViewController
            profileView.userId = user?.id
            profileView.screenName = user?.screenname
            self.present(profileViewController, animated: true, completion: nil)
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
