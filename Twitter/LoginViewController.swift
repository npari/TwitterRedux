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
        let baseURL: NSURL = NSURL(string: "https://api.twitter.com")!
        let consumerKey: String = "c23ErS86Q45ISyuvfSoFqTKaf"
        let consumerSecret: String = "UvMdJL45Sx4D1CIQmyaAPJb7iboagO2caAqdx6ziuqXcnja0ak"
        let callbackURL: NSURL = NSURL(string: "twitterdemo://oauth")!
        
        let twitterClient =
            BDBOAuth1SessionManager(baseURL: baseURL as URL!, consumerKey: consumerKey, consumerSecret: consumerSecret)
        twitterClient?.deauthorize()
        twitterClient?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: callbackURL as URL!, scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            print(requestToken?.token)
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")!
            UIApplication.shared.open(url as URL)
            
            
            }, failure: { (error: Error?) in
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
