//
//  ViewController.swift
//  Kiino
//
//  Created by Carlos Guerrero on 2/26/15.
//  Copyright (c) 2015 demo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var searcher: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searcher.delegate = self

    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        self.searcher.text = nil
        return true
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
        
        
        var alert = UIAlertController(title: nil, message: "Are you sure about that?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

}

