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
    var colourCell : [UIColor] = []
    var urlkey = "urls"
    var payloadkey = "payload"
    
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
        cell.backgroundColor = colourCell[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.textLabel?.textColor = UIColor.whiteColor()
        return cell
    }
    
    func fetchFavorites() {
    
        let def = NSUserDefaults.standardUserDefaults()
            
        var urlkey = "urls"
        var payloadkey = "payload"
        
        if let testArray : AnyObject? = def.objectForKey(urlkey) {
            if (testArray != nil){
                urlData = testArray! as [NSString]
            }else{
                urlData = [NSString]()
            }
        } else {
            urlData = [NSString]()
        }
            
        if let testArray : AnyObject? = def.objectForKey(payloadkey) {
            if (testArray != nil){
                payloadData  = testArray! as [NSString]
            }else{
                payloadData = [NSString]()
            }        } else {
            payloadData = [NSString]()
        }
        
        for data in payloadData {
            colourCell.append(randomColour())
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath   indexPath: NSIndexPath) {
        
        print(urlData[indexPath.row])
        var url = NSURL(string:urlData[indexPath.row])
        UIApplication.sharedApplication().openURL(url!)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            self.removeFavorite(indexPath.row)
        }
    }
    
    func removeFavorite(index: Int) {

        let def = NSUserDefaults.standardUserDefaults()
        
        self.urlData.removeAtIndex(index)
        self.payloadData.removeAtIndex(index)
        self.colourCell.removeAtIndex(index)
        
        def.setObject(urlData, forKey: urlkey)
        def.setObject(payloadData, forKey: payloadkey)
        def.synchronize()
        
        self.tableView.reloadData()
    }
    
    func randomColour() -> UIColor {
        
        let randomIndex = Int(arc4random_uniform(UInt32(self.colours.count)))
        return UIColor(hexString: self.colours[randomIndex])!
    }
}
