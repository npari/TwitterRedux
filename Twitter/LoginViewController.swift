//
//  LoginViewController.swift
//  Twitter
//
//  Created by Pari, Nithya on 4/16/17.
//  Copyright © 2017 Pari, Nithya. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogin(_ sender: AnyObject) {
        let twitterClient = TwitterClient.sharedInstance
        twitterClient?.login(success: { 
            print("Login success")
            
//            self.performSegue(withIdentifier: "hamburgerSegue", sender: nil)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let hamburgerViewController = storyboard.instantiateViewController(withIdentifier: "hamburgerViewController") as! HamburgerViewController
            let menuNavViewController = storyboard.instantiateViewController(withIdentifier: "menuNavigationController") as! UINavigationController
            let menuViewController = menuNavViewController.topViewController as! MenuViewController
//            let menuViewController = storyboard.instantiateViewController(withIdentifier: "menuViewController") as! MenuViewController
            menuViewController.hamburgerViewController = hamburgerViewController
            hamburgerViewController.menuViewController = menuNavViewController
            
            self.present(hamburgerViewController, animated: true, completion: nil)
            

            }, failure: { (error:Error) in
            print(error)
        })
        
        

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
