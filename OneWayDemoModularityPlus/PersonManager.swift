//
//  PersonManager.swift
//  OneWayDemoModularity
//
//  Created by zhengxianda on 2018/6/12.
//  Copyright © 2018年 Toki. All rights reserved.
//

import Foundation

struct PersonModel {
    var gender: String = "model-gender"
    var name: String = "model-name"
    var stature: Stature = Stature(height: 199, weight: 166)
}

class PersonManager {
    static let shared = PersonManager()
    
    func query(handler: @escaping (PersonModel) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            handler(PersonModel())
        }
    }
}
