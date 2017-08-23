//
//  QRCodeViewController.swift
//  Repair
//
//  Created by 陈浩 on 2017/8/21.
//  Copyright © 2017年 chablis. All rights reserved.
//

import UIKit
import AVFoundation

typealias ScanCompletionBlock = (String)->()


class QRCodeViewController: UIViewController {
    @IBOutlet weak var scanLineView: UIImageView!
    @IBOutlet weak var scanFrameView: UIImageView!
    @IBOutlet weak var marginToTop: NSLayoutConstraint!
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    /// 输入对象
    private lazy var input: AVCaptureDeviceInput? = {
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        return try? AVCaptureDeviceInput(device: device)
    }()
    /// 会话
    fileprivate lazy var session: AVCaptureSession = AVCaptureSession()
    /// 输出对象
    fileprivate lazy var output: AVCaptureMetadataOutput = {
        let out = AVCaptureMetadataOutput()
        
        // 1.获取屏幕的frame
        let viewRect = self.view.frame
        // 2.获取扫描容器的frame
        let containerRect = self.scanFrameView.frame
        let x = containerRect.origin.y / viewRect.height;
        let y = containerRect.origin.x / viewRect.width;
        let width = containerRect.height / viewRect.height;
        let height = containerRect.width / viewRect.width;
        // 3.设置输出对象解析数据时感兴趣的范围
        //         out.rectOfInterest = CGRect(x: x, y: y, width: width, height: height)
        
        return out
    }()
    
    /// 预览图层
    fileprivate lazy var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.session)
    /// 专门用于保存描边的图层
    fileprivate lazy var containerLayer: CALayer = CALayer()
    
    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        scanQRCode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation()
    }
    
    // MARK: - 内部控制方法
    private func scanQRCode()
    {
        // 1.判断输入能否添加到会话中
        if !session.canAddInput(input)
        {
            return
        }
        // 2.判断输出能够添加到会话中
        if !session.canAddOutput(output)
        {
            return
        }
        // 3.添加输入和输出到会话中
        session.addInput(input)
        session.addOutput(output)
        
        // 4.设置输出能够解析的数据类型
        // 注意点: 设置数据类型一定要在输出对象添加到会话之后才能设置
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        // 5.设置监听监听输出解析到的数据
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        // 6.添加预览图层
        view.layer.insertSublayer(previewLayer, at: 0)
        previewLayer.frame = view.bounds
        
        // 7.添加容器图层
        view.layer.addSublayer(containerLayer)
        containerLayer.frame = view.bounds
        
        // 8.开始扫描
        session.startRunning()
        
    }
    
    /// 开启冲击波动画
    private func startAnimation()
    {
        // 1.设置冲击波底部和容器视图顶部对齐
        marginToTop.constant = 0
        view.layoutIfNeeded()
        
        // 2.执行扫描动画
        UIView.animate(withDuration: 2.0) { () -> Void in
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.marginToTop.constant = self.scanFrameView.frame.height
            self.view.layoutIfNeeded()
        }
        
    }
    
}

extension QRCodeViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        // 1.取出选中的图片
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else
        {
            return
        }
        
        guard let ciImage = CIImage(image: image) else
        {
            return
        }
        
        // 2.从选中的图片中读取二维码数据
        // 2.1创建一个探测器
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyLow])
        // 2.2利用探测器探测数据
        let results = detector?.features(in: ciImage)
        // 2.3取出探测到的数据
        for result in results!
        {
            CHLog((result as! CIQRCodeFeature).messageString)
        }
        
        // 注意: 如果实现了该方法, 当选中一张图片时系统就不会自动关闭相册控制器
        picker.dismiss(animated: true, completion: nil)
    }
}

extension QRCodeViewController: AVCaptureMetadataOutputObjectsDelegate
{
    /// 只要扫描到结果就会调用
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {// 1.显示结果
//        let metadataObject:AVMetadataMachineReadableCodeObject = metadataObjects.first as! AVMetadataMachineReadableCodeObject
        clearLayers()
        session.stopRunning()
        self.view.layer.removeAllAnimations()
        // 2.拿到扫描到的数据
        guard let metadata = metadataObjects.last as? AVMetadataObject else
        {
            return
        }
        CHLog(metadata)
        // 通过预览图层将corners值转换为我们能识别的类型
        let objc = previewLayer.transformedMetadataObject(for: metadata)
        // 2.对扫描到的二维码进行描边
        drawLines(objc: objc as! AVMetadataMachineReadableCodeObject)
    }
    
    /// 绘制描边
    private func drawLines(objc: AVMetadataMachineReadableCodeObject)
    {
        
        // 0.安全校验
        guard let array = objc.corners else
        {
            return
        }
        
        // 1.创建图层, 用于保存绘制的矩形
        let layer = CAShapeLayer()
        layer.lineWidth = 2
        layer.strokeColor = UIColor.green.cgColor
        layer.fillColor = UIColor.clear.cgColor
        
        // 2.创建UIBezierPath, 绘制矩形
        let path = UIBezierPath()
        var point = CGPoint(x: 0, y: 0)
        var index = 0
        point = CGPoint(dictionaryRepresentation:array[index] as! CFDictionary)!
        index+=1
        // 2.1将起点移动到某一个点
        path.move(to: point)
        
        // 2.2连接其它线段
        while index < array.count
        {
            point = CGPoint(dictionaryRepresentation:array[index] as! CFDictionary)!
            path.addLine(to: point)
            index+=1
        }
        // 2.3关闭路径
        path.close()
        
        layer.path = path.cgPath
        // 3.将用于保存矩形的图层添加到界面上
        containerLayer.addSublayer(layer)
    }
    
    /// 清空描边
    private func clearLayers()
    {
        guard let subLayers = containerLayer.sublayers else
        {
            return
        }
        for layer in subLayers
        {
            layer.removeFromSuperlayer()
        }
    }
}
