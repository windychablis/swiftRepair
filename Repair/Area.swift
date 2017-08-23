//
//  Area.swift
//  Repair
//
//  Created by 陈浩 on 2017/7/25.
//  Copyright © 2017年 chablis. All rights reserved.
//

import UIKit
import HandyJSON

class Area: HandyJSON {
    required init() {
    }
    /**
     * isParent : true
     * areaCode : 110105000000
     * id : 110105000000
     * open : true
     * name : 北京市朝阳区行政服务中心
     * pId : 110100000000
     */
    var isParent : Bool!
    var areaCode : String!
    var id : String!
    var open : Bool!
    var name : String!
    var pId : String!
    
}
