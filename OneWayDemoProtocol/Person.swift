//
//  Person.swift
//  OneWayDemo
//
//  Created by zhengxianda on 2018/5/5.
//  Copyright © 2018年 Toki. All rights reserved.
//

import UIKit

class PersonAction: AnimalAction {
    enum PersonEvent {
        case updateName(name: String?)
        case updateStature(stature: Stature?)
        case query
    }
    
    convenience init(_ personEvent: PersonEvent){
        self.init()
        
        event = { object in
            if let personObject = object as? Person {
                switch personEvent {
                case .updateName(let name):
                    personObject.updateName(name)
                case .updateStature(let stature):
                    personObject.updateStature(stature)
                case .query:
                    personObject.query()
                }
            }
        }
    }
}

class Person: Animal, NameProrocol, StatureProrocol {
    //Display
    var displayName: String = ""
    var displayStature: String = ""
    
    var name: String?
    var stature: Stature?
    
    override func initialization() {
        super.initialization()
        self.dispatch(PersonAction(.updateName(name: name)))
        self.dispatch(PersonAction(.updateStature(stature: stature)))
    }
    
    func nameDidChange(oldName: String?, name: String?) {
        displayName = "姓名: \(name ?? "")"
        print(displayName)
    }
    
    func statureDidChange(oldStature: Stature?, stature: Stature?) {
        displayStature = "身材: \(stature ?? Stature.default)"
        print(displayStature)
    }
    
    func query() {
        PersonManager.shared.query { [weak self] (model) in
            if let weakSelf = self {
                weakSelf.updateName(model.name)
                weakSelf.updateGender(model.gender)
                weakSelf.updateStature(model.stature)
            }
        }
    }
    
    deinit {
        print("deinit: Person")
    }
}
