//
//  SosialUtility.swift
//  EventMeister
//
//  Created by 井口陽介 on 2016/03/14.
//  Copyright © 2016年 井口陽介. All rights reserved.
//

import UIKit

class SosialUtility: NSObject{
    static func sendMessage(_ sender: UIViewController, pSubject: String, pMessage: String, pDispView: UIView, pTargetView: UIView){
        
        let activityItems = [pMessage]
        
        // 初期化処理
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityVC.setValue(pSubject, forKey: "subject")
        //activityVC.setValue("hoge@aaa.com", forKey: "")
        
        // 使用しないアクティビティタイプ
        let excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.print
        ]
        
        activityVC.excludedActivityTypes = excludedActivityTypes
        activityVC.popoverPresentationController?.sourceView = pDispView
        activityVC.popoverPresentationController?.sourceRect = pTargetView.frame
        // UIActivityViewControllerを表示
        sender.present(activityVC, animated: true, completion: nil)
    }
    
    
}
