//
//  ViewController.swift
//  Kiino
//
//  Created by Carlos Guerrero on 2/26/15.
//  Copyright (c) 2015 demo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var searcher: UITextField!
    @IBOutlet weak var sideBar: UIView!
    
    var screenEdgeRecognizer: UIScreenEdgePanGestureRecognizer!
    var sideBarPan : UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searcher.delegate = self
        self.addGestureRecognizerToView()
        self.sideBarPan = UIPanGestureRecognizer(target: self,
            action: "moveSideBar:")
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addGestureRecognizerToView() {
        self.screenEdgeRecognizer = UIScreenEdgePanGestureRecognizer(target: self,
            action: "moveSideBar:")
        self.screenEdgeRecognizer.edges = .Left
        self.view.addGestureRecognizer(self.screenEdgeRecognizer)
    }
    
    func addGesturePanToSideBar() {
     
        self.sideBar.addGestureRecognizer(self.sideBarPan)
    }
    
    func removeGesturePanToSideBar() {
        self.sideBar.removeGestureRecognizer(self.sideBarPan)
    }
    
    func validateSearch () -> Bool {
    
        return (self.searcher.text == "") ? false : true
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        
        if (identifier! == "searching" && !self.validateSearch()) {
            self.displayErrorMessage()
        }
        
        return true
    }
    
    func displayErrorMessage() {
        
        var alert =
            UIAlertController(title: nil, message: "Are you sure about that?",
                preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok",
            style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func handleSideBar(x:CGFloat){
        UIView.animateWithDuration(0.5,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: .CurveEaseInOut,
            animations: {
                self.sideBar.frame = CGRectMake(x, 0.0, self.sideBar.frame.width, self.sideBar.frame.height)
            }, completion: nil)
        
    }
    
    func moveSideBar(sender: UIScreenEdgePanGestureRecognizer){
        
        var translate = sender.translationInView(self.view)
        var newFrame = self.sideBar.frame
        newFrame.origin.x += translate.x
        newFrame.origin.x += self.sideBar.frame.width
        
        if newFrame.origin.x >= self.sideBar.frame.width {
            self.handleSideBar(0.0)
            self.addGesturePanToSideBar()
            return
        }
        
        self.sideBar.frame.origin.x += translate.x
        
        
        if(sender.state == UIGestureRecognizerState.Ended){
            if (self.sideBar.frame.origin.x >= (self.sideBar.frame.width/2.0 * -1)) {
                self.handleSideBar(0.0)
                self.addGesturePanToSideBar()
            }else{
                self.handleSideBar(self.sideBar.frame.width * -1)
                self.removeGesturePanToSideBar()                
            }
        } else {
            sender.setTranslation(CGPointMake(0,0), inView: self.sideBar)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        self.searcher.text = nil
        return true
    }
    
    @IBAction func logout(sender: AnyObject) {
        PFUser.logOut()
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as AppDelegate
        self.navigationController!.dismissViewControllerAnimated(true,
            completion: nil)
        appDelegate.resetApp()
    }
}
