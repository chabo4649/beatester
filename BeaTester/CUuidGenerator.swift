//
//  CUuidGenerator.swift
//  iBeaconTest
//
//  Created by 井口陽介 on 2015/07/11.
//  Copyright (c) 2015年 井口陽介. All rights reserved.
//

import UIKit


class CUuidGenerator: NSObject {
    
    func makeUuid() -> String!{
        return UUID().uuidString
    }
   
}
