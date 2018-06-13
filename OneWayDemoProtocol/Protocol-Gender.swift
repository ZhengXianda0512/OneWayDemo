//
//  Protocol-Gender.swift
//  OneWayDemo
//
//  Created by zhengxianda on 2018/5/6.
//  Copyright © 2018年 Toki. All rights reserved.
//

import Foundation

protocol GenderProrocol {
    var gender: String { get }
    
    func updateGender(_ gender: String) -> Void
    func genderDidChange(oldGender: String, gender: String) -> Void
}
