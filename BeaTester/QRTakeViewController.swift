//
//  QRTakeViewController.swift
//  iBeaconTest
//
//  Created by 井口陽介 on 2017/07/17.
//  Copyright © 2017年 井口陽介. All rights reserved.
//

import UIKit

protocol QRTakeViewControllerDelegate{
    func readedQRCode(pQRCode: String)
}

class QRTakeViewController: UIViewController, QRReaderDelegate{
    
    var qrr: QRReader?
    var delegate: QRTakeViewControllerDelegate?
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var Label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        qrr = QRReader(pView: self.view)
        qrr?.delegate = self
        qrr?.startScanning()
        self.view.addSubview(toolBar)
        self.view.addSubview(Label)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pushCloseButton(sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)    //ModalViewを閉じる
    }
    
    //QRReaderDelegate Method
    func sendQRString(pString: String){
        let ac = UIAlertController(title: "", message: "QRコードを反映しますか？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {
            action in
            //self.UUIDTextField.text! = pString
            self.delegate?.readedQRCode(pQRCode: pString)
            self.dismiss(animated: true, completion: nil)    //ModalViewを閉じる
        }
        let noAction = UIAlertAction(title: "Cancel", style: .cancel) {
            action in NSLog("はいボタンが押されました")
            self.dismiss(animated: true, completion: nil)    //ModalViewを閉じる
            
        }
        ac.addAction(okAction)
        ac.addAction(noAction)
        present(ac, animated: true, completion: nil)
        
    }
    
    
    
}


