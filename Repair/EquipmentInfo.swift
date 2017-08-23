//
//  EquimentInfo.swift
//  Repair
//
//  Created by 陈浩 on 2017/8/1.
//  Copyright © 2017年 chablis. All rights reserved.
//

import UIKit
import HandyJSON

class EquipmentInfo: HandyJSON {
    required init() {
    }
    var repairList:[Repair]!
    var clientinfo:Client!
    
    class Client:HandyJSON{
        required init() {
        }
        var AREA_CODE : String!
        var CLIENT_IP:String!
        var CLIENT_TYPE:String!
        var CODE:String!
        var FLOOR:Int!
        var FLOORNUM:String!
        var REMARK:String!
        var TERM_ID:String!
        var TERM_TYPE:String!
        var TIMEVIEW:String!
    }
    
    
    class Repair:HandyJSON{
        required init() {
        }
        var BIGCLASS:String!
        var CLIENT_TYPE:String!
        var MAINTAIN_ID:String!
        var REPAIRDATE:String!
        var SMALLCLASS:String!
        var STATUS:String!
        var TITLE:String!
    }
}
