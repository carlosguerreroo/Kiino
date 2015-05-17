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
    let colours = ["#F44336", "#E91E63", "#9C27B0", "#673AB7", "#3F51B5", "#2196F3",
        "#03A9F4", "#00BCD4", "#009688", "#4CAF50", "#8BC34A", "#CDDC39",
        "#FFC107", "#FF9800", "#FF5722", "#607D8B"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer.delegate = nil
        self.tableView.backgroundColor = self.randomColour()

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
        cell.backgroundColor = randomColour()
        cell.textLabel?.textColor = UIColor.whiteColor()
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
    
    func randomColour() -> UIColor {
        
        let randomIndex = Int(arc4random_uniform(UInt32(self.colours.count)))
        return UIColor(hexString: self.colours[randomIndex])!
    }
}
