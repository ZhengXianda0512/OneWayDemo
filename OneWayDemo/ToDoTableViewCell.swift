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
    
    //MARK: - 事件
    enum Action: ActionType {
        case toDoView(action: ToDoView.Action)
    }
    
    //MARK: - 关联 事件、状态变化、异步命令
    lazy var reducer: (Action, State) -> State = { [unowned self] (action: Action, state: State) in
        var state:State = state
        
        switch action {
        case .toDoView(let action):
            self.toDoView.store.dispatch(action)
        }
        return (state)
    }
    
    //MARK: - 仓库
    var store: TKStore<Action, State>!
    
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
    
    //MARK: - 处理状态变化
    func stateDidChanged(state: State, previousState: State?) {
        
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

//MARK: - 仓库相关配置
extension ToDoTableViewCell {
    func setupStore() {
        store = TKStore<Action, State>(reducer: reducer, initialState: State())
        store.subscribe { [unowned self] state, previousState in
            self.stateDidChanged(state: state, previousState: previousState)
        }
        stateDidChanged(state: store.state, previousState: nil)
    }
}
