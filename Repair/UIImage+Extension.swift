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
    //MARK: 图片压缩
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
    
    //MARK 图片转换base64
    func base64() ->String{
        // 将图片转化成Data
        let imageData = UIImagePNGRepresentation(self)
        
        // 将Data转化成 base64的字符串
        let imageBase64String = imageData?.base64EncodedString()
        return imageBase64String!
    }
    
    //MARK: 图片压缩到指定大小
    // MARK: - 降低质量
    func resetSizeOfImageData(maxSize: Int) -> NSData {
        
        //先判断当前质量是否满足要求，不满足再进行压缩
        var finallImageData = UIImageJPEGRepresentation(self,1.0)
        let sizeOrigin      = finallImageData?.count
        let sizeOriginKB    = sizeOrigin! / 1024
        if sizeOriginKB <= maxSize {
            return finallImageData! as NSData
        }
        
        //先调整分辨率
        var defaultSize = CGSize(width: 1024, height: 1024)
        let newImage = self.newSizeImage(size: defaultSize, source_image: self)
        
        finallImageData = UIImageJPEGRepresentation(newImage,1.0);
        
        //保存压缩系数
        let compressionQualityArr = NSMutableArray()
        let avg = CGFloat(1.0/250)
        var value = avg
        
        var i = 250
        repeat {
            i -= 1
            value = CGFloat(i)*avg
            compressionQualityArr.add(value)
        } while i >= 1
        
        
        /*
         调整大小
         说明：压缩系数数组compressionQualityArr是从大到小存储。
         */
        //思路：使用二分法搜索
        finallImageData = self.halfFuntion(arr: compressionQualityArr.copy() as! [CGFloat], image: newImage, sourceData: finallImageData!, maxSize: maxSize)
        //如果还是未能压缩到指定大小，则进行降分辨率
        while finallImageData?.count == 0 {
            //每次降100分辨率
            if defaultSize.width-100 <= 0 || defaultSize.height-100 <= 0 {
                break
            }
            defaultSize = CGSize(width: defaultSize.width-100, height: defaultSize.height-100)
            let image = self.newSizeImage(size: defaultSize, source_image: UIImage.init(data: UIImageJPEGRepresentation(newImage, compressionQualityArr.lastObject as! CGFloat)!)!)
            finallImageData = self.halfFuntion(arr: compressionQualityArr.copy() as! [CGFloat], image: image, sourceData: UIImageJPEGRepresentation(image,1.0)!, maxSize: maxSize)
        }
        
        return finallImageData! as NSData
    }
    
    // MARK: - 调整图片分辨率/尺寸（等比例缩放）
    func newSizeImage(size: CGSize, source_image: UIImage) -> UIImage {
        var newSize = CGSize(width: source_image.size.width, height: source_image.size.height)
        let tempHeight = newSize.height / size.height
        let tempWidth = newSize.width / size.width
        
        if tempWidth > 1.0 && tempWidth > tempHeight {
            newSize = CGSize(width: source_image.size.width / tempWidth, height: source_image.size.height / tempWidth)
        } else if tempHeight > 1.0 && tempWidth < tempHeight {
            newSize = CGSize(width: source_image.size.width / tempHeight, height: source_image.size.height / tempHeight)
        }
        
        UIGraphicsBeginImageContext(newSize)
        source_image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    // MARK: - 二分法
    func halfFuntion(arr: [CGFloat], image: UIImage, sourceData finallImageData: Data, maxSize: Int) -> Data? {
        var tempFinallImageData = finallImageData
        
        var tempData = Data.init()
        var start = 0
        var end = arr.count - 1
        var index = 0
        
        var difference = Int.max
        while start <= end {
            index = start + (end - start)/2
            
            tempFinallImageData = UIImageJPEGRepresentation(image, arr[index])!
            
            let sizeOrigin = tempFinallImageData.count
            let sizeOriginKB = sizeOrigin / 1024
            
            print("当前降到的质量：\(sizeOriginKB)\n\(index)----\(arr[index])")
            
            if sizeOriginKB > maxSize {
                start = index + 1
            } else if sizeOriginKB < maxSize {
                if maxSize-sizeOriginKB < difference {
                    difference = maxSize-sizeOriginKB
                    tempData = tempFinallImageData
                }
                if index<=0 {
                    break
                }
                end = index - 1
            } else {
                break
            }
        }
        return tempData
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
