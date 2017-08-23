//
//  EquipmentDetail.swift
//  Repair
//
//  Created by 陈浩 on 2017/8/16.
//  Copyright © 2017年 chablis. All rights reserved.
//

import UIKit
import HandyJSON

class EquipmentDetail: HandyJSON {
    required init() {
    }
    var clientInfo:ClientInfo!
    var resultPiclist:[RepairImage]!
    var dePiclist:[RepairImage]!
    
    class ClientInfo:HandyJSON{
        required init() {
        }
        var FLOORNUM : String!
        var TITLE:String!
        var SMALLCLASS:String!
        var BIGCLASS:String!
        var SERVICERESULT:String!
        var TIMEVIEW:String!
        var CLIENT_TYPE:String!
        var AREA_CODE:String!
        var STATUS:String!
        var MAINTAIN_ID:String!
        var AREACODE:String!
        var TERMTYPE:String!
        var REMARK:String!
        var TERM_TYPE:String!
        var CLIENT_IP:String!
        var PROBLEMDTION:String!
    }
    
    class RepairImage:HandyJSON{
        required init() {
        }
        var FILE_URL : String!
        var String:String!
    }
}
