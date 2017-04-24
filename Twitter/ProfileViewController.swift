//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Pari, Nithya on 4/23/17.
//  Copyright © 2017 Pari, Nithya. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var userId: String!
    var screenName: String!
    
    @IBOutlet weak var profileBannerImage: UIImageView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    
    @IBOutlet weak var tweetsCountLabel: UILabel!
    
    @IBOutlet weak var followingCountLabel: UILabel!
    
    @IBOutlet weak var followersCountLabel: UILabel!
    
    
    @IBOutlet weak var tweetsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserProfile()

        // Do any additional setup after loading the view.
    }
    
    func getUserProfile() {
        TwitterClient.sharedInstance?.userProfile(userId: userId, screenName: screenName, success: { (user: User) in
                print("User received")
            self.userName.text = user.name
            self.screenNameLabel.text = "@" + user.screenname!
            self.profileImage.setImageWith(user.profileUrl as! URL)
            self.profileBannerImage.setImageWith(user.profileBannerUrl as! URL)
            self.tweetsCountLabel.text = String(user.statusesCount)
            self.followingCountLabel.text = String(user.friendsCount)
            self.followersCountLabel.text = String(user.followersCount)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tweetsViewController = storyboard.instantiateViewController(withIdentifier: "tweetsViewController") as! TweetsViewController
            self.addChildViewController(tweetsViewController)
            tweetsViewController.view.frame = self.tweetsView.frame
            self.view.addSubview(tweetsViewController.view)
            }, failure: { (error: Error) in
                print(error.localizedDescription)
        })
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
