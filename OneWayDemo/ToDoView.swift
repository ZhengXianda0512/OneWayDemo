//
//  ToDoView.swift
//  OneWayDemo
//
//  Created by zhengxianda on 2018/4/11.
//  Copyright © 2018年 Toki. All rights reserved.
//

import UIKit

protocol ToDoViewDelegate {
    func toDoView(_ toDoView: ToDoView, statusBoxView: StatusBoxView, statusButtonTapped statusButton: UIButton , with status: ToDo.Status)
}

class ToDoView: UIView {
    
    //代理
    var agent: ToDoViewDelegate?
    
    //MARK: - 状态
    struct State: StateType {
        var title: String = ""
        var status: ToDo.Status = .none
    }
    
    //MARK: - 事件
    enum Action: ActionType {
        case updateStatus(status: ToDo.Status)
        case updateTitle(title: String)
        
        case statusBoxView(action: StatusBoxView.Action)
    }
    
    //MARK: - 关联 事件、状态变化、异步命令
    lazy var reducer: (Action, State) -> State = { [unowned self] (action: Action, state: State) in
        var state:State = state
        
        switch action {
        case .updateStatus(let status):
            state.status = status
        case .updateTitle(let title):
            state.title = title
        case .statusBoxView(let action):
            self.statusBoxView.store.dispatch(action)
        }
        return (state)
    }
    
    //MARK: - 仓库
    var store: TKStore<Action, State>!
    
    // MARK: - 用户界面相关属性
    lazy var titleLabel: UILabel = {
        let temp = UILabel()
        return temp
    }()
    lazy var statusBoxView: StatusBoxView  = {
        let temp = StatusBoxView()
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
        setupTKStore()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        setupUIResponse()
        setupTKStore()
    }
    
    //MARK: - 处理状态变化
    func stateDidChanged(state: State, previousState: State?) {
        //处理状态变化
        if previousState == nil || previousState!.status != state.status {
            switch state.status {
            case .none:
                titleLabel.textColor = UIColor.gray
            case .doing:
                titleLabel.textColor = UIColor.black
            case .completed:
                titleLabel.textColor = UIColor.black
            }
        }
        
        if previousState == nil || previousState!.title != state.title {
            titleLabel.text = state.title
        }
    }
}

//MARK: - 用户界面交互反馈
extension ToDoView {
    
}

//MARK: - 代理事件
extension ToDoView: StatusBoxViewDelegate {
    func statusBoxView(_ statusBoxView: StatusBoxView, statusButtonTapped statusButton: UIButton, with status: ToDo.Status) {
        agent?.toDoView(self, statusBoxView: statusBoxView, statusButtonTapped: statusButton, with: status)
    }
}

//MARK: - 用户界面相关配置
extension ToDoView {
    
    func setupUI() {
        statusBoxView.agent = self
        addSubview(statusBoxView)
        statusBoxView.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(100)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.trailing.top.bottom.equalToSuperview()
            make.width.equalTo(150)
        }
    }
    
    func setupUIResponse() {

    }
    
}

//MARK: - 仓库相关配置
extension ToDoView {
    func setupTKStore() {
        store = TKStore<Action, State>(reducer: reducer, initialState: State())
        store.subscribe { [unowned self] state, previousState in
            self.stateDidChanged(state: state, previousState: previousState)
        }
        stateDidChanged(state: store.state, previousState: nil)
    }
}
