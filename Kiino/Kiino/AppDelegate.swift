//
//  AppDelegate.swift
//  Kiino
//
//  Created by Carlos Guerrero on 2/26/15.
//  Copyright (c) 2015 demo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        application.statusBarHidden = true
        Parse.setApplicationId("Pqij1heFb72OBZ2l4WjPqqan565JWmvyqAAoH4wr", clientKey: "okkwKhfUbVHGZAAMt9ksn0qL0ivpPtcAlPHTy2bw")
        var object = PFObject(className: "testDataClass")
        PFFacebookUtils.initializeFacebook()
        PFTwitterUtils.initializeWithConsumerKey("jIZ5UXReZkjTrbA9znPIcOO1L",
                                consumerSecret:"rC41wqofyo6Vnyo3uu06jbjKHySqABQ1mwOywcP84OuqqyjWEz")
        
        PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: nil)
        
        if PFUser.currentUser() != nil{
            let menuViewController = self.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("NavigationSearchController") as NavigationSearchController
            self.window =  UIWindow(frame: UIScreen.mainScreen().bounds)
            self.window?.rootViewController = menuViewController
            self.window?.makeKeyAndVisible()
        }
        

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }
    
    func application(application: UIApplication,
        openURL url: NSURL,
        sourceApplication: String?,
        annotation: AnyObject?) -> Bool {
            return FBAppCall.handleOpenURL(url, sourceApplication:sourceApplication,
                withSession:PFFacebookUtils.session())
    }
    
    func resetApp(){
        self.window?.rootViewController =
            UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController") as LoginViewController
    }

    func applicationDidBecomeActive(application: UIApplication) {
        FBAppCall.handleDidBecomeActiveWithSession(PFFacebookUtils.session())
    }

    func applicationWillTerminate(application: UIApplication) {
    }

}

