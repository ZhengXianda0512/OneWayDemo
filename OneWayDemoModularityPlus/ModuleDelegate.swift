//
//  ModuleDelegate.swift
//  OneWayDemoModularityPlus
//
//  Created by zhengxianda on 2018/6/22.
//  Copyright © 2018年 Toki. All rights reserved.
//

import Foundation

public class ModuleDelegate<C: AnyObject, V> {
    private(set) weak var target: C!
    
    public init(target: C) {
        self.target = target
    }
    
    deinit {
        print("deinit: ModuleDelegate:\(C.self), \(V.self)")
    }
    
    final func sendValueDidChange(value: V?) {
        if target != nil {
            valueDidChange(value: value)
        }
    }
    
    public func valueDidChange(value: V?) {
        
    }
}
