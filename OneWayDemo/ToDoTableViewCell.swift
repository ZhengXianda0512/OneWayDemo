//
//  ToDoTableViewCell.swift
//  OneWayDemo
//
//  Created by zhengxianda on 2018/4/15.
//  Copyright © 2018年 Toki. All rights reserved.
//

import UIKit

protocol ToDoTableViewCellDelegate {
    func toDoTableViewCell(_ toDoTableViewCell: ToDoTableViewCell, toDoView: ToDoView, statusBoxView: StatusBoxView, statusButtonTapped statusButton: UIButton , with status: ToDo.Status)
}

class ToDoTableViewCell: UITableViewCell {
    
    static let identify: String = "ToDoTableViewCellId"
    
    //代理
    var agent: ToDoTableViewCellDelegate?
    
    //MARK: - 状态
    struct State: StateType {
        
    }
    
    //MARK: - 异步命令
    enum Command: CommandType {
        case none
    }
    
    //MARK: - 事件
    enum Action: ActionType {
        case toDoView(action: ToDoView.Action)
    }
    
    //MARK: - 关联 事件、状态变化、异步命令
    lazy var reducer: (State, Action) -> (state: State, command: Command?) = { [unowned self] (state: State, action: Action) in
        
        var state:State = state
        var command: Command? = nil
        
        switch action {
        case .toDoView(let action):
            self.toDoView.store.dispatch(action)
        }
        return (state, command)
    }
    
    //MARK: - 仓库
    var store: Store<Action, State, Command>!
    
    // MARK: - 用户界面相关属性
    lazy var toDoView: ToDoView = {
        let temp = ToDoView()
        return temp
    }()
    
    // MARK: - 初始化
    convenience init() {
        self.init(style: .default, reuseIdentifier: ToDoTableViewCell.identify)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
    }
}

//MARK: - 用户界面交互反馈
extension ToDoTableViewCell {
    
}

//MARK: - 代理事件
extension ToDoTableViewCell: ToDoViewDelegate {
    func toDoView(_ toDoView: ToDoView, statusBoxView: StatusBoxView, statusButtonTapped statusButton: UIButton, with status: ToDo.Status) {
        agent?.toDoTableViewCell(self, toDoView: toDoView, statusBoxView: statusBoxView, statusButtonTapped: statusButton, with: status)
    }
}

//MARK: - 用户界面相关配置
extension ToDoTableViewCell {
    
    func setupUI() {
        toDoView.agent = self
        addSubview(toDoView)
        toDoView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func setupUIResponse() {
        
    }
    
}
