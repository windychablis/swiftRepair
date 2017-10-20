//
//  AppDelegate.swift
//  Repair
//
//  Created by 陈浩 on 2017/7/25.
//  Copyright © 2017年 chablis. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var isLogin = CacheUtil.isLogin()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window=UIWindow(frame: UIScreen.main.bounds)
//        if isLogin {
//            let sb = UIStoryboard(name: "LoginView", bundle: nil)
//            let vc= sb.instantiateInitialViewController()!
//        }else{
//            
//            
//        }
//        let sb = isLogin ? UIStoryboard(name: "IndexView", bundle: nil) : UIStoryboard(name: "LoginView", bundle: nil)
        let sb = UIStoryboard(name: "LoginView", bundle: nil)
        let vc=sb.instantiateInitialViewController()!
        window?.rootViewController=vc
        window?.makeKeyAndVisible()
        

        return true
    }
    
    
}

func CHLog<T> (_ message:T,method:String=#function,line:Int=#line){
    #if DEBUG
        print("\(method)[\(line)]: \(message)")
    #endif
}
func showToast(controller : UIViewController, message: String, title: String = "提示"){
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    let btnOK = UIAlertAction(title: "好的", style: .default, handler: nil)
    alert.addAction(btnOK)
    controller.present(alert, animated: true, completion: nil)
}

