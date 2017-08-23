//
//  CHProgressHUD.swift
//  Repair
//
//  Created by 陈浩 on 2017/7/28.
//  Copyright © 2017年 chablis. All rights reserved.
//

import UIKit
import SVProgressHUD

class CHProgressHUD: NSObject {

    class func showWithText(_ text:String){
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: text)
    }
    
    class func dismissHUD(){
        SVProgressHUD.dismiss()
    }

}
