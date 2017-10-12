//
//  BreakType.swift
//  Repair
//
//  Created by 陈浩 on 2017/10/12.
//  Copyright © 2017年 chablis. All rights reserved.
//

import UIKit
import HandyJSON

class BreakType: CHPickerModel {
    required init() {
    }
    
    var bigClassList:[ClassType]!
    var smallClassList:[ClassType]!
    
    class ClassType: CHPickerModel {
        required init() {
        }
        /**
         * DICT_ID : 设备故障编号
         */
        
        var id: String!
        /**
         * DICT_NAME : 设备故障名称
         */
        override func mapping(mapper: HelpingMapper) {
            // 指定 id 字段用 "cat_id" 去解析
            mapper.specify(property: &id, name: "DICT_ID")
            mapper.specify(property: &name, name: "DICT_NAME")
            
        }
    }
 
}
