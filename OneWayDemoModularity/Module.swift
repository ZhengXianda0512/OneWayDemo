//
//  Module.swift
//  OneWayDemoModularity
//
//  Created by zhengxianda on 2018/6/12.
//  Copyright © 2018年 Toki. All rights reserved.
//

import Foundation

public class Module<T> {
    
    public typealias ModuleHandler = (_ value: T?) -> Void
    public typealias ModuleFilterRule = (_ oldValue: T?, _ value: T?) -> Bool
    
    private var handler: ModuleHandler?
    private var filterRuleQueue: [ModuleFilterRule] = [ModuleFilterRule]()
    
    private var subModules: [Module<T>] = [Module<T>]()
    
    private var value: T? {
        didSet {
            func traverse(subModules: [Module<T>]) {
                for module in subModules {
                    if module.handler != nil { // 若有处理方案, 则处理
                        var filter = true
                        for filterRule in module.filterRuleQueue {
                            filter = filter && filterRule(oldValue, value)
                        }
                        if filter {
                            module.handler!(value)
                        }
                    }else {
                        traverse(subModules: module.subModules)
                    }
                }
            }
            
            traverse(subModules: subModules)
        }
    }
    
}

public extension Module {
    public func update(_ value: T?) {
        self.value = value
    }
    
    public func observe(_ handler: ModuleHandler?) {
        createSubModule(handler)
    }
}

public extension Module {
    public func filter(_ filterRule: @escaping ModuleFilterRule) -> Module<T> {
        return createSubModule(filterRule)
    }
}

public extension Module where T : Equatable {
    public func distinctUntilChanged() -> Module<T> {
        return createSubModule({ (oldValue, value) -> Bool in
            return oldValue != value
        })
    }
    
    public func ignored(ignore: T?) -> Module<T> {
        return createSubModule({ (oldValue, value) in
            return value != ignore
        })
    }
}

fileprivate extension Module {
    func copy() -> Module<T> {
        let module = Module<T>()
        module.handler = handler
        module.filterRuleQueue = filterRuleQueue
        module.subModules = subModules
        return module
    }
}

fileprivate extension Module {
    func createSubModule(_ filterRule: @escaping ModuleFilterRule) -> Module<T> {
        let module = createSubModule()
        module.filterRuleQueue.append(filterRule)
        return module
    }
    
    func createSubModule(_ handler: ModuleHandler?) {
        let module = createSubModule()
        module.handler = handler
    }
    
    func createSubModule() -> Module<T> {
        let module = self.copy()
        subModules.append(module)
        return module
    }
}
