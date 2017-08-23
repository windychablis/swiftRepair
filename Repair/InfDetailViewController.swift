//
//  InfDetailViewController.swift
//  Repair
//
//  Created by 陈浩 on 2017/8/15.
//  Copyright © 2017年 chablis. All rights reserved.
//

import UIKit
import HandyJSON
import Kingfisher
import SKPhotoBrowser

class InfDetailViewController: UIViewController {
    let colum=4
    var repair:EquipmentInfo.Repair!
    var detail:EquipmentDetail!

    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var questionView: UILabel!
    @IBOutlet weak var bigCalssView: UILabel!
    @IBOutlet weak var smallClassView: UILabel!
    @IBOutlet weak var dateView: UILabel!
    @IBOutlet weak var statusView: UILabel!
    @IBOutlet weak var resultView: UILabel!
    
    @IBOutlet weak var imageView1: UIView!
    @IBOutlet weak var imageView2: UIView!
    
    @IBOutlet weak var imageView1Height: NSLayoutConstraint!
    @IBOutlet weak var imageView2Height: NSLayoutConstraint!
    
    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    @IBOutlet weak var gView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getRepairList()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    func getRepairList(){
        CHProgressHUD.showWithText("查询中...")
        let soapManager=SoapManager()
        soapManager.setValue(repair.MAINTAIN_ID, forKey: "mainTainId")
        soapManager.postRequest(SoapAction.Service.repairService.rawValue, action: SoapAction.ServiceAction.RepairServiceAction.EquimentDetailAction.rawValue,success: { (result) in
            CHProgressHUD.dismissHUD()
            self.detail=JSONDeserializer<EquipmentDetail>.deserializeFrom(json: result, designatedPath: "data")
            self.titleView.text=self.detail.clientInfo.TITLE
            self.questionView.text=self.detail.clientInfo.PROBLEMDTION
            self.bigCalssView.text=self.detail.clientInfo.BIGCLASS
            self.smallClassView.text=self.detail.clientInfo.SMALLCLASS
            self.dateView.text=self.detail.clientInfo.TIMEVIEW
            self.statusView.text=self.detail.clientInfo.STATUS=="0" ? "未维修" : "已维修"
            self.resultView.text=self.detail.clientInfo.SERVICERESULT
            self.addImages()
        }) { (Error) in
            CHLog(Error)
            CHProgressHUD.dismissHUD()
        }
    }

    
    func addImages(){
//        let width=70
//        let magin=(Int(imageView1.frame.width) - colum * width)/3
        let margin = 20
        let width = (Int (UIScreen.main.bounds.width) - 32 - margin*(colum-1))/colum

        let count = detail.dePiclist.count
        let count2=detail.resultPiclist.count
        imageView1Height.constant = CGFloat(count==0 ? 0 : width)
        imageView2Height.constant = CGFloat(count2==0 ? 0 : width)
        
        for i in 0..<count {
            let x=i % colum * (width+margin)
            let imageView=UIImageView(frame: CGRect(x: x, y: 0, width: width, height: width))
            let url = URL(string: self.detail.dePiclist[i].FILE_URL)
            imageView.ch_setCornerImage(url: url!, corner: 6)
            imageView.isUserInteractionEnabled=true
            let tap=UITapGestureRecognizer(target: self, action: #selector(toSeeBigImage(tap:)))
            imageView.addGestureRecognizer(tap)
            imageView1.addSubview(imageView)
        }
        
        for i in 0..<count2 {
            let x=i % colum * (width+margin)
            let imageView=UIImageView(frame: CGRect(x: x, y: 0, width: width, height: width))
            let url = URL(string: self.detail.resultPiclist[i].FILE_URL)
            imageView.ch_setCornerImage(url: url!, corner: 6)
            imageView.isUserInteractionEnabled=true
            let tap=UITapGestureRecognizer(target: self, action: #selector(toSeeBigImage(tap:)))
            imageView.addGestureRecognizer(tap)
            imageView2.addSubview(imageView)
        }
    }

    
    func toSeeBigImage(tap:UITapGestureRecognizer){
        let url=(tap.view as! UIImageView).kf.webURL?.absoluteString
        var images = [SKPhoto]()
        let photo = SKPhoto.photoWithImageURL(url!)
        photo.shouldCachePhotoURLImage = false // you can use image cache by true(NSCache)
        images.append(photo)
        
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
        SKPhotoBrowserOptions.displayToolbar=false
        SKPhotoBrowserOptions.displayCloseButton=false
        SKPhotoBrowserOptions.enableSingleTapDismiss=true
        present(browser, animated: true, completion: nil)
    }
    

}
