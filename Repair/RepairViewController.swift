//
//  RepairViewController.swift
//  Repair
//
//  Created by 陈浩 on 2017/10/16.
//  Copyright © 2017年 chablis. All rights reserved.
//

import UIKit
import HandyJSON

class RepairViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let repairCellId:String="repairCell"
    @IBOutlet weak var areaButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var areas : [Area]!
    var currentArea:Area!
    var repairList: [EquipmentInfo.Repair]!
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib.init(nibName: "RepairCell", bundle: nil), forCellReuseIdentifier: repairCellId)
        tableView.rowHeight=50
        tableView.separatorStyle=UITableViewCellSeparatorStyle.none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAreaList()
        self.getRepair(areaCode: "")
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
        if segue.identifier=="detail" {
            let vc=segue.destination as! RepairDetailViewController
            vc.repair=sender as! EquipmentInfo.Repair
        }
        
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
            self.getRepair(areaCode: self.currentArea.areaCode)
        }
        pick.modalPresentationStyle=UIModalPresentationStyle.custom
        present(pick, animated: true, completion: nil)
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
    
    func getRepair(areaCode:String){
        CHProgressHUD.showWithText("查询中...")
        let soapManager=SoapManager()
        soapManager.setValue(areaCode, forKey: "area_code")
        soapManager.postRequest(SoapAction.Service.repairService.rawValue, action: SoapAction.ServiceAction.RepairServiceAction.RepairAction.rawValue,success: { (result) in
            CHProgressHUD.dismissHUD()
            self.repairList=JSONDeserializer<EquipmentInfo.Repair>.deserializeModelArrayFrom(json: result, designatedPath: "data") as! [EquipmentInfo.Repair]
            self.tableView.reloadData()
        }) { (Error) in
            CHLog(Error)
            CHProgressHUD.dismissHUD()
        }
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
}
