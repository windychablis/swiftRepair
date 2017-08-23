//
//  SearchViewController.swift
//  Repair
//
//  Created by 陈浩 on 2017/7/31.
//  Copyright © 2017年 chablis. All rights reserved.
//

import UIKit
import HandyJSON
import AVFoundation


class SearchViewController: UIViewController{
    var equipment: EquipmentInfo!
    @IBOutlet weak var scanButton: TBButton!
    
    @IBOutlet weak var deviceTextField: UITextField!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        deviceTextField.setValue(UIColor.white, forKeyPath: "placeholderLabel.textColor")
    }
    
    @IBAction func search(_ sender: UIButton) {
        CHProgressHUD.showWithText("查询中...")
        let number=deviceTextField.text
        if (number?.isEmpty)! {
            return
        }
        let soapManager=SoapManager()
        soapManager.setValue(number, forKey: "clientType")
        soapManager.postRequest(SoapAction.Service.repairService.rawValue, action: SoapAction.ServiceAction.RepairServiceAction.EquimentInfoAction.rawValue,success: { (result) in
            CHProgressHUD.dismissHUD()
            self.equipment=JSONDeserializer<EquipmentInfo>.deserializeFrom(json: result, designatedPath: "data")
            self.performSegue(withIdentifier: "search", sender: nil)
        }) { (Error) in
            CHLog(Error)
            CHProgressHUD.dismissHUD()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="search"{
        let vc=segue.destination as! InformationViewController
        vc.equipment=self.equipment
        }
    }
    @IBAction func scan(_ sender: UIButton) {
        
    }
    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    

}
