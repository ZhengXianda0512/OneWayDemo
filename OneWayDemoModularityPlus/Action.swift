//
//  Action.swift
//  OneWayDemoProtocol
//
//  Created by zhengxianda on 2018/6/13.
//  Copyright © 2018年 Toki. All rights reserved.
//

import Foundation

class Action {
    typealias Event = (Any) -> Void
    
    var event: Event = { _ in }
}
