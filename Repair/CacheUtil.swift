//
//  CacheUtil.swift
//  Repair
//
//  Created by 陈浩 on 2017/7/31.
//  Copyright © 2017年 chablis. All rights reserved.
//

import UIKit

class CacheUtil: NSObject {
    
    class func saveUserInfo(username:String,password:String){
        let defaults = UserDefaults.standard
        defaults.set(username, forKey: "username")
        defaults.set(password, forKey: "password")
    }
    
    class func getUserInfo() ->Dictionary<String, Any> {
        let defaults = UserDefaults.standard
        let username = defaults.value(forKey: "username")!
        let password = defaults.value(forKey: "password")!
        return ["username":username,"password":password]
    }
    
    class func removeUserInfo(){
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "username")
        defaults.removeObject(forKey: "password")
    }
    
    class func isLogin() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.value(forKey: "username") == nil ? false : true
    }
}
