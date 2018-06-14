//
//  Animal.swift
//  OneWayDemoModularity
//
//  Created by zhengxianda on 2018/6/13.
//  Copyright © 2018年 Toki. All rights reserved.
//

import Foundation

class AnimalAction: Action {
    enum AnimalEvent {
        case updateGender(gender: String)
    }
    
    convenience init(_ animal: AnimalEvent){
        self.init()
        
        event = { object in
            if let animalObject = object as? Person {
                switch animal {
                case .updateGender(let gender):
                    animalObject.gender.update(gender)
                }
            }
        }
    }
}

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
