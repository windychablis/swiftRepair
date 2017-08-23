//
//  ViewController.swift
//  Repair
//
//  Created by 陈浩 on 2017/7/25.
//  Copyright © 2017年 chablis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    public func getData(){
        let soapManager=SoapManager()
        soapManager.setValue("admin", forKey: "loginName")
        soapManager.setValue("96E79218965EB72C92A549DD5A330112", forKey: "passWord")
        soapManager.postRequest(SoapAction.Service.loginService.rawValue, action: SoapAction.ServiceAction.LoginServiceAction.LogonAction.rawValue, success: { (result) in
            CHLog(result)
        }) { (error) in
            CHLog(error)
        }
    }
    
    
}

