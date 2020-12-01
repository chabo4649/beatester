//
//  UIDoneTextField.swift
//  EventMeister
//
//  Created by 井口陽介 on 2015/03/20.
//  Copyright (c) 2015年 井口陽介. All rights reserved.
//

import UIKit

class UIDoneTextField: UITextField{

    //var button_delegate: PushButtonDelegate?
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        print("hoge")
        let doneBtn: UIBarButtonItem = UIBarButtonItem( title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(UIDoneTextField.pushBarButtonDone) )
        let cancelBtn: UIBarButtonItem = UIBarButtonItem( title: "Cancel", style: UIBarButtonItem.Style.done, target: self, action: #selector(UIDoneTextField.pushBarButtonCancel) )
        let spacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let arr_item:[UIBarButtonItem] = [cancelBtn, spacer, doneBtn]
        
        //var toolBar: UIToolbar = UIToolbar().setItems(doneBtn, animated: true)
        let toolBar: UIToolbar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.sizeToFit()
        //toolBar.rightBar
        toolBar.setItems(arr_item, animated: true)
        self.inputAccessoryView = toolBar
    }
    
    @objc func pushBarButtonDone(){
        print("DONE")
        //button_delegate?.didPushCancel()
        self.resignFirstResponder()
        
    }
    
    @objc func pushBarButtonCancel(){
        print("CANCEL")
        //button_delegate?.didPushCancel()
        self.resignFirstResponder()
        
    }
    
    

}
