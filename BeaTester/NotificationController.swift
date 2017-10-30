//
//  NotificationController.swift
//  HOAY
//
//  Created by HomeDevelopper on 2014/11/01.
//  Copyright (c) 2014年 井口陽介. All rights reserved.
//

import UIKit

class NotificationController: NSObject {
    
    class func setConfiglation() {
        //var notification = NotificationUtil.sharedNotification
        self.reset()
        self.setStandardNotification()
    }
    
    class fileprivate func reset() {
        let notification = NotificationUtil.sharedNotification
        notification.reset()
    }

    class fileprivate func setStandardNotification(){
        
        
        
    }
   
}
