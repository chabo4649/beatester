//
//  SecondViewController.swift
//  iBeaconTest
//
//  Created by 井口陽介 on 2015/07/11.
//  Copyright (c) 2015年 井口陽介. All rights reserved.
//

import UIKit

class PeripheralViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var UUIDTextField: UITextField!
    @IBOutlet weak var MajorTextField: UITextField!
    @IBOutlet weak var MinorTextField: UITextField!
    @IBOutlet weak var IdTextField: UITextField!
    @IBOutlet var VersionLabel: UILabel!
    @IBOutlet weak var ToolBar: UIToolbar!
    var Beacon: CBeaconTransfer?
    var Status: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        MajorTextField.delegate = self
        MinorTextField.delegate = self
        IdTextField.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        if UserDefaultsUtil.getStringValue(COMMON.TRANSMIT_UUID) != nil {
            UUIDTextField.text! = UserDefaultsUtil.getStringValue(COMMON.TRANSMIT_UUID) as! String
        }else{
            UserDefaultsUtil.setStringValue(COMMON.TRANSMIT_UUID, pItem: "")
        }
        
        if UserDefaultsUtil.getStringValue(COMMON.TRANSMIT_MAJOR) != nil {
            MajorTextField.text! = UserDefaultsUtil.getStringValue(COMMON.TRANSMIT_MAJOR) as! String
        }else{
            UserDefaultsUtil.setStringValue(COMMON.TRANSMIT_MAJOR, pItem: "")
        }
        
        if UserDefaultsUtil.getStringValue(COMMON.TRANSMIT_MINOR) != nil {
            MinorTextField.text! = UserDefaultsUtil.getStringValue(COMMON.TRANSMIT_MINOR) as! String
        }else{
            UserDefaultsUtil.setStringValue(COMMON.TRANSMIT_MINOR, pItem: "")
        }
        
        if UserDefaultsUtil.getStringValue(COMMON.TRANSMIT_ID) != nil {
            IdTextField.text! = UserDefaultsUtil.getStringValue(COMMON.TRANSMIT_ID) as! String
        }else{
            UserDefaultsUtil.setStringValue(COMMON.TRANSMIT_ID, pItem: "")
        }
        self.VersionLabel!.text = "\(self.VersionLabel!.text!)\((Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String)!)"

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pushStartButton(_ sender: UIBarButtonItem){
        if !self.Status {
            if !(MajorTextField!.text! == "" || MinorTextField!.text! == "" || UUIDTextField!.text! == ""){
                if(Int(MajorTextField!.text!)! > COMMON.MAX_CODE || MajorTextField!.text! == ""){
                    self.makeAlert("Major Value Over")
                    MajorTextField!.text = ""
                }else if(Int(MinorTextField!.text!)! > COMMON.MAX_CODE || MinorTextField!.text! == ""){
                    self.makeAlert("Minor Value Over")
                    MinorTextField!.text! = ""
                }else{
                    Beacon = CBeaconTransfer(pUUID: UUIDTextField.text!, pMajor: MajorTextField.text!, pMinor: MinorTextField.text!, pIdentify: IdTextField.text!)
                    Beacon!.startToTransferSignal()
                    self.makeAlert("Signal Start")
                    self.Status = true
                    
                }
            }else{
                self.makeAlert("Setting Value Error!!")
                MajorTextField!.text = "0"
                UserDefaultsUtil.setStringValue(COMMON.TRANSMIT_MAJOR, pItem: "0")
                MinorTextField!.text! = "0"
                UserDefaultsUtil.setStringValue(COMMON.TRANSMIT_MINOR, pItem: "0")
            }
        }else{
            _ = Beacon!.stopToTransferSignal()
            
            self.makeAlert("Signal Stoped")
            self.Status = false
        }
        
    }
    
    @IBAction func playPauseAction(_ sender: UIBarButtonItem) {
        var items = self.ToolBar.items!
        var toggleButton:UIBarButtonItem
        if !self.Status  {
            if !(MajorTextField!.text! == "" || MinorTextField!.text! == "" || UUIDTextField!.text! == ""){
                if(Int(MajorTextField!.text!)! > COMMON.MAX_CODE || MajorTextField!.text! == ""){
                    self.makeAlert("Major Value Over")
                    MajorTextField!.text = ""
                }else if(Int(MinorTextField!.text!)! > COMMON.MAX_CODE || MinorTextField!.text! == ""){
                    self.makeAlert("Minor Value Over")
                    MinorTextField!.text! = ""
                }else{
                    Beacon = CBeaconTransfer(pUUID: UUIDTextField.text!, pMajor: MajorTextField.text!, pMinor: MinorTextField.text!, pIdentify: IdTextField.text!)
                    Beacon!.startToTransferSignal()
                    // 音楽の一時停止処理など
                    toggleButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.pause, target: self, action: #selector(self.playPauseAction(_:)))
                    self.Status = true
                    self.makeAlert("Signal Start")
                    self.Status = true
                    items[5] = toggleButton
                    self.ToolBar.setItems(items, animated: false)
                }
            }else{
                self.makeAlert("Setting Value Error!!")
                MajorTextField!.text = "0"
                UserDefaultsUtil.setStringValue(COMMON.TRANSMIT_MAJOR, pItem: "0")
                MinorTextField!.text! = "0"
                UserDefaultsUtil.setStringValue(COMMON.TRANSMIT_MINOR, pItem: "0")
            }

        } else {
            // 音楽の再生処理など
            _ = Beacon!.stopToTransferSignal()
            self.makeAlert("Signal Stoped")
            self.Status = false
            toggleButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.play, target: self, action: #selector(self.playPauseAction(_:)))
            items[5] = toggleButton
            self.ToolBar.setItems(items, animated: false)
        }
        
    }
    
    @IBAction func pushActionButton(_ sender: UIBarButtonItem){
        let alert: UIAlertController = UIAlertController(title: "", message: "出力機能選択", preferredStyle: .actionSheet)
        // ActivityController
        let otherAction = UIAlertAction(title: "共有", style: .default) {
            action in
            SosialUtility.sendMessage(self, pSubject: "BeaconUUID", pMessage:
                "UUID:\(self.UUIDTextField.text!)\n" +
                    "Major:\(self.MajorTextField.text!)\n" +
                "Minor:\(self.MinorTextField.text!)", pDispView: self.view, pTargetView: self.UUIDTextField
            )
        }
        //QRCode出力
        let QRAction = UIAlertAction(title: "QRコード表示", style: .default) {
            action in
            let QRVC = QRViewController()
            QRVC.QRString =
                "\(self.UUIDTextField.text!),\(self.MajorTextField.text!),\(self.MinorTextField.text!)"
            self.present(QRVC, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
        
        alert.addAction(QRAction)
        alert.addAction(otherAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = self.UUIDTextField.frame//CGRect(x: 100, y: 100, width: 20, height: 20)//(100.0, 100.0, 20.0, 20.0)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func pushStopButton(_ sender: UIBarButtonItem){
        _ = Beacon!.stopToTransferSignal()
        self.makeAlert("Signal Stoped")
    }
    
    @IBAction func pushGenerateButton(_ sender: AnyObject){
        UUIDTextField.text = UUID().uuidString
        let generalPasteboard: UIPasteboard = UIPasteboard.general
        generalPasteboard.string = UUIDTextField.text
        let alert: UIAlertController = UIAlertController(title: "UUID", message: "コピーしました", preferredStyle:UIAlertControllerStyle.alert )
        let defaultAction:UIAlertAction = UIAlertAction(title: "OK",
            style: UIAlertActionStyle.default,
            handler:{
                (action:UIAlertAction) -> Void in
                print("Default")
        })
        UserDefaultsUtil.setStringValue(COMMON.TRANSMIT_UUID, pItem: UUIDTextField.text!)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func textFieldDidEndEditing(_ textField:UITextField){
        print(textField.text!)
        switch textField.tag{
        case 1:
            UserDefaultsUtil.setStringValue(COMMON.TRANSMIT_MAJOR, pItem: textField.text!)
        case 2:
            UserDefaultsUtil.setStringValue(COMMON.TRANSMIT_MINOR, pItem: textField.text!)
        case 3:
            UserDefaultsUtil.setStringValue(COMMON.TRANSMIT_ID, pItem: textField.text!)
        default:
            print("No Value!")
        }
    }
    
    fileprivate func makeAlert(_ pMassage: String){
        let alert: UIAlertController = UIAlertController(title: "TEST", message: pMassage, preferredStyle: .alert)
        // addActionした順に左から右にボタンが配置されます
        let otherAction = UIAlertAction(title: "OK", style: .default) {
            action in NSLog("はいボタンが押されました")
            //self.label?.text = pMassage
            
        }


        
        alert.addAction(otherAction)
        
        present(alert, animated: true, completion: nil)
    }


}

