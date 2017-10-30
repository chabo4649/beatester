//
//  TestViewController.swift
//  iBeaconTest
//
//  Created by 井口陽介 on 2016/05/06.
//  Copyright © 2016年 井口陽介. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fm = FileManager()
        do {
            try fm.removeItem(atPath: "aaaaaaa")
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
