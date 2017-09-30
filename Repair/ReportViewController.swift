//
//  ReportViewController.swift
//  Repair
//
//  Created by 陈浩 on 2017/8/23.
//  Copyright © 2017年 chablis. All rights reserved.
//

import UIKit
import ZLPhotoBrowser

class ReportViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var imagesView: UICollectionView!
    var images : [UIImage] = []
    var lastSelectPhotos : [UIImage]!
    var lastSelectAssets : [PHAsset]!
    var sheet : ZLPhotoActionSheet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //放到界面中去
        initCollectionView()
        sheet = ZLPhotoActionSheet()
        sheet.maxPreviewCount=20
        sheet.maxSelectCount=4
        sheet.sender=self
        sheet.selectImageBlock = { (images,assets,isOrg) in
            self.images = images
            self.lastSelectAssets = assets
            self.lastSelectPhotos = images
            self.imagesView.reloadData()
        }
    }
    
    func initCollectionView(){
//        let width = UIScreen.main.bounds.size.width
        let width = imagesView.width
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
        if indexPath.row==images.count{
            resetAddImage()
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
    
    func resetAddImage(){
        CHLog("add")
        sheet.showPreview(animated: true)
    }
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
