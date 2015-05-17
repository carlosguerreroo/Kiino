//
//  FavoritesTableViewController.swift
//  Kiino
//
//  Created by Carlos Guerrero on 5/17/15.
//  Copyright (c) 2015 demo. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController {


    var urlData : [NSString] = [];
    var payloadData : [NSString] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer.delegate = nil

        self.fetchFavorites()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urlData.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = payloadData[indexPath.row]

        return cell
    }
    
    func fetchFavorites() {
    
        let def = NSUserDefaults.standardUserDefaults()
            
        var urlkey = "urls"
        var payloadkey = "payload"
        var defaults = NSUserDefaults.standardUserDefaults()
            
        if let testArray : AnyObject? = defaults.objectForKey(urlkey) {
            urlData = testArray! as [NSString]
        } else {
            urlData = [NSString]()
        }
            
        if let testArray : AnyObject? = defaults.objectForKey(payloadkey) {
            payloadData  = testArray! as [NSString]
        } else {
            payloadData = [NSString]()
        }
        
    }
}
