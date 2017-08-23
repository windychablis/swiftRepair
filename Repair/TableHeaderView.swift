//
//  TableHeaderView.swift
//  Repair
//
//  Created by 陈浩 on 2017/8/8.
//  Copyright © 2017年 chablis. All rights reserved.
//

import UIKit

@IBDesignable
class TableHeaderView: UIView {
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
    @IBInspectable     //属性可是化设置的关键字
    var title:String = "标题"{
        didSet{//设置属性观察器，保证实时改变
            titleView.text = title
        }
    }
    @IBInspectable
    var image:String = "maintenance"{
        didSet{//设置属性观察器，保证实时改变
            titleImage.image=UIImage.init(named: image)
        }
    }
    
    var contentView: UIView!

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialFromXib()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialFromXib()
//        lineView.backgroundColor=UIColor(patternImage: #imageLiteral(resourceName: "line"))
    }
    
    func initialFromXib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TableHeaderView", bundle: bundle)
        contentView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        contentView.frame = bounds
        addSubview(contentView)
        
    }

    func shapeLine(lineView:UIView){
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
