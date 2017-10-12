//
//  AreaViewController.swift
//  Repair
//
//  Created by 陈浩 on 2017/8/22.
//  Copyright © 2017年 chablis. All rights reserved.
//

import UIKit
typealias ParmesBlock = (CHPickerModel)->()

class CHPickerViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pickView: UIPickerView!
    var backBlock :ParmesBlock?
    var objs : [CHPickerModel]!
    var selectedObj : CHPickerModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //屏蔽containerView控件里面也触发touchesBegan事件
        let touch = (touches as NSSet).anyObject() as! UITouch
        let insideY=touch.location(in: containerView).y
        if insideY<0||insideY>containerView.frame.height {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        self.backBlock!(selectedObj)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return objs.count
    }
    
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return areas[row].name
//    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label=UILabel()
        label.font=UIFont.systemFont(ofSize: 16)
        label.textAlignment=NSTextAlignment.center
        label.sizeToFit()
        label.text=objs[row].name
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedObj=objs[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
}
