//
//  RepairDetailViewController.swift
//  Repair
//
//  Created by 陈浩 on 2017/10/16.
//  Copyright © 2017年 chablis. All rights reserved.
//

import UIKit
import ZLPhotoBrowser
import HandyJSON
import SKPhotoBrowser

class RepairDetailViewController: UIViewController,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate {
    let colum=4
    var repair:EquipmentInfo.Repair!
    var equimentInfo : EquipmentDetail!
    
    @IBOutlet weak var adviceTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var questionImagesView: UIView!
    @IBOutlet weak var imageViewHeightCons: NSLayoutConstraint!
    
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var questionView: UILabel!
    
    @IBOutlet weak var headerView: RepairInfoView!
    @IBOutlet weak var repairImagesView: UICollectionView!
    var images : [UIImage] = []
    var lastSelectPhotos : [UIImage]!
    var lastSelectAssets : [PHAsset]!
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.keyboardDismissMode=UIScrollViewKeyboardDismissMode.onDrag
        initCollectionView()
        getRepairDetail()
    }
    
    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func doRepair(_ sender: UIButton) {
        uploadImage()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    //MARK: 获取数据
    func getRepairDetail(){
        CHProgressHUD.showWithText("查询中...")
        let soapManager=SoapManager()
        soapManager.setValue(repair.MAINTAIN_ID, forKey: "mainTainId")
        soapManager.postRequest(SoapAction.Service.repairService.rawValue, action: SoapAction.ServiceAction.RepairServiceAction.EquimentDetailAction.rawValue,success: { (result) in
            CHProgressHUD.dismissHUD()
            self.equimentInfo=JSONDeserializer<EquipmentDetail>.deserializeFrom(json: result, designatedPath: "data")!
            self.initData()
        }) { (Error) in
            CHLog(Error)
            CHProgressHUD.dismissHUD()
        }
    }
    
    func initData(){
        headerView.number=equimentInfo.clientInfo.CLIENT_TYPE
        headerView.type=equimentInfo.clientInfo.TERMTYPE
        headerView.area=equimentInfo.clientInfo.AREA_CODE
        headerView.date=equimentInfo.clientInfo.TIMEVIEW
        headerView.area2=equimentInfo.clientInfo.REMARK
        headerView.floor=equimentInfo.clientInfo.FLOORNUM
        headerView.ip=equimentInfo.clientInfo.CLIENT_IP
        headerView.remark=equimentInfo.clientInfo.REMARK
        titleView.text=equimentInfo.clientInfo.TITLE
        questionView.text=equimentInfo.clientInfo.PROBLEMDTION
        addImages()
    }
    
    func addImages(){
        //        let width=70
        //        let magin=(Int(imageView1.frame.width) - colum * width)/3
        let margin = 20
        let width = (Int (UIScreen.main.bounds.width) - 32 - margin*(colum-1))/colum
        
        let count = equimentInfo.dePiclist.count
        imageViewHeightCons.constant = CGFloat(count==0 ? 0 : width)
        
        for i in 0..<count {
            let x=i % colum * (width+margin)
            let imageView=UIImageView(frame: CGRect(x: x, y: 0, width: width, height: width))
            let url = URL(string: self.equimentInfo.dePiclist[i].FILE_URL)
            imageView.ch_setCornerImage(url: url!, corner: 6)
            imageView.isUserInteractionEnabled=true
            let tap=UITapGestureRecognizer(target: self, action: #selector(toSeeBigImage(tap:)))
            imageView.addGestureRecognizer(tap)
            questionImagesView.addSubview(imageView)
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
    
    
    //MARK: 上传图片
    func uploadImage(){
        //将所有选择的图片都转换base64并且用逗号隔开
        if lastSelectPhotos==nil {
            showToast(controller:self,message: "请选择图片上传")
            return
        }
        var images = Array<String>()
        for image in lastSelectPhotos {
            let base64Image = image.resetSizeOfImageData(maxSize: 2000).toBase64String()
            //            let base64Image=image.base64()
            images.append(base64Image)
        }
        let urls=images.joined(separator: ",")
        
        //上传图片
        CHProgressHUD.showWithText("上传中...")
        let soapManager=SoapManager()
        soapManager.setValue("repair/image", forKey: "folder")
        soapManager.setValue(2, forKey: "type")
        soapManager.setValue(urls, forKey: "file")
        soapManager.setValue("temp.jpg", forKey: "fileName")
        soapManager.setValue(repair.MAINTAIN_ID, forKey: "mainTainId")
        soapManager.postRequest(SoapAction.Service.repairService.rawValue, action: SoapAction.ServiceAction.RepairServiceAction.UploadImages.rawValue,success: { (result) in
            let mainTain=JSONDeserializer<EquipmentInfo.MainTain>.deserializeFrom(json: result, designatedPath: "data")!
            self.uploadRepair(id: mainTain.mainTainId)
        }) { (Error) in
            showToast(controller: self, message: "网络超时")
            CHProgressHUD.dismissHUD()
        }
    }
    
    func uploadRepair(id:String){
        let text=adviceTextField.text
        let soapManager=SoapManager()
        soapManager.setValue(text, forKey: "serverResult")
        soapManager.setValue(user.User_ID, forKey: "disposeUserId")
        soapManager.setValue(id, forKey: "mainTainId")
        soapManager.postRequest(SoapAction.Service.repairService.rawValue, action: SoapAction.ServiceAction.RepairServiceAction.UploadRepairInfo.rawValue,success: { (result) in
            CHProgressHUD.dismissHUD()
            self.dismiss(animated: true, completion: nil)
        }) { (Error) in
            showToast(controller: self, message: "网络超时")
            CHProgressHUD.dismissHUD()
        }
    }
    
    
    //MARK: 分割线-------------
    
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
            self.repairImagesView.reloadData()
        }
        return sheet
    }
    
    func initCollectionView(){
        let width = repairImagesView.frame.width
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (width-9)/4, height: (width-9)/4)
        layout.minimumInteritemSpacing = 1.5;
        layout.minimumLineSpacing = 1.5;
        layout.sectionInset = UIEdgeInsetsMake(3, 0, 3, 0);
        self.repairImagesView.collectionViewLayout = layout;
        self.repairImagesView.backgroundColor = UIColor.white
        self.repairImagesView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
    
    
}
