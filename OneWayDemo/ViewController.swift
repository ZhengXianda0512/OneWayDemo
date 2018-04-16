//
//  ViewController.swift
//  OneWayDemo
//
//  Created by zhengxianda on 2018/4/11.
//  Copyright © 2018年 Toki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - 状态
    struct State: StateType {
        var toDoList: [ToDo] = []
        var sectionCount: Int = 0
    }
    
    //MARK: - 异步命令
    enum Command: CommandType {
        case queryToDoList(completionHandler: (([ToDo]) -> Void)?)
    }
    
    //MARK: - 事件
    enum Action: ActionType {
        case queryToDoList
        case toDoTableView(action: ToDoTableView.Action)
    }
    
    //MARK: - 关联 事件、状态变化、异步命令
    lazy var reducer: (State, Action) -> (state: State, command: Command?) = { [unowned self] (state: State, action: Action) in
        
        var state:State = state
        var command: Command? = nil
        
        switch action {
        case .queryToDoList:
            command = Command.queryToDoList(completionHandler: { [unowned self] (toDoList) in
                self.store.dispatch(.toDoTableView(action: .updateToDoList(toDoList: toDoList)))
            })
        case .toDoTableView(let action):
            self.toDoTableView.store.dispatch(action)
        }
        return (state, command)
    }
    
    //MARK: - 仓库
    var store: Store<Action, State, Command>!
    
    //用户界面属性
    lazy var toDoTableView: ToDoTableView = {
        let temp = ToDoTableView()
        return temp
    }()
    
    //生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupUIResponse()
        setupStore()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.store.dispatch(.queryToDoList)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            case .queryToDoList(let completionHandler):
                ToDoDataManager.shared.getToDoItems(completionHandler: completionHandler)
            }
        }
    }
}

//MARK: - 代理事件
extension ViewController: ToDoTableViewDelegate {
    func toDoTableView(_ toDoTableView: ToDoTableView, toDoTableViewCell: ToDoTableViewCell, toDoView: ToDoView, statusBoxView: StatusBoxView, statusButtonTapped statusButton: UIButton, with status: ToDo.Status) {
        switch status {
        case .none:
            break
        case .doing:
            statusBoxView.store.dispatch(.updateStatus(status: .completed))
        case .completed:
            statusBoxView.store.dispatch(.updateStatus(status: .doing))
        }
    }
}


//MARK: - 用户界面相关配置
extension ViewController {
    
    func setupUI() {
        toDoTableView.agent = self
        view.addSubview(toDoTableView)
        toDoTableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func setupUIResponse() {
        
    }
    
}
