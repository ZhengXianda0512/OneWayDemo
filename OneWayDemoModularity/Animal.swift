//
//  Animal.swift
//  OneWayDemoModularity
//
//  Created by zhengxianda on 2018/6/13.
//  Copyright © 2018年 Toki. All rights reserved.
//

import Foundation

class Animal {
    var displayGender: String = ""
    var gender: Module<String> = Module<String>()
    
    init() {
        gender.distinctUntilChanged().observe { [weak self] (gender) in
            if let weakSelf = self {
                weakSelf.displayGender = "性别: \(gender ?? "")"
                print(weakSelf.displayGender)
            }
        }
    }
}
