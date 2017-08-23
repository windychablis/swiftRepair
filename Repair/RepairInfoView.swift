//
//  RepairInfoView.swift
//  Repair
//
//  Created by 陈浩 on 2017/8/2.
//  Copyright © 2017年 chablis. All rights reserved.
//

import UIKit

@IBDesignable
class RepairInfoView: UIView {
    @IBOutlet weak var lineView: UIView!
    
    
    @IBOutlet weak var numberView: UILabel!
    @IBOutlet weak var typeView: UILabel!
    @IBOutlet weak var areaView: UILabel!
    @IBOutlet weak var dateView: UILabel!
    @IBOutlet weak var areaView2: UILabel!
    @IBOutlet weak var floorView: UILabel!
    @IBOutlet weak var ipView: UILabel!
    @IBOutlet weak var remarkView: UILabel!
    
    var contentView: UIView!
    
    var _equipmentInfo : EquipmentInfo.Client!
    
    var equipmentInfo:EquipmentInfo.Client!{
        get{
            return _equipmentInfo
        }set{
            _equipmentInfo=newValue
            numberView.text=equipmentInfo.CLIENT_TYPE
            typeView.text=equipmentInfo.TERM_TYPE
            areaView.text=equipmentInfo.AREA_CODE
            dateView.text=equipmentInfo.TIMEVIEW
            areaView2.text=equipmentInfo.REMARK
            floorView.text=equipmentInfo.FLOORNUM
            ipView.text=equipmentInfo.CLIENT_IP
            remarkView.text=equipmentInfo.REMARK
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialFromXib()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialFromXib()
    }

    func initialFromXib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "RepairInfo", bundle: bundle)
        contentView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        contentView.frame = bounds
        addSubview(contentView)
        
    }
    
    override func awakeFromNib() {
//        contentView = Bundle.main.loadNibNamed("RepairInfo", owner: self, options: nil)?.first as! UIView
//        contentView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
//        self.addSubview(self.contentView)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func shapeLine(lineView:UIView){
//        let lineView:UIView = UIView(frame: CGRect(x: 0, y: 300, width: self.view.frame.width, height: 20))
//        self.view.addSubview(lineView)
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        
        shapeLayer.bounds = lineView.bounds
        
        shapeLayer.position = CGPoint(x: lineView.frame.width / 2, y: lineView.frame.height / 2)
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPhase = 0
        shapeLayer.lineDashPattern = [NSNumber(value: 5), NSNumber(value: 5)]
        
        let path:CGMutablePath = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 5))
        path.addLine(to: CGPoint(x: lineView.frame.width, y: 5))
        shapeLayer.path = path
        
        lineView.layer.addSublayer(shapeLayer)
    }
    
}
