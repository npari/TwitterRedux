//
//  MenuViewController.swift
//  Twitter
//
//  Created by Pari, Nithya on 4/23/17.
//  Copyright © 2017 Pari, Nithya. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var menuTableView: UITableView!

    private var profileViewController: UINavigationController!
    private var timelineViewController: UIViewController!
    private var mentionsViewController: UINavigationController!
    
    var viewControllers: [UIViewController] = []
    var hamburgerViewController: HamburgerViewController!
    let menuTitles = ["Profile", "Timeline", "Mentions"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuTableView.dataSource = self
        menuTableView.delegate = self

        menuTableView.rowHeight = UITableViewAutomaticDimension
        menuTableView.estimatedRowHeight = 120

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationViewController") as! UINavigationController
        let profileView = profileViewController.topViewController as! ProfileViewController
        let user = User.currentUser
        profileView.userId = user?.id
        profileView.screenName = user?.screenname
        timelineViewController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        mentionsViewController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController") as! UINavigationController
        let mentionsController = mentionsViewController.topViewController as! TweetsViewController
        mentionsController.mentionsView = true
//        mentionsViewController = storyboard.instantiateViewController(withIdentifier: "tweetsViewController") as! TweetsViewController
//        mentionsViewController.mentionsView = true
//        loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        viewControllers.append(profileViewController)
        viewControllers.append(timelineViewController)
        viewControllers.append(mentionsViewController)
//        viewControllers.append(loginViewController)
        
//        viewControllers.append(profileViewController)
//        viewControllers.append(timelineViewController)
//        viewControllers.append(mentionsViewController)
        
        //Loading the default view here
        hamburgerViewController.contentViewController = timelineViewController
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuCell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        menuCell.menuTitleLabel.text = menuTitles[indexPath.row]
        
        return menuCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        menuTableView.deselectRow(at: indexPath, animated: true)
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
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
