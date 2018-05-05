//
//  Store.swift
//  OneWayDemo
//
//  Created by zhengxianda on 2018/4/11.
//  Copyright © 2018年 Toki. All rights reserved.
//

import Foundation

protocol ActionType {}
protocol StateType {}
protocol CommandType {}

class TKStore<A: ActionType, S: StateType> {
    let reducer: (_ action: A, _ state: S) -> S
    var subscriber: ((_ state: S, _ previousState: S) -> Void)?
    var state: S
    
    init(reducer: @escaping (A, S) -> S, initialState: S) {
        self.reducer = reducer
        self.state = initialState
    }
    
    func subscribe(_ handler: @escaping (S, S) -> Void) {
        self.subscriber = handler
    }
    
    func unsubscribe() {
        self.subscriber = nil
    }
    
    func dispatch(_ action: A) {
        let previousState = state
        let nextState = reducer(action, state)
        state = nextState
        subscriber?(state, previousState)
    }
}
