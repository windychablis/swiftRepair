//
//  ImageCell.swift
//  DDD
//
//  Created by 陈浩 on 2017/9/21.
//  Copyright © 2017年 chablis. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    var imageView : UIImageView!
    var deleteImageView : UIImageView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.imageView=UIImageView()
        self.imageView.contentMode=UIViewContentMode.scaleAspectFill
        self.imageView.frame=self.contentView.bounds
        self.imageView.clipsToBounds=true
        self.imageView.image=#imageLiteral(resourceName: "iv_add")
        self.contentView.addSubview(self.imageView)
        
//        self.deleteImageView=UIImageView(frame: CGRect(x: self.bounds.size.width-30, y: 0, width: 30, height: 30))
//        self.deleteImageView.image=#imageLiteral(resourceName: "iv_delete")
//        self.contentView.addSubview(self.deleteImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
