//
//  LocationManager.swift
//  iBeaconTest
//
//  Created by 井口陽介 on 2016/11/17.
//  Copyright © 2016年 井口陽介. All rights reserved.
//

import CoreLocation

class LocationManager: CLLocationManager {
    
    private static let sharedInstance = LocationManager()
    
    /**
     位置情報取得の許可を確認
     */
    static func requestAlwaysAuthorization() {
        // バックグラウンドでも位置情報更新をチェックする
        if #available(iOS 9.0, *) {
            sharedInstance.allowsBackgroundLocationUpdates = true
        } else {
            // Fallback on earlier versions
        }
        sharedInstance.delegate = sharedInstance
        sharedInstance.requestAlwaysAuthorization()
    }
}


// MARK: CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("Start monitoring for region")
        manager.requestState(for: region)
    }
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                
                let beaconRegion = CLBeaconRegion(proximityUUID: NSUUID(uuidString: "UUID文字列")! as UUID, identifier: "ビーコンのID")
                beaconRegion.notifyEntryStateOnDisplay = true   // ディスプレイ表示中も通知する
                manager.startMonitoring(for: beaconRegion)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        if state == .inside {
            iBeaconNotificationUtil.postLocalNotificationIfNeeded(message: "出勤しますか？")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        iBeaconNotificationUtil.postLocalNotificationIfNeeded(message: "出勤しますか？")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        iBeaconNotificationUtil.postLocalNotificationIfNeeded(message: "退勤しますか？")
    }
}
