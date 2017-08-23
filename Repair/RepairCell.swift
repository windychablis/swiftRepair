//
//  RepairCell.swift
//  Repair
//
//  Created by 陈浩 on 2017/8/2.
//  Copyright © 2017年 chablis. All rights reserved.
//

import UIKit

class RepairCell: UITableViewCell {
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var dateView: UILabel!
    @IBOutlet weak var statusView: UILabel!
    
    var _repairData : EquipmentInfo.Repair!
    
    var repairData:EquipmentInfo.Repair!{
        get{
            return _repairData
        }set{
            _repairData=newValue
            titleView.text=_repairData.TITLE.isEmpty ? _repairData.BIGCLASS+"|"+_repairData.SMALLCLASS : _repairData.TITLE
            dateView.text=_repairData.REPAIRDATE
            statusView.text=_repairData.STATUS=="0" ? "未维修" : "已维修"
        }
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
