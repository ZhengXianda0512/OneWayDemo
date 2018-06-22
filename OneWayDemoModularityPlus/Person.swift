//
//  Person.swift
//  OneWayDemoModularity
//
//  Created by zhengxianda on 2018/6/12.
//  Copyright © 2018年 Toki. All rights reserved.
//

import Foundation

struct Stature: Equatable {
    static let `default` = Stature(height: 0, weight: 0)
    
    var height: Float
    var weight: Float
}

class PersonAction: AnimalAction {
    enum PersonEvent {
        case updateName(name: String)
        case updateStature(stature: Stature)
    }
    
    convenience init(_ animal: PersonEvent){
        self.init()
        
        event = { object in
            if let personObject = object as? Person {
                switch animal {
                case .updateName(let name):
                    personObject.name.update(name)
                case .updateStature(let stature):
                    personObject.stature.update(stature)
                }
            }
        }
    }
}

class Person: Animal {
    //display
    var displayName: String = ""
    var displayStature: String = ""
    
    //property
    var name: Module<Person, String> = Module<Person, String>()
    var stature: Module<Person, Stature> = Module<Person, Stature>()
    
    override init() {
        super.init()
        
        name.delegate = NameModuleDelegate(target: self)
        stature.delegate = StatureModuleDelegate(target: self)
    }
    
    class NameModuleDelegate: ModuleDelegate<Person, String> {
        override func valueDidChange(value: String?) {
            target.displayName = "名字: \(value ?? "")"
            print(target.displayName)
        }
    }
    
    class StatureModuleDelegate: ModuleDelegate<Person, Stature> {
        override func valueDidChange(value: Stature?) {
            target.displayStature = "身材: \(value ?? Stature.default)"
            print(target.displayStature)
        }
    }
    
    //action
    func query() {
        PersonManager.shared.query { [weak self] (model) in
            if let weakSelf = self {
                weakSelf.name.update(model.name)
                weakSelf.gender.update(model.gender)
                weakSelf.stature.update(model.stature)
            }
        }
    }
}
