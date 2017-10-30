//
//  iBeaconNotificationUtil.swift
//  iBeaconTest
//
//  Created by 井口陽介 on 2016/11/17.
//  Copyright © 2016年 井口陽介. All rights reserved.
//

import UIKit

class iBeaconNotificationUtil: NSObject {
    /**
     通知の許可を確認する
     */
    static func registerUserNotificationSettings() {
        let application = UIApplication.shared
        let type : UIUserNotificationType = [.alert, .badge, .sound]
        let settings = UIUserNotificationSettings(types: type, categories: nil)
        application.registerUserNotificationSettings(settings)
    }
    
    /**
     前回の通知から一定時間以上経過していればローカル通知を飛ばす
     
     - parameter message:  表示メッセージ
     */
    static func postLocalNotificationIfNeeded(message: String) {
        if !shouldNotifyWithMessage(message: message) {
            return
        }
        
        print(message)
        
        let application = UIApplication.shared
        application.cancelAllLocalNotifications()
        
        let notification = UILocalNotification()
        notification.alertBody = message
        notification.soundName = UILocalNotificationDefaultSoundName
        application.presentLocalNotificationNow(notification)
    }
    
    /**
     通知可否を返す。
     前回の通知から一定時間経過していれば通知可
     
     - parameter message: 表示メッセージ
     
     - returns: true:通知可/false:通知不可
     */
    private static func shouldNotifyWithMessage(message: String) -> Bool {
        let defaults = UserDefaults.standard
        let key = message
        let now = NSDate()
        let date = defaults.object(forKey: key)
        
        defaults.set(now, forKey: key)
        defaults.synchronize()
        
        if let date = date as? NSDate {
            let remainder = now.timeIntervalSince(date as Date)
            let interval = 10   // 2時間
            let threshold: TimeInterval = TimeInterval(interval)
            return (remainder > threshold)
        }
        
        return true
    }
}
