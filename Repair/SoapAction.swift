//
//  SoapUtils.swift
//  Repair
//
//  Created by 陈浩 on 2017/7/27.
//  Copyright © 2017年 chablis. All rights reserved.
//

import Foundation
let kURLHeader = "http://27.17.62.40:8899/wisdomgov/ws/"

//请求的命名空间
let kNameSpace = "http://impl.webservice.egs.lilosoft.com/"
class SoapAction : NSObject{
    
    //服务地址
    enum Service:String {
        case loginService = "loginService"
        case repairService = "repairService"
    }
    
    //服务器接口地址
    enum ServiceAction{
        
        enum LoginServiceAction:String{
            case LogonAction = "LoginDo"
        }
        enum RepairServiceAction:String{
            case AllAreaAction = "queryAllArea"
            case EquimentInfoAction = "queryTainIdByClientType"
            case EquimentDetailAction="queryMainTainById"
            case MyRepairAction="queryListByRepairId"
            
            case Classes = "insertView"
        }
    }
}
