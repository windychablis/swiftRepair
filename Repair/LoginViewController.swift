//
//  LoginViewController.swift
//  Repair
//
//  Created by 陈浩 on 2017/7/26.
//  Copyright © 2017年 chablis. All rights reserved.
//

import UIKit
import HandyJSON

//全局属性
//var user = {()->UserInfo in
//    print("空的")
//    return UserInfo()
//}()

class LoginViewController: UIViewController ,UITextFieldDelegate{
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    var isLogin = CacheUtil.isLogin()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameField.setValue(UIColor.white, forKeyPath: "placeholderLabel.textColor")
        
        passwordField.setValue(UIColor.white, forKeyPath: "placeholderLabel.textColor")
    }
    
    override func loadView() {
        super.loadView()
        if isLogin {
            autoLogin()
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    @IBAction func login() {
        CHProgressHUD.showWithText("正在登录...")
        
        let username=usernameField.text
        let password = passwordField.text
        if (username?.isEmpty)!||(password?.isEmpty)! {
            showError(errorText: "用户名或密码不能为空")
            return
        }
        
        let soapManager=SoapManager()
        soapManager.setValue(username!, forKey: "loginName")
        soapManager.setValue(password!.MD5(), forKey: "passWord")
        soapManager.postRequest(SoapAction.Service.loginService.rawValue, action: SoapAction.ServiceAction.LoginServiceAction.LogonAction.rawValue, success: { (result) in
            user=JSONDeserializer<UserInfo>.deserializeFrom(json: result, designatedPath: "data")!
            CHProgressHUD.dismissHUD()
            //保存用户信息
            CacheUtil.saveUserInfo(username: username!, password: password!)
            let sb=UIStoryboard(name: "IndexView", bundle: nil)
            let vc=sb.instantiateInitialViewController()
            self.present(vc!, animated: true, completion: nil)
        }) { (error) in
            CHProgressHUD.dismissHUD()
            self.showError(errorText: "用户名或密码错误")
        }
        
    }
    
    func autoLogin(){
        let userInfo = CacheUtil.getUserInfo()
        let soapManager=SoapManager()
        let password=userInfo["password"] as! String
        soapManager.setValue(userInfo["username"], forKey: "loginName")
        soapManager.setValue(password.MD5(), forKey: "passWord")
        soapManager.postRequest(SoapAction.Service.loginService.rawValue, action: SoapAction.ServiceAction.LoginServiceAction.LogonAction.rawValue, success: { (result) in
            user=JSONDeserializer<UserInfo>.deserializeFrom(json: result, designatedPath: "data")
            CHProgressHUD.dismissHUD()
            let sb=UIStoryboard(name: "IndexView", bundle: nil)
            let vc=sb.instantiateInitialViewController()
            self.present(vc!, animated: false, completion: nil)
        }) { (error) in
            CHProgressHUD.dismissHUD()
            self.showError(errorText: "用户名或密码错误")
        }
    }
    
    func showError(errorText:String){
        let alertController=UIAlertController(title: "登录失败", message: errorText, preferredStyle: UIAlertControllerStyle.alert)
        let action=UIAlertAction(title: "确定", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField==usernameField {
            passwordField.becomeFirstResponder()
        }else if(textField==passwordField){
            login()
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

var user:UserInfo!
