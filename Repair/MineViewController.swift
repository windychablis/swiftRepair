//
//  MineViewController.swift
//  Repair
//
//  Created by 陈浩 on 2017/8/22.
//  Copyright © 2017年 chablis. All rights reserved.
//

import UIKit
import HandyJSON

class MineViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let repairCellId:String="repairCell"
    var areas : [Area]!
    var currentArea:Area!
    var repairList: [EquipmentInfo.Repair]!
    var detailVc:InfDetailViewController!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var areaButton: UIButton!
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    @IBAction func logout(_ sender: UIButton) {
        CacheUtil.removeUserInfo()
        let sb = UIStoryboard(name: "LoginView", bundle: nil)
        let vc=sb.instantiateInitialViewController()!
        present(vc, animated: false, completion: nil)
    }
    
    @IBAction func showAreaList(_ sender: UIButton) {
        let pick=CHPickerViewController(nibName: "CHPickerViewController", bundle: nil)
        pick.objs=areas
        pick.selectedObj=areas[0]
        currentArea=areas[0]
        pick.backBlock={area in
            //回传选择的政务中心
            self.currentArea=area as! Area
            self.areaButton.setTitle(area.name, for: UIControlState.normal)
            self.getMyRepair(areaCode: self.currentArea.areaCode)
        }
        pick.modalPresentationStyle=UIModalPresentationStyle.custom
        present(pick, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib.init(nibName: "RepairCell", bundle: nil), forCellReuseIdentifier: repairCellId)
        tableView.rowHeight=50
        tableView.separatorStyle=UITableViewCellSeparatorStyle.none
        getAreaList()
        getMyRepair(areaCode: "")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repairList==nil ? 0 : repairList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: repairCellId) as! RepairCell
        cell.repairData = repairList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "detail", sender: repairList[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        detailVc=segue.destination as! InfDetailViewController
        detailVc.repair=sender as! EquipmentInfo.Repair
    }
    
    
    func getAreaList(){
        CHProgressHUD.showWithText("查询中...")
        let soapManager=SoapManager()
        soapManager.postRequest(SoapAction.Service.repairService.rawValue, action: SoapAction.ServiceAction.RepairServiceAction.AllAreaAction.rawValue,success: { (result) in
            CHProgressHUD.dismissHUD()
            self.areas=JSONDeserializer<Area>.deserializeModelArrayFrom(json: result, designatedPath: "data") as! [Area]
            self.areaButton.setTitle(self.areas[0].name, for: UIControlState.normal)
        }) { (Error) in
            CHLog(Error)
            CHProgressHUD.dismissHUD()
        }
    }
    
    func getMyRepair(areaCode:String){
        
        CHProgressHUD.showWithText("查询中...")
        let soapManager=SoapManager()
        soapManager.setValue(user.User_ID, forKey: "repairUserId")
        soapManager.setValue(areaCode, forKey: "areaCode")
        soapManager.postRequest(SoapAction.Service.repairService.rawValue, action: SoapAction.ServiceAction.RepairServiceAction.MyRepairAction.rawValue,success: { (result) in
            CHProgressHUD.dismissHUD()
            self.repairList=JSONDeserializer<EquipmentInfo.Repair>.deserializeModelArrayFrom(json: result, designatedPath: "data") as! [EquipmentInfo.Repair]
            self.tableView.reloadData()
        }) { (Error) in
            CHLog(Error)
            CHProgressHUD.dismissHUD()
        }
    }
    
}
