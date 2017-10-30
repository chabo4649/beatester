//
//  UserDefaultsUtil.swift
//  HOAY
//
//  Created by HomeDevelopper on 2014/10/01.
//  Copyright (c) 2014年 井口陽介. All rights reserved.
//

import UIKit

class UserDefaultsUtil: NSObject {
    //Setter
    class func setBoolValue(_ pKey: String, pItem: Bool){
        let ud: UserDefaults = UserDefaults()
        ud.set(pItem, forKey: pKey)
        ud.synchronize()
    }
    
    class func setStringValue(_ pKey: String, pItem: String){
        let ud: UserDefaults = UserDefaults()
        ud.setValue(pItem, forKey: pKey)
        ud.synchronize()
    }
    
    class func setIntValue(_ pKey: String, pItem: Int){
        let ud: UserDefaults = UserDefaults()
        ud.set(pItem, forKey: pKey)
        ud.synchronize()
    }
    
    class func setFloatlValue(_ pKey: String, pItem: Float){
        let ud: UserDefaults = UserDefaults()
        ud.set(pItem, forKey: pKey)
        ud.synchronize()
    }
    
    class func setObject(_ pKey: String, pItem: AnyObject){
        let ud: UserDefaults = UserDefaults()
        ud.set(pItem, forKey: pKey)
        ud.synchronize()
    }
    
    //Getter
    class func getBoolValue(_ pKey: String)->Bool{
        let ud: UserDefaults = UserDefaults()
        return ud.bool(forKey: pKey)
    }
    
    class func getStringValue(_ pKey: String)->AnyObject?{
        let ud: UserDefaults = UserDefaults()
        return ud.value(forKey: pKey) as AnyObject?
    }
    
    class func getIntValue(_ pKey: String)->Int{
        let ud: UserDefaults = UserDefaults()
        return ud.integer(forKey: pKey)
    }
    class func getFloatlValue(_ pKey: String)->Float{
        let ud: UserDefaults = UserDefaults()
        return ud.float(forKey: pKey)
    }
    
    class func getDate(_ pKey: String)->Date!{
        let ud: UserDefaults = UserDefaults()
        let result = ud.object(forKey: pKey) as? Date
        if (result == nil){
            return Date()
        }else{
            return result!
        }
    }
    
    class func getObject(_ pKey: String)->AnyObject?{
        let ud: UserDefaults = UserDefaults()
        return ud.object(forKey: pKey) as AnyObject?
    }
}
