//
//  Animal.swift
//  OneWayDemo
//
//  Created by zhengxianda on 2018/5/6.
//  Copyright © 2018年 Toki. All rights reserved.
//

import UIKit

class Animal: GenderProrocol {
    var displayGender: String = ""
    
    private(set) var gender: String = "" {
         didSet {
            if gender != oldValue {
                genderDidChange(oldGender: oldValue, gender: gender)
            }
        }
    }
    
    func updateGender(_ gender: String) {
        self.gender = gender
    }
    
    func genderDidChange(oldGender: String, gender: String) {
        displayGender = "性别: \(gender)"
        print(displayGender)
    }
}
