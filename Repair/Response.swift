//
//  Response.swift
//  Repair
//
//  Created by 陈浩 on 2017/7/25.
//  Copyright © 2017年 chablis. All rights reserved.
//

import UIKit
import HandyJSON

class Response: HandyJSON {
    var code:Int?
    var data:String?
    var message:String?
    
    required init(){}
}
