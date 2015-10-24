//
//  RobotListTableViewController.swift
//  TB_UITesting
//
//  Created by Yari D'areglia on 14/10/15.
//  Copyright © 2015 Yari D'areglia. All rights reserved.
//

import UIKit

class RobotListTableViewController: UITableViewController {
    
    let API = APIService(endPoint: endPoint())
    var robots = [Robot]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var robotListCall = APICall(path: "robots", method: Method.GET)
        robotListCall.authToken = NSUserDefaults.accessToken
            
        API.request(robotListCall) {
            (code, JSON) -> Void in
            switch code {
            case StatusCode.Ok:
                if let robotsData = JSON?["robots"] as? [[String:AnyObject]]{
                    for robotJSON in robotsData {
                        if let robot = Robot(JSON: robotJSON){
                            self.robots.append(robot)
                        }
                    }

                    self.tableView.reloadData()
                }
            default:
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.robots.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("robotcell", forIndexPath: indexPath)
        cell.textLabel?.text = robots[indexPath.row].name
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let detail_vc = instantiateViewController("robotDetail") as? RobotDetailViewController{
            detail_vc.robot = robots[indexPath.row]
            self.showViewController(detail_vc, sender: self)
        }
        
    }

    @IBAction func logout(){
        
        var robotListCall = APICall(path: "session", method: Method.DELETE)
        robotListCall.authToken = NSUserDefaults.accessToken
        
        API.request(robotListCall) {
            (code, JSON) -> Void in
            switch code {
            case StatusCode.Ok:
                NSUserDefaults.accessToken = nil
                self.dismissViewControllerAnimated(true, completion: nil)
                
            default:
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }

}
