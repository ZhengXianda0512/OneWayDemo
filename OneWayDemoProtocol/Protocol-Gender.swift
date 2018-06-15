//
//  Protocol-Gender.swift
//  OneWayDemo
//
//  Created by zhengxianda on 2018/5/6.
//  Copyright © 2018年 Toki. All rights reserved.
//

import Foundation

protocol GenderProrocol: class {
    var gender: String? { get set }
    
    func updateGender(_ gender: String?) -> Void
    func genderDidChange(oldGender: String?, gender: String?) -> Void
}

extension GenderProrocol {
    func updateGender(_ gender: String?) -> Void {
        if self.gender == nil || self.gender != gender {
            let oldGender = self.gender
            self.gender = gender
            genderDidChange(oldGender: oldGender, gender: gender)
        }
    }
}
