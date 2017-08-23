//

//  OrderedDictionary.swift

//  Repair

//

//  Created by 陈浩 on 2017/7/27.

//  Copyright © 2017年 chablis. All rights reserved.

//

import UIKit

struct OrderedDictionary<Tk: Hashable, Tv> {
    
    var keys: Array<Tk> = []
    
    var values: Dictionary<Tk,Tv> = [:]
    
    
    
    var count: Int {
        
        assert(keys.count == values.count, "Keys and values array out of sync")
        
        return self.keys.count;
        
    }
    
    
    
    // Explicitly define an empty initializer to prevent the default memberwise initializer from being generated
    
    init() {}
    
    
    
    subscript(index: Int) -> Tv? {
        
        get {
            
            let key = self.keys[index]
            
            return self.values[key]
            
        }
        
        set(newValue) {
            
            let key = self.keys[index]
            
            if (newValue != nil) {
                
                self.values[key] = newValue
                
            } else {
                
                self.values.removeValue(forKey: key)
                
                self.keys.remove(at: index)
                
            }
            
        }
        
    }
    
    
    
    subscript(key: Tk) -> Tv? {
        
        get {
            
            return self.values[key]
            
        }
        
        set(newValue) {
            
            if newValue == nil {
                
                self.values.removeValue(forKey: key)
                
                self.keys = self.keys.filter {$0 != key}
                
            } else {
                
                let oldValue = self.values.updateValue(newValue!, forKey: key)
                
                if oldValue == nil {
                    
                    self.keys.append(key)
                    
                }
                
            }
            
        }
        
    }
    
    
    
    var description: String {
        
        var result = "{\n"
        
        for _ in 0..<self.count {
            
            result += "[(i)]: (self.keys[i]) => (self[i])\n"
            
        }
        
        result += "}"
        
        return result
        
    }
    
    
    mutating func setValue(_ value: Any!, forKey key: String!){
        if (value != nil) {
            keys.append(key as! Tk)
            values[key as! Tk]=value as? Tv
            
        } else {
            
            self.values.removeValue(forKey: key as! Tk)
            
        }
    }
    
}
