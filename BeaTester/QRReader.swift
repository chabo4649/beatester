//
//  QRReader.swift
//  iBeaconTest
//
//  Created by 井口陽介 on 2017/07/16.
//  Copyright © 2017年 井口陽介. All rights reserved.
//

import UIKit
import AVFoundation

protocol QRReaderDelegate {
    func sendQRString(pString: String)
}

class QRReader: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    var objCaptureSession:AVCaptureSession?
    var objCaptureVideoPreviewLayer:AVCaptureVideoPreviewLayer?
    var vwQRCode:UIView?
    
    var delegateView: UIView?
    var delegate: QRReaderDelegate!
    
    //読み取りQRコードのためのデバイスで構成するビデオキャプチャ
    private func configureVideoCapture() {
        let objCaptureDevice = AVCaptureDevice.default(for: .video)
        var error:NSError?
        let objCaptureDeviceInput: AnyObject!
        do {
            objCaptureDeviceInput = try AVCaptureDeviceInput(device: objCaptureDevice!) as AVCaptureDeviceInput
            
        } catch let error1 as NSError {
            error = error1
            objCaptureDeviceInput = nil
        }
        if (error != nil) {
            //let alertView:UIAlertView = UIAlertView(title: "Device Error", message:"Device not Supported for this Application", delegate: nil, cancelButtonTitle: "Ok Done")
            //alertView.show()
            
            return
        }
        objCaptureSession = AVCaptureSession()
        objCaptureSession?.addInput(objCaptureDeviceInput as! AVCaptureInput)
        let objCaptureMetadataOutput = AVCaptureMetadataOutput()
        objCaptureSession?.addOutput(objCaptureMetadataOutput)
        objCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        //objCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]   //Swift4
        objCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
    }
    
    //デバイスでビデオプレビューレイヤーを追加します。
    private func addVideoPreviewLayer()
    {
        objCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: objCaptureSession!)
        objCaptureVideoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill //AVLayerVideoGravityResizeAspectFill
        objCaptureVideoPreviewLayer?.frame = (UIScreen.main.bounds)
        delegateView?.layer.addSublayer(objCaptureVideoPreviewLayer!)
        
        
        objCaptureSession?.startRunning()
        //delegateView?.bringSubview(toFront: lblQRCodeResult)
        //delegateView?.bringSubview(toFront: lblQRCodeLabel)
    }
    
    //初期化QRコードを表示
    func initializeQRView() {
        vwQRCode = UIView()
        vwQRCode?.layer.borderColor = UIColor.red.cgColor
        vwQRCode?.layer.borderWidth = 5
        //self.view.addSubview(vwQRCode!)
        //self.view.bringSubview(toFront: vwQRCode!)
    }
    
    //AVCaptureMetadataOutputObjectsDelegateを実装します
    //func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection){

        if metadataObjects.count == 0 {
            vwQRCode?.frame = CGRect.zero
            //lblQRCodeResult.text = "NO QRCode text detacted"
            return
        }
        let objMetadataMachineReadableCodeObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if objMetadataMachineReadableCodeObject.type == AVMetadataObject.ObjectType.qr {
            let objBarCode = objCaptureVideoPreviewLayer?.transformedMetadataObject(for: objMetadataMachineReadableCodeObject as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            vwQRCode?.frame = objBarCode.bounds;
            if objMetadataMachineReadableCodeObject.stringValue != nil {
                //lblQRCodeResult.text = objMetadataMachineReadableCodeObject.stringValue
                self.delegate?.sendQRString(pString: objMetadataMachineReadableCodeObject.stringValue!)
            }
        }
    }
    
    init(pView: UIView){
        self.delegateView = pView
    }
    
    func startScanning(){
        self.configureVideoCapture()
        self.addVideoPreviewLayer()
        self.initializeQRView()
    }

}
