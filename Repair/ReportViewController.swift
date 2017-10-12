//
//  ReportViewController.swift
//  Repair
//
//  Created by 陈浩 on 2017/8/23.
//  Copyright © 2017年 chablis. All rights reserved.
//

import UIKit
import ZLPhotoBrowser
import HandyJSON

class ReportViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate {
    
    @IBOutlet weak var imagesView: UICollectionView!
    var images : [UIImage] = []
    var lastSelectPhotos : [UIImage]!
    var lastSelectAssets : [PHAsset]!
    
    @IBOutlet weak var bigClassView: UIButton!
    @IBOutlet weak var smallClassView: UIButton!
    @IBOutlet weak var titleView: UITextField!
    @IBOutlet weak var questionView: UITextField!
    
    var breakType : BreakType!
    var currentBig : BreakType.ClassType!
    var currentSmall : BreakType.ClassType!
    override func viewDidLoad() {
        super.viewDidLoad()
        getClasses()
        //放到界面中去
        initCollectionView()
        
    }
    @IBAction func showBigClass(_ sender: UIButton) {
        let pick=CHPickerViewController(nibName: "CHPickerViewController", bundle: nil)
        pick.objs=breakType.bigClassList
        pick.selectedObj=breakType.bigClassList[0]
        currentBig=breakType.bigClassList[0]
        pick.backBlock={type in
            //回传选择的政务中心
            self.currentBig=type as! BreakType.ClassType
            self.bigClassView.setTitle(type.name, for: UIControlState.normal)
        }
        pick.modalPresentationStyle=UIModalPresentationStyle.custom
        present(pick, animated: true, completion: nil)
        
    }
    @IBAction func showSmallClass(_ sender: UIButton) {
        showClassesType(classType: 1)
    }
    
    func showClassesType(classType : Int){
        let pick=CHPickerViewController(nibName: "CHPickerViewController", bundle: nil)
        pick.objs=classType==0 ? breakType.bigClassList : breakType.smallClassList
        pick.selectedObj=pick.objs[0]
        if classType==0 {
            currentBig=pick.selectedObj as! BreakType.ClassType
        }else{
            currentSmall=pick.selectedObj as! BreakType.ClassType
        }
        
        pick.backBlock={type in
            //回传选择的政务中心
            if classType==0 {
                self.currentBig=type as! BreakType.ClassType
                self.bigClassView.setTitle(type.name, for: UIControlState.normal)
            }else{
                self.currentSmall=type as! BreakType.ClassType
                self.smallClassView.setTitle(type.name, for: UIControlState.normal)
            }
            
            
        }
        pick.modalPresentationStyle=UIModalPresentationStyle.custom
        present(pick, animated: true, completion: nil)
    }
    
    func getClasses(){
        CHProgressHUD.showWithText("查询中...")
        let soapManager=SoapManager()
        soapManager.postRequest(SoapAction.Service.repairService.rawValue, action: SoapAction.ServiceAction.RepairServiceAction.Classes.rawValue,success: { (result) in
            CHProgressHUD.dismissHUD()
            self.breakType=JSONDeserializer<BreakType>.deserializeFrom(json: result, designatedPath: "data")
            self.bigClassView.setTitle(self.breakType.bigClassList[0].name, for: UIControlState.normal)
            self.smallClassView.setTitle(self.breakType.smallClassList[0].name, for: UIControlState.normal)
        }) { (Error) in
            CHLog(Error)
            CHProgressHUD.dismissHUD()
        }
    }
    
    func getSheet() ->ZLPhotoActionSheet{
        let sheet = ZLPhotoActionSheet()
        sheet.maxPreviewCount=20
        sheet.maxSelectCount=4
        sheet.sender=self
        if self.lastSelectAssets != nil{
            sheet.arrSelectedAssets = (self.lastSelectAssets as NSArray).mutableCopy() as! NSMutableArray
        }
        
        sheet.selectImageBlock = { (images,assets,isOrg) in
            self.images = images
            self.lastSelectAssets = assets
            self.lastSelectPhotos = images
            self.imagesView.reloadData()
        }
        return sheet
    }
    
    func initCollectionView(){
//        let width = UIScreen.main.bounds.size.width
        let width = imagesView.frame.width
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (width-9)/4, height: (width-9)/4)
        layout.minimumInteritemSpacing = 1.5;
        layout.minimumLineSpacing = 1.5;
        layout.sectionInset = UIEdgeInsetsMake(3, 0, 3, 0);
        self.imagesView.collectionViewLayout = layout;
        self.imagesView.backgroundColor = UIColor.white
        self.imagesView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return datas.count>=0 && datas.count<3 ? datas.count+1 : datas.count
//        CHLog(images.count<4 ? images.count+1 : images.count)
        return images.count<4 ? images.count+1 : images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        if indexPath.row<images.count{
            cell.imageView.image=images[indexPath.row]
        }else{
            cell.imageView.image=#imageLiteral(resourceName: "iv_add")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //如果是最后一个，点击就打开选择照片，否则就查看照片
        let sheet = getSheet()
        if indexPath.row==images.count{
            sheet.showPreview(animated: true)
        }else{
            sheet.previewSelectedPhotos(lastSelectPhotos, assets: lastSelectAssets, index: indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = self.view.frame;
        var width = frame.width
        width = CGFloat(Int(width/4)-20)
        return CGSize(width: width, height: width)
    }
    

    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
        if textField == titleView {
            questionView.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
}
