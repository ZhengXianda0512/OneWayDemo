//
//  Prorocol-Stature.swift
//  OneWayDemoProtocol
//
//  Created by zhengxianda on 2018/6/13.
//  Copyright © 2018年 Toki. All rights reserved.
//

import Foundation

struct Stature: Equatable {
    static let `default` = Stature(height: 0, weight: 0)
    
    var height: Float
    var weight: Float
}

protocol StatureProrocol {
    var stature: Stature { get }
    
    func updateStature(_ stature: Stature) -> Void
    func statureDidChange(oldStature: Stature, stature: Stature) -> Void
}
