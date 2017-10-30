//
//  QRViewController.swift
//  iBeaconTest
//
//  Created by 井口陽介 on 2017/07/13.
//  Copyright © 2017年 井口陽介. All rights reserved.
//

import UIKit

class QRViewController: UIViewController {

    var QRString: String! = ""
    
    @IBOutlet weak var QRImageView: UIImageView!
    @IBOutlet weak var QRLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        QRLabel.text = QRString
        QRImageView.image = QRGenerator.stringToQRCode(pString: QRString)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pushCloseButton(sender: UIBarButtonItem){
        dismiss(animated: true, completion: nil)    //ModalViewを閉じる
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
