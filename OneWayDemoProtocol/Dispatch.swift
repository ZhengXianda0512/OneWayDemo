//
//  Dispatch.swift
//  OneWayDemoProtocol
//
//  Created by zhengxianda on 2018/6/13.
//  Copyright © 2018年 Toki. All rights reserved.
//

import Foundation

protocol Dispatch {
    func dispatch(_ action: Action) -> Void
}

extension Dispatch {
    func dispatch(_ action: Action) -> Void {
        action.event(self)
    }
}
