//
//  Module.swift
//  OneWayDemoModularity
//
//  Created by zhengxianda on 2018/6/12.
//  Copyright © 2018年 Toki. All rights reserved.
//

import Foundation

public class Module<C: AnyObject, V>  {
    
    private(set) var value: V?
    var delegate: ModuleDelegate<C, V>?
    private weak var target: C?
    
    init(delegate: ModuleDelegate<C, V>) {
        self.delegate = delegate
        self.target = delegate.target
    }
    
    init() {
        
    }
    
}

extension Module {
    private func sendValueDidChange(_ value: V?) {
        if target != nil {
            delegate?.sendValueDidChange(value: value)
        }else{
            delegate = nil
        }
    }
    
    public func update(_ value: V?) {
        self.value = value
        self.sendValueDidChange(value)
    }
}

extension Module where V : Equatable {
    public func update(_ value: V?) {
        if self.value != value {
            self.value = value
            self.sendValueDidChange(value)
        }
    }
}
