//
//  TBButton.swift
//  Repair
//
//  Created by 陈浩 on 2017/7/31.
//  Copyright © 2017年 chablis. All rights reserved.
//

import UIKit
@IBDesignable
class TBButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.titleLabel?.textAlignment=NSTextAlignment.center
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.titleLabel?.textAlignment=NSTextAlignment.center
    }

    override func layoutSubviews() {
        super.layoutSubviews()
//        self.imageView?.frame=CGRect(x: 0, y: 0, width: frame.width, height: (imageView?.frame.height)!)
//        self.titleLabel?.frame=CGRect(x: 0, y: (imageView?.frame.height)!, width: frame.width, height: frame.height-(titleLabel?.frame.origin.y)!)
        self.imageView?.frame.origin.y=0
        self.imageView?.frame.size.width=self.frame.width
        self.titleLabel?.frame.origin.x=0
        self.titleLabel?.frame.origin.y=(self.imageView?.frame.height)!
        self.titleLabel?.frame.size.height=self.frame.height-(titleLabel?.frame.origin.y)!
        self.titleLabel?.frame.size.width=self.frame.width
    }

}
