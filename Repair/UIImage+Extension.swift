//
//  UIImage+Extension.swift
//  Repair
//
//  Created by 陈浩 on 2017/8/17.
//  Copyright © 2017年 chablis. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImage{
    func ch_drawRectWithRoundedCorner(radius: CGFloat) -> UIImage {
        let smallImg=reSizeImage(reSize: CGSize(width: 80, height: 80))
        let rect = CGRect(x:0, y:0, width:smallImg.size.width, height:smallImg.size.height)
        UIGraphicsBeginImageContextWithOptions(smallImg.size, false, UIScreen.main.scale)
        UIGraphicsGetCurrentContext()!.addPath(UIBezierPath(roundedRect: rect, cornerRadius: radius).cgPath)
        UIGraphicsGetCurrentContext()?.clip()
        smallImg.draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndPDFContext()
        
        return image!
    }
    /**
     *  重设图片大小
     */
    func reSizeImage(reSize:CGSize)->UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        self.draw(in: CGRect(x:0, y:0, width:reSize.width, height:reSize.height));
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
    
    /**
     *  等比率缩放
     */
    func scaleImage(scaleSize:CGFloat)->UIImage {
        let reSize = CGSize(width:self.size.width * scaleSize, height:self.size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }
}
extension UIImageView {
    
    func ch_addCorner(radius: CGFloat) {
        self.image = self.image?.ch_drawRectWithRoundedCorner(radius: radius)
    }
    
    func ch_setCornerImage(url:URL, corner:CGFloat){
        self.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.fade(1)),KingfisherOptionsInfoItem.processor(RoundCornerImageProcessor.init(cornerRadius: corner))], progressBlock: nil) { (image, error, cacheType, url) in
            self.image=image?.ch_drawRectWithRoundedCorner(radius: corner)
        }
    }
}
