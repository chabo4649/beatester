//
//  CBeaconReceive.swift
//  iBeaconTest
//
//  Created by 井口陽介 on 2015/07/13.
//  Copyright (c) 2015年 井口陽介. All rights reserved.
//

import UIKit
import CoreLocation
import AudioToolbox

class CBeaconReceiver: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager!
    fileprivate var myProximityUUID: UUID?
    
    func setRecieveBeaconSignal(){
        // 位置情報使用許可を求める
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        //self.locationManager.requestWhenInUseAuthorization() /* アクティブなときのみ動作する */
        self.locationManager.requestAlwaysAuthorization() /* バックグラウンドでも動作する */
        
    }
    
    // 位置情報使用許可の認証状態が変わったタイミングで呼ばれるデリゲートメソッド
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            let message = "居酒屋『ヤキトリー』が近くにあります"
            // ビーコン領域をトリガーとした通知を作成(後述)
            let notification = createRegionNotification(myProximityUUID!, message: message)
            // 通知を登録する
            UIApplication.shared.scheduleLocalNotification(notification)
        }
        

        
//        switch status {
//        case .NotDetermined:
//            if locationManager.respondsToSelector("requestWhenInUseAuthorization") { locationManager.requestWhenInUseAuthorization() }
//        case .Restricted, .Denied:
//            //self.alertLocationServicesDisabled()
//            break
//        case .AuthorizedWhenInUse:
//            //let uuid: NSUUID! = NSUUID(UUIDString:"XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX")
//            let message = "居酒屋『ヤキトリー』が近くにあります"
//            // ビーコン領域をトリガーとした通知を作成(後述)
//            let notification = createRegionNotification(myProximityUUID!, message: message)
//            // 通知を登録する
//            UIApplication.sharedApplication().scheduleLocalNotification(notification)
//        default:
//            break
//        }
    }
    
    /*
     (Delegate) リージョン内に入ったというイベントを受け取る.
     */
    func locationManager(_ manager: CLLocationManager, didEnterRegion: CLRegion) {
        
    }
    
    /*
     (Delegate) リージョンから出たというイベントを受け取る.
     */
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
    }
    
    fileprivate func createRegionNotification(_ uuid: UUID, message: String) -> UILocalNotification {
        
        // ## ビーコン領域を作成 ##
        let beaconRegion :CLBeaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "RegionId")
        beaconRegion.notifyEntryStateOnDisplay = false
        beaconRegion.notifyOnEntry = true
        // 領域に入ったときにも出たときにも通知される
        // 今回は領域から出たときの通知はRegion側でOFFにしておく
        beaconRegion.notifyOnExit = true
        
        // ## 通知を作成し、領域を設定 ##
        let notification = UILocalNotification()
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.alertBody = message
        
        // 通知の対象となる領域 *今回のポイント
        notification.region = beaconRegion
        // 一度だけの通知かどうか
        notification.regionTriggersOnce = false
        // 後述するボタン付き通知のカテゴリ名を指定
        notification.category = "NOTIFICATION_CATEGORY_INTERACTIVE"
        
        return notification
    }
    

    
    init(pUUID:String) {
        myProximityUUID = UUID(uuidString: pUUID)!
        
        
    }
    
}
