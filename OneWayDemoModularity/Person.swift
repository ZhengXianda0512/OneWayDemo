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

class Person: Animal {
    //display
    var displayName: String = ""
    var displayStature: String = ""
    
    //property
    var name: Module<String> = Module<String>()
    var stature: Module<Stature> = Module<Stature>()
    
    override init() {
        super.init()
        
        observePropertyChanged()
    }
    
    //observe
    func observePropertyChanged() {
        name.distinctUntilChanged().observe { [weak self] (name) in
            if let weakSelf = self {
                weakSelf.displayName = "名字: \(name ?? "")"
                print(weakSelf.displayName)
            }
        }
        
        stature.distinctUntilChanged().observe { [weak self] (stature) in
            if let weakSelf = self {
                weakSelf.displayStature = "身材: \(stature ?? Stature.default)"
                print(weakSelf.displayStature)
            }
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
