//
//  Robot.swift
//  TB_UITesting
//
//  Created by Yari D'areglia on 17/10/15.
//  Copyright © 2015 Yari D'areglia. All rights reserved.
//

import Foundation

class Robot {
    let id:String
    let name:String
    let charge:Int
    
    // MARK: Initializers 
    
    init(id:String, name:String, charge:Int){
        
        self.id = id
        self.name = name
        self.charge = charge
    }
    
    convenience init?(JSON:[String:AnyObject]){
        guard let _id = JSON["id"] as? String,
              let _name = JSON["name"] as? String,
              let _charge = JSON["charge"] as? Int else {
                
              return nil
        }
        
        self.init(id:_id, name:_name, charge:_charge)
    }
    
    // MARK: Logics 
    
    func hasLowBattery()->Bool {
        return charge <= 20
    }
    
}