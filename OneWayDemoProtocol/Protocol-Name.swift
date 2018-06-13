//
//  Protocol-Name.swift
//  OneWayDemo
//
//  Created by zhengxianda on 2018/5/6.
//  Copyright © 2018年 Toki. All rights reserved.
//

import Foundation

protocol NameProrocol {
    var name: String { get }
    
    func updateName(_ name: String) -> Void
    func nameDidChange(oldName: String, name: String) -> Void
}
