//
//  QRGenerator.swift
//  QRGenerator
//
//  Created by 井口陽介 on 2017/07/11.
//  Copyright © 2017年 井口陽介. All rights reserved.
//

import UIKit
import CoreImage

class QRGenerator: NSObject {

    static func stringToQRCode(pString: String) -> UIImage{
            
        // NSString から NSDataへ変換
        let data = pString.data(using: String.Encoding.utf8)!
        
        // QRコード生成のフィルター
        // NSData型でデーターを用意
        // inputCorrectionLevelは、誤り訂正レベル
        let qr = CIFilter(name: "CIQRCodeGenerator", parameters: ["inputMessage": data, "inputCorrectionLevel": "M"])!
        
        
        let sizeTransform = CGAffineTransform(scaleX: 10, y: 10)
        let qrImage = qr.outputImage!.transformed(by: sizeTransform)
        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(qrImage, from: qrImage.extent)
        let uiImage = UIImage(cgImage: cgImage!)
        
        return uiImage
    }
        
}
