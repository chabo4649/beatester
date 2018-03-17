//
//  FirstViewController.swift
//  iBeaconTest
//
//  Created by 井口陽介 on 2015/07/11.
//  Copyright (c) 2015年 井口陽介. All rights reserved.
//

import UIKit
import CoreLocation
import AudioToolbox

class CentralViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, QRTakeViewControllerDelegate{
    
    
    @IBOutlet weak var UUIDTextField: UITextField!
    @IBOutlet var StatusTextField: UITextField!
    //@IBOutlet var uuid: UITextField!
    @IBOutlet var MajorTextField: UITextField!
    @IBOutlet var MinorTextField: UITextField!
    @IBOutlet var AccuracyTextField: UITextField!
    @IBOutlet var RssiTextField: UITextField!
    @IBOutlet var DistanceTextField: UITextField!
    @IBOutlet var VersionLabel: UILabel!
    
    //@IBOutlet weak var QRCaptureView: UIView!
    
    var trackLocationManager : CLLocationManager!
    var beaconRegion : CLBeaconRegion!
    //var qrr: QRReader?
    
    var QTVC: QRTakeViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        StatusTextField!.isEnabled = false
        MajorTextField!.isEnabled = false
        MinorTextField!.isEnabled = false
        AccuracyTextField!.isEnabled = false
        RssiTextField.isEnabled = false
        DistanceTextField.isEnabled = false
        
        UUIDTextField.delegate = self
        
        if UserDefaultsUtil.getStringValue(COMMON.RECEIVE_UUID) != nil {
            UUIDTextField.text! = UserDefaultsUtil.getStringValue(COMMON.RECEIVE_UUID) as! String
        }else{
            UserDefaultsUtil.setStringValue(COMMON.RECEIVE_UUID, pItem: "")
        }
        
        self.VersionLabel!.text = "\(self.VersionLabel!.text!)\((Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String)!)"
        //qrr = QRReader(pView: self.QRCaptureView)
        //qrr?.delegate = self
        //qrr?.startScanning()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pushQRReadButton(_ sender: UIBarButtonItem){
        QTVC = QRTakeViewController()
        QTVC?.delegate = self
        self.present(QTVC!, animated: true, completion: nil)
    }
    
    @IBAction func pushStartButton(_ sender: UIBarButtonItem){
        
        // ロケーションマネージャを作成する
        self.trackLocationManager = CLLocationManager();
        // デリゲートを自身に設定
        self.trackLocationManager.delegate = self;
        // セキュリティ認証のステータスを取得
        let status = CLLocationManager.authorizationStatus()
        
        // まだ認証が得られていない場合は、認証ダイアログを表示
        if(status != CLAuthorizationStatus.authorizedWhenInUse) {
            if #available(iOS 10.0, *) {
                //sharedInstance.allowsBackgroundLocationUpdates = true
                self.trackLocationManager.requestAlwaysAuthorization()
            } else {
                // Fallback on earlier versions
                self.trackLocationManager.requestWhenInUseAuthorization()
            }
            
        }
        // BeaconのUUIDを設定
        print(UUIDTextField!.text!)
        let uuid:UUID! = UUID(uuidString: UUIDTextField!.text!)
        
        //Beacon領域を作成
        if uuid != nil {
            self.beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "")
            self.beaconRegion.notifyOnEntry = true
            self.beaconRegion.notifyOnExit = true
            self.sendLocalNotificationWithRegion("Beaconを検出エリアに入りました。")
        }else{
            self.makeAlert("UUIDが正しくありません。")
        }
        
        
    }
    
    //位置認証のステータスが変更された時に呼ばれる
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        // 認証のステータス
        var statusStr = "";
        print("CLAuthorizationStatus: \(statusStr)")
        
        // 認証のステータスをチェック
        switch (status) {
        case .notDetermined:
            statusStr = "NotDetermined"
            self.StatusTextField.text   = statusStr
            manager.requestWhenInUseAuthorization()
        case .restricted:
            statusStr = "Restricted"
            self.StatusTextField.text   = statusStr
        case .denied:
            statusStr = "Denied"
            self.StatusTextField.text   = statusStr
        case .authorizedAlways, .authorizedWhenInUse:
            statusStr = "Authorized"
            self.StatusTextField.text   = statusStr
        }
        
        print(" CLAuthorizationStatus: \(statusStr)")
        
        //観測を開始させる
        if self.beaconRegion != nil {
            trackLocationManager.startMonitoring(for: self.beaconRegion)
        }else{
            self.StatusTextField.text   = ""
        }
    }
    
    //観測の開始に成功すると呼ばれる
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor didStartMonitoringForRegion: CLRegion) {
        
        print("didStartMonitoringForRegion");
        
        //観測開始に成功したら、領域内にいるかどうかの判定をおこなう。→（didDetermineState）へ
        trackLocationManager.requestState(for: self.beaconRegion);
        //iBeaconNotificationUtil.postLocalNotificationIfNeeded(message: "領域外→領域に入った場合")
    }
    
    //領域内にいるかどうかを判定する
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for inRegion: CLRegion) {
        
        switch (state) {
            
        case .inside: // すでに領域内にいる場合は（didEnterRegion）は呼ばれない
            
            trackLocationManager.startRangingBeacons(in: beaconRegion);
            // →(didRangeBeacons)で測定をはじめる
            break;
            
        case .outside:
            //iBeaconNotificationUtil.postLocalNotificationIfNeeded(message: "領域外→領域に入った場合")
            // 領域外→領域に入った場合はdidEnterRegionが呼ばれる
            break;
            
        case .unknown:
            //iBeaconNotificationUtil.postLocalNotificationIfNeeded(message: "不明→領域に入った場合")
            // 不明→領域に入った場合はdidEnterRegionが呼ばれる
            break;
            
        }
    }
    
    //領域に入った時
    func locationManager(_ manager: CLLocationManager, didEnterRegion: CLRegion) {
        
        // →(didRangeBeacons)で測定をはじめる
        self.trackLocationManager.startRangingBeacons(in: self.beaconRegion)
        self.StatusTextField.text = "didEnterRegion"
        
        sendLocalNotificationWithMessage("領域に入りました", pUUID: UUIDTextField!.text!)
        //iBeaconNotificationUtil.postLocalNotificationIfNeeded(message: "不明→領域に入った場合")
        self.makeAlert("領域に入りました！")
    }
    
    //領域から出た時
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        //測定を停止する
        self.trackLocationManager.stopRangingBeacons(in: self.beaconRegion)
        
        reset()
        
        sendLocalNotificationWithMessage("領域から出ました", pUUID:  UUIDTextField!.text!)
        //iBeaconNotificationUtil.postLocalNotificationIfNeeded(message: "領域から出ました")
        self.makeAlert("領域から出ました！")
        
    }
    
    //観測失敗
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        
        print("monitoringDidFailForRegion \(error)")
        
    }
    
    //通信失敗
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("didFailWithError \(error)")
        
    }
    
    //領域内にいるので測定をする
    func locationManager(_ manager: CLLocationManager,didRangeBeacons beacons: [CLBeacon],in region: CLBeaconRegion){
        if(beacons.count == 0) { return }
        //複数あった場合は一番先頭のものを処理する
        let beacon = beacons[0]
        
        /*
        beaconから取得できるデータ
        proximityUUID   :   regionの識別子
        major           :   識別子１
        minor           :   識別子２
        proximity       :   相対距離
        accuracy        :   精度
        rssi            :   電波強度
        */
        if (beacon.proximity == CLProximity.unknown) {
            self.DistanceTextField.text = "Unknown Proximity"
            reset()
            return
        } else if (beacon.proximity == CLProximity.immediate) {
            self.DistanceTextField.text = "Immediate"
        } else if (beacon.proximity == CLProximity.near) {
            self.DistanceTextField.text = "Near"
        } else if (beacon.proximity == CLProximity.far) {
            self.DistanceTextField.text = "Far"
        }
        self.StatusTextField.text   = "領域内です"
        //self.uuid.text     = beacon.proximityUUID.UUIDString
        self.MajorTextField.text    = "\(beacon.major)"
        self.MinorTextField.text    = "\(beacon.minor)"
        self.AccuracyTextField.text = "\(beacon.accuracy)"
        self.RssiTextField.text     = "\(beacon.rssi)"
        
        //Debug1用
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US") // ロケールの設定
        dateFormatter.dateFormat = "HH:mm:ss" // 日付フォーマットの設定
        
        //println(dateFormatter.stringFromDate(now)) // -> 2014/06/25 02:13:18
        
        sendLocalNotificationWithMessage("検知中\(dateFormatter.string(from: Date()))", pUUID: UUIDTextField!.text!)
        //iBeaconNotificationUtil.postLocalNotificationIfNeeded(message: "検知中\(dateFormatter.string(from: Date()))")
        var soundId:SystemSoundID = 0
        let soundUrl:NSURL? = NSURL(fileURLWithPath: "/System/Library/Audio/UISounds/alarm.caf")
        // システムサウンドへのパスを指定
        if soundUrl != nil {
            // SystemsoundIDを作成して再生実行
            AudioServicesCreateSystemSoundID(soundUrl!, &soundId)
            AudioServicesPlaySystemSound(soundId)
        }
        
    }
    
    //QRTakeViewControllerDelegate Method
    func readedQRCode(pQRCode: String) {
        let arr = pQRCode.components(separatedBy: ",")
        UUIDTextField.text = arr[0]
        UserDefaultsUtil.setStringValue(COMMON.RECEIVE_UUID, pItem: arr[0])
        //MajorTextField.text = arr[1]
        //MinorTextField.text = arr[2]
        
    }
    
    private func reset(){
        self.StatusTextField.text   = ""
        //self.uuid.text     = "none"
        self.MajorTextField.text    = ""
        self.MinorTextField.text    = ""
        self.AccuracyTextField.text = ""
        self.RssiTextField.text     = ""
        self.DistanceTextField.text = ""
    }
    
    //ローカル通知(領域検出)
    private func sendLocalNotificationWithRegion(_ message: String!) {
        let notification:UILocalNotification = UILocalNotification()
        notification.alertBody = message
        notification.regionTriggersOnce = false
        //notification.category = "NOTIFICATION_CATEGORY_INTERACTIVE"
        notification.region = self.beaconRegion
        
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    //ローカル通知()
    private func sendLocalNotificationWithMessage(_ message: String!, pUUID: String) {
        let defaults = UserDefaults.standard
        let now = Date()
        let date = defaults.object(forKey: pUUID)
        
        defaults.set(now, forKey: pUUID)
        defaults.synchronize()
        
        if let date = date as? NSDate {
            let remainder = now.timeIntervalSince(date as Date)
            let interval = 10   // 2時間
            let threshold: TimeInterval = TimeInterval(interval)
            if remainder > threshold {
                let notification:UILocalNotification = UILocalNotification()
                notification.alertBody = message
                UIApplication.shared.scheduleLocalNotification(notification)
            }
        }
        
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        UserDefaultsUtil.setStringValue(COMMON.RECEIVE_UUID, pItem: textField.text!)
        return true
    }
    
    fileprivate func makeAlert(_ pMassage: String){
        let alert: UIAlertController = UIAlertController(title: "通知", message: pMassage, preferredStyle: .alert)
        // addActionした順に左から右にボタンが配置されます
        let otherAction = UIAlertAction(title: "OK", style: .default) {
            action in NSLog("はいボタンが押されました")
            //self.label?.text = pMassage
            
        }
        
        alert.addAction(otherAction)
        present(alert, animated: true, completion: nil)
    }

}

