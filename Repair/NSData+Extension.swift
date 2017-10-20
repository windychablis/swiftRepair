//
//  NSData+Extension.swift
//  Repair
//
//  Created by 陈浩 on 2017/10/12.
//  Copyright © 2017年 chablis. All rights reserved.
//

import UIKit

extension NSData{
    func toBase64String() ->String{
        return self.base64EncodedString()
    }
}
