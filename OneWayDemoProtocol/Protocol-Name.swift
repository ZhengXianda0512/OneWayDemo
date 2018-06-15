//
//  Protocol-Name.swift
//  OneWayDemo
//
//  Created by zhengxianda on 2018/5/6.
//  Copyright © 2018年 Toki. All rights reserved.
//

import Foundation

protocol NameProrocol: class {
    var name: String? { get set }
    
    func updateName(_ name: String?) -> Void
    func nameDidChange(oldName: String?, name: String?) -> Void
}

extension NameProrocol {
    func updateName(_ name: String?) -> Void {
        if self.name == nil || self.name != name {
            let oldName = self.name
            self.name = name
            nameDidChange(oldName: oldName, name: name)
        }
    }
}
