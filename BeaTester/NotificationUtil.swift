//
//  NotificationUtil.swift
//  HOAY
//
//  Created by HomeDevelopper on 2014/11/01.
//  Copyright (c) 2014年 井口陽介. All rights reserved.
//

import UIKit

class NotificationUtil: NSObject {
    class var sharedNotification : NotificationUtil
    {
        struct Singleton {
            static let instance = NotificationUtil()
        }
        return Singleton.instance
    }
    
    var Notification: UILocalNotification? = UILocalNotification()
    
    func reset(){
        UIApplication.shared.cancelAllLocalNotifications()
        print("NotifiReset")
    }
   
    func setNotificaton(_ pTitle: String, pDate: Date, pType: Int) {
        Notification!.alertBody = pTitle
        Notification!.fireDate = pDate
        
        switch pType {
        case 0:
            Notification!.repeatInterval = .day
            print("Day")
        case 1:
            Notification!.repeatInterval = .weekday
            print("Week")
        case 2:
            Notification!.repeatInterval = .month
            print("Month")
        case 3:
            Notification!.repeatInterval = .minute
            print("Minute")
        default: print("none")
        }
        UIApplication.shared.scheduleLocalNotification(Notification!)
        print(pTitle)
    }
    
     override init(){
        Notification? = UILocalNotification()
        Notification?.timeZone = TimeZone.autoupdatingCurrent
        Notification?.alertAction = "Open"
        Notification?.soundName = UILocalNotificationDefaultSoundName
    }
    
}
