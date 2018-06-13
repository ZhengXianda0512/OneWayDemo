//
//  Person.swift
//  OneWayDemo
//
//  Created by zhengxianda on 2018/5/5.
//  Copyright © 2018年 Toki. All rights reserved.
//

import UIKit

class Person: Animal, NameProrocol, StatureProrocol {
    //Display
    var displayName: String = ""
    var displayStature: String = ""
    
    //name
    private(set) var name: String = "" {
        didSet {
            if name != oldValue {
                nameDidChange(oldName: oldValue, name: name)
            }
        }
    }
    
    func updateName(_ name: String) {
        self.name = name
    }
    
    func nameDidChange(oldName: String, name: String) {
        displayName = "姓名: \(name)"
        print(displayName)
    }
    
    //stature
    private(set) var stature: Stature = Stature.default {
        didSet {
            if stature != oldValue {
                statureDidChange(oldStature: oldValue, stature: stature)
            }
        }
    }
    
    func updateStature(_ stature: Stature) {
        self.stature = stature
    }
    
    func statureDidChange(oldStature: Stature, stature: Stature) {
        displayStature = "身材: \(stature)"
        print(displayStature)
    }
    
    //action
    func query() {
        PersonManager.shared.query { [weak self] (model) in
            if let weakSelf = self {
                weakSelf.updateName(model.name)
                weakSelf.updateGender(model.gender)
                weakSelf.updateStature(model.stature)
            }
        }
    }
}
