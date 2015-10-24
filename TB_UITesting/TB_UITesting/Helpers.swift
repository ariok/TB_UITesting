//
//  Helpers.swift
//  TB_UITesting
//
//  Created by Yari D'areglia on 14/10/15.
//  Copyright © 2015 Yari D'areglia. All rights reserved.
//

import UIKit

func endPoint()->NSURL {
    
    if (NSProcessInfo.processInfo().arguments.contains("UI_TESTING_MODE")) {
        return NSURL(string: "http://localhost:4567")!
    }else{
        return NSURL(string: "http://www.example.com/api/")!
    }
}

func instantiateViewController(storyboardID:String)->UIViewController{
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    return storyboard.instantiateViewControllerWithIdentifier(storyboardID)
}

extension NSUserDefaults {
    
   static var accessToken:String? {
        
        get{
            return NSUserDefaults.standardUserDefaults().objectForKey("AccessToken") as? String
        }
        set(token){
            NSUserDefaults.standardUserDefaults().setObject(token, forKey: "AccessToken")
        }
    }
}
