//
//  UIScrollView+Extension.swift
//  Repair
//
//  Created by 陈浩 on 2017/10/19.
//  Copyright © 2017年 chablis. All rights reserved.
//

import UIKit

extension UIScrollView{
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isMember(of: UIScrollView.self){
            self.next?.touchesBegan(touches, with: event)
            if super.responds(to: #selector(touchesBegan(_:with:))){
                super.touchesBegan(touches, with: event)
            }
        }
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isMember(of: UIScrollView.self){
            self.next?.touchesMoved(touches, with: event)
            if super.responds(to: #selector(touchesBegan(_:with:))){
                super.touchesMoved(touches, with: event)
            }
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isMember(of: UIScrollView.self){
            self.next?.touchesEnded(touches, with: event)
            if super.responds(to: #selector(touchesBegan(_:with:))){
                super.touchesEnded(touches, with: event)
            }
        }
    }
}
