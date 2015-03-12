//
//  LoginViewController.swift
//  Kiino
//
//  Created by Carlos Guerrero on 3/9/15.
//  Copyright (c) 2015 demo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBAction func fbLogin(sender: AnyObject) {
        PFFacebookUtils.logInWithPermissions(["publish_actions"], {
            (user: PFUser!, error: NSError!) -> Void in
            if user == nil {
                NSLog("Uh oh. The user cancelled the Facebook login.")
            } else if user.isNew {
                NSLog("User signed up and logged in through Facebook!")
                self.openSearchView()
            } else {
                NSLog("User logged in through Facebook!")
                self.openSearchView()
            }
        })
    }
    
    func openSearchView(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuViewController =
        storyboard.instantiateViewControllerWithIdentifier("NavigationSearchController")
                                                        as NavigationSearchController
        
        self.presentViewController(menuViewController,
                                   animated: true,
                                   completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
