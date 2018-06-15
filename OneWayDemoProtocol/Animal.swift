//
//  Animal.swift
//  OneWayDemo
//
//  Created by zhengxianda on 2018/5/6.
//  Copyright © 2018年 Toki. All rights reserved.
//

import UIKit

class AnimalAction: Action {
    enum AnimalEvent {
        case updateGender(gender: String?)
    }
    
    convenience init(_ animalEvent: AnimalEvent){
        self.init()
        
        event = { object in
            if let animalObject = object as? Person {
                switch animalEvent {
                case .updateGender(let gender):
                    animalObject.updateGender(gender)
                }
            }
        }
    }
}

class Animal: Dispatch, GenderProrocol {
    var displayGender: String = ""
    
    var gender: String?
    
    init() {
        initialization()
    }
    
    func initialization() {
        self.dispatch(AnimalAction(.updateGender(gender: gender)))
    }
    
    func genderDidChange(oldGender: String?, gender: String?) {
        displayGender = "性别: \(gender ?? "")"
        print(displayGender)
    }
    
    deinit {
        print("deinit: Animal")
    }
}
