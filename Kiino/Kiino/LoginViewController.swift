//
//  LoginViewController.swift
//  Kiino
//
//  Created by Carlos Guerrero on 3/9/15.
//  Copyright (c) 2015 demo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let colours = ["#F44336", "#E91E63", "#9C27B0", "#673AB7", "#3F51B5", "#2196F3",
        "#03A9F4", "#00BCD4", "#009688", "#4CAF50", "#8BC34A", "#CDDC39", "#FFC107",
        "#FF9800", "#FF5722", "#607D8B"]
    
    
    @IBAction func fbLogin(sender: AnyObject) {
        PFFacebookUtils.logInWithPermissions(["publish_actions, read_stream"], {
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
        self.view.backgroundColor = self.randomColour()


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
    
    func randomColour() -> UIColor {
        
        let randomIndex = Int(arc4random_uniform(UInt32(self.colours.count)))
        return UIColor(hexString: self.colours[randomIndex])!
    }

}
