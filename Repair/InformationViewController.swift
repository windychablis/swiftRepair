//
//  InformationViewController.swift
//  Repair
//
//  Created by 陈浩 on 2017/8/1.
//  Copyright © 2017年 chablis. All rights reserved.
//

import UIKit
import HandyJSON

class InformationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let repairCellId:String="repairCell"
    var equipment:EquipmentInfo!
    
    var headerView : RepairInfoView!
    @IBOutlet weak var tableView: UITableView!
    
    
    var detailVc:InfDetailViewController!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib.init(nibName: "RepairCell", bundle: nil), forCellReuseIdentifier: repairCellId)
        tableView.rowHeight=50
        tableView.separatorStyle=UITableViewCellSeparatorStyle.none
        tableView.backgroundColor=UIColor.clear
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
        //        let headerView=Bundle.main.loadNibNamed("RepairInfo", owner: nil, options: nil)?.first as! RepairInfoView
        //        headerView.equipmentInfo=equipment.clientinfo
        //        tableView.tableHeaderView=headerView
        //        let footerView=UIImageView(image: #imageLiteral(resourceName: "bk_footer"))
        //        tableView.tableFooterView=footerView
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section==0 ? 0: equipment.repairList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: repairCellId) as! RepairCell
        cell.repairData = equipment.repairList[indexPath.row]
        cell.backgroundColor=UIColor.clear
//        if indexPath.row==0 {
//            cell.backgroundView=UIImageView(image: #imageLiteral(resourceName: "bk_bg22"))
//            cell.backgroundColor=UIColor.clear
//        }else{
            cell.backgroundColor=UIColor.white
//            cell.backgroundView=nil
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view : UIView
        if section==0 {
            view=RepairInfoView()
            headerView=view as! RepairInfoView
            headerView.number=equipment.clientinfo.CLIENT_TYPE
            headerView.type=equipment.clientinfo.TERM_TYPE
            headerView.area=equipment.clientinfo.AREA_CODE
            headerView.date=equipment.clientinfo.TIMEVIEW
            headerView.area2=equipment.clientinfo.REMARK
            headerView.floor=equipment.clientinfo.FLOORNUM
            headerView.ip=equipment.clientinfo.CLIENT_IP
            headerView.remark=equipment.clientinfo.REMARK

        }else{
            view=TableHeaderView()
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section==0 ? 330 : 80
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return section==0 ? nil : UIImageView(image: #imageLiteral(resourceName: "bk_footer"))
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section==0 ? 0.1 : 15
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="detail" {
            detailVc=segue.destination as! InfDetailViewController
            detailVc.repair=sender as! EquipmentInfo.Repair
        }else if segue.identifier=="repair"{
            let vc=segue.destination as! ReportViewController
            vc.clientInfo=equipment.clientinfo
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "detail", sender: equipment.repairList[indexPath.row])
    }
    
    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

    func getData(){
        let soapManager=SoapManager()
        soapManager.setValue(equipment.clientinfo.CLIENT_TYPE, forKey: "clientType")
        soapManager.postRequest(SoapAction.Service.repairService.rawValue, action: SoapAction.ServiceAction.RepairServiceAction.EquimentInfoAction.rawValue,success: { (result) in
            self.equipment=JSONDeserializer<EquipmentInfo>.deserializeFrom(json: result, designatedPath: "data")
            self.tableView.reloadData()
        }) { (Error) in
            CHLog(Error)
        }
    }
    
}
