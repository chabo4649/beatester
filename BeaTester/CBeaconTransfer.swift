//
//  CBeaconTransfer.swift
//  iBeaconTest
//
//  Created by 井口陽介 on 2015/07/11.
//  Copyright (c) 2015年 井口陽介. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation

class CBeaconTransfer: NSObject, CBPeripheralManagerDelegate {
    
    // LocationManager.
    fileprivate var myPheripheralManager:CBPeripheralManager!
    
    fileprivate var myProximityUUID: UUID?
    fileprivate var myMajor : CLBeaconMajorValue = 0
    fileprivate var myMinor : CLBeaconMinorValue = 0
    fileprivate var myIdentifier: String = ""
    
    func startToTransferSignal(){
        
        // PeripheralManagerを定義.
        myPheripheralManager = CBPeripheralManager(delegate: self, queue: nil)

    }
    
    func stopToTransferSignal() -> Bool{
       
        return true
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        // BeaconRegionを定義.
        let myBeaconRegion = CLBeaconRegion(proximityUUID: myProximityUUID!, major: myMajor, minor: myMinor, identifier: myIdentifier)
        
        // Advertisingのフォーマットを作成.
        let myBeaconPeripheralData = NSDictionary(dictionary: myBeaconRegion.peripheralData(withMeasuredPower: nil))
        
        
        // Advertisingを発信.
        myPheripheralManager.startAdvertising((myBeaconPeripheralData as! [String : AnyObject]))
    }
    
init(pUUID:String, pMajor:String, pMinor:String, pIdentify:String) {
        myProximityUUID = UUID(uuidString: pUUID)!
        myMajor = CLBeaconMajorValue(Int(pMajor)!)
        myMinor = CLBeaconMajorValue(Int(pMinor)!)
        myIdentifier = pIdentify
    }
   
}
