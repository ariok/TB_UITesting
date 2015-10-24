//
//  RobotDetailViewController.swift
//  TB_UITesting
//
//  Created by Yari D'areglia on 15/10/15.
//  Copyright © 2015 Yari D'areglia. All rights reserved.
//

import UIKit

class RobotDetailViewController: UIViewController {

    @IBOutlet var robotID_label:UILabel!
    @IBOutlet var robotName_label:UILabel!
    @IBOutlet var robotCharge_slider:UIProgressView!
    @IBOutlet var robotChargeAlert_label:UILabel!
    
    var robot:Robot!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = robot.name
        
        fillUIWithData()
        updateChargeStatus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fillUIWithData(){
        
        robotID_label.text = robot.id
        robotName_label.text = robot.name
        robotCharge_slider.progress = Float(robot.charge)/100.0
    }
    
    func updateChargeStatus(){
        
        if robot.hasLowBattery(){
            robotChargeAlert_label.hidden = false
            robotCharge_slider.tintColor = UIColor.redColor()
        }else {
            robotChargeAlert_label.hidden = true
        }
    }
}
