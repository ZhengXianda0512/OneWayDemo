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

class Animal: Dispatch {
    var displayGender: String = ""
    var gender: Module<Animal, String> = Module<Animal, String>()
    
    init() {
        gender.delegate = GenderModuleDelegate(target: self)
    }
    
    class GenderModuleDelegate: ModuleDelegate<Animal, String> {
        override func valueDidChange(value: String?) {
            target.displayGender = "性别: \(value ?? "")"
            print(target.displayGender)
        }
    }
}
