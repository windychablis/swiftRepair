//
//  SoapManager.swift
//  Repair
//
//  Created by 陈浩 on 2017/7/27.
//  Copyright © 2017年 chablis. All rights reserved.
//

import UIKit
import Alamofire
import HandyJSON

//请求成功的回调
typealias SuccessBlock = (String)->()
//请求失败的回调
typealias FaiureBlock = (String)->()

class SoapManager: NSObject,XMLParserDelegate {
    
    var         webData:                    NSMutableData!
    var         currentService:             String = String()
    var         currentAction:              String = String()
    var         successBlock:               SuccessBlock?
    var         faiureBlock:                 FaiureBlock?
    var json : String?
    var paramDict : OrderedDictionary<String, Any>?
    
    /// 创建单例
    static let shareInstance : SoapManager = {
        let tools = SoapManager()
        return tools
    }()
    
    public func postRequest(_ service:String,action:String,success:@escaping SuccessBlock,faiure:@escaping FaiureBlock){
        self.successBlock = success
        
        self.faiureBlock = faiure
        
        self.currentService = service
        
        self.currentAction = action
        
        let URL = getURL(service, action: action)
        
        let soapMsg:String = toSoapMessage(action: action)
        
        let urlRequest: URLRequest = getURLRequest(action, URL: URL, soapMsg: soapMsg)
        
        
        Alamofire.request(urlRequest).responseData { response in
            
            if response.result.isSuccess{
                if self.successBlock != nil{
                    let data=response.data
//                    let str=String.init(data: data!, encoding: .utf8)
//                    CHLog(str!)
                    //1.创建NSXMLParser
                    let xmlParser = XMLParser(data: data!)
                    //2.设置代理
                    xmlParser.delegate=self
                    //3.开始解析
                    xmlParser.parse()
//                    successful(response.data! as NSData)
                }
            }else{
                print("请求数据失败----》\(response.result.error.debugDescription)")
                self.faiureBlock!(response.result.error!.localizedDescription)
            }
        }
    }
    
    private func getURLRequest(_ action:String,URL:Foundation.URL,soapMsg:String)->URLRequest{
        var request:URLRequest = URLRequest(url: URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 1)
        request.setValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let soapAction = kNameSpace+action
        request.setValue(soapAction, forHTTPHeaderField: "SOAPAction")
        request.setValue("\(soapMsg.characters.count)", forHTTPHeaderField: "Content-Length")
        request.httpMethod = "POST"
        request.httpBody = soapMsg.data(using: String.Encoding.utf8)
        
        return request
    }
    
    private func getURL(_ service:String,action:String)->URL{
        let urlStr = kURLHeader+service
        return NSURL(string: urlStr)! as URL
    }
    
    private    func toSoapMessage(action: String) -> String {
        var message: String = String()
        message += "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
        message += "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:web=\"http://webservice.egs.lilosoft.com/\">"
        message += "<soapenv:Header/>"
        message += "<soapenv:Body>"
        message += "<web:\(action)>"
        if paramDict != nil {
            for key in (paramDict?.keys)! {
                message += "<\(key)>\((paramDict?[key])!)</\(key)>"
                //            CHLog("key:\(key)    value:\((paramDict?[key])!)")
            }
        }
        message += "</web:\(action)>"
        message += "</soapenv:Body>"
        message += "</soapenv:Envelope>"
        return message
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        json=""
//        CHLog("开始解析xml")
    }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        //移除空格和空行
        let str=string.trimmingCharacters(in: .whitespacesAndNewlines)
        json!+=str
        //        let str = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
//        CHLog("解析完毕")
        let response=JSONDeserializer<Response>.deserializeFrom(json: json!)
        if response?.code==0{
            successBlock!(json!)
        }else{
            faiureBlock!((response?.message)!)
        }
        
//        CHLog(json!)
    }
    
    
    override func setValue(_ value: Any?, forKey key: String) {
//        super.setValue(value, forKey: key)
        if paramDict==nil {
            paramDict=OrderedDictionary()
        }
        paramDict?.setValue(value, forKey: key)
    }
    
}

