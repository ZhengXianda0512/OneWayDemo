//
//  StatusBoxView.swift
//  OneWayDemo
//
//  Created by zhengxianda on 2018/4/11.
//  Copyright © 2018年 Toki. All rights reserved.
//

import UIKit

protocol StatusBoxViewDelegate {
    func statusBoxView(_ statusBoxView: StatusBoxView, statusButtonTapped statusButton: UIButton , with status: ToDo.Status)
}

class StatusBoxView: UIView {
    
    //代理
    var agent: StatusBoxViewDelegate?
    
    //MARK: - 状态
    struct State: StateType {
        var title: String = ""
        var status: ToDo.Status = .none
        var changeStatusEvent: ((ToDo.Status) -> Void)?
    }
    
    //MARK: - 异步命令
    enum Command: CommandType {
        case none
    }
    
    //MARK: - 事件
    enum Action: ActionType {
        case updateStatus(status: ToDo.Status)
        case updateChangeStatusEvent(changeStatusEvent: ((ToDo.Status) -> Void)?)
    }
    
    //MARK: - 关联 事件、状态变化、异步命令
    lazy var reducer: (State, Action) -> (state: State, command: Command?) = { [unowned self] (state: State, action: Action) in
        
        var state:State = state
        var command: Command? = nil
        
        switch action {
        case .updateStatus(let status):
            state.status = status
        case .updateChangeStatusEvent(let changeStatusEvent):
            state.changeStatusEvent = changeStatusEvent
        }
        return (state, command)
    }
    
    //MARK: - 仓库
    var store: Store<Action, State, Command>!
    
    // MARK: - 用户界面相关属性
    lazy var statusButton: UIButton = {
        let temp = UIButton()
        return temp
    }()
    
    // MARK: - 初始化
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupUIResponse()
        setupStore()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        setupUIResponse()
        setupStore()
    }
    
    func setupStore() {
        store = Store<Action, State, Command>(reducer: reducer, initialState: State())
        store.subscribe { [unowned self] state, previousState, command in
            self.stateDidChanged(state: state, previousState: previousState, command: command)
        }
        stateDidChanged(state: store.state, previousState: nil, command: nil)
    }
    
    //MARK: - 处理状态变化
    func stateDidChanged(state: State, previousState: State?, command: Command?) {
        //处理异步命令
        if let command = command {
            switch command {
            case .none: break
            }
        }
        
        //处理状态变化
        if previousState == nil || previousState!.status != state.status {
            switch state.status {
            case .none:
                statusButton.isEnabled = false
                statusButton.backgroundColor = UIColor.gray
                statusButton.setTitle("none", for: .normal)
            case .doing:
                statusButton.isEnabled = true
                statusButton.backgroundColor = UIColor.red
                statusButton.setTitle("doing", for: .normal)
            case .completed:
                statusButton.isEnabled = true
                statusButton.backgroundColor = UIColor.green
                statusButton.setTitle("completed", for: .normal)
            }
        }
    }
}

//MARK: - 用户界面交互反馈
extension StatusBoxView {
    @objc func statusButtonTapped() {
        agent?.statusBoxView(self, statusButtonTapped: statusButton, with: store.state.status)
    }
}

//MARK: - 代理事件
extension StatusBoxView {
    
}

//MARK: - 用户界面相关配置
extension StatusBoxView {
    
    func setupUI() {
        addSubview(statusButton)
        statusButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func setupUIResponse() {
        statusButton.addTarget(self, action: #selector(statusButtonTapped), for: .touchUpInside)
    }
    
}
