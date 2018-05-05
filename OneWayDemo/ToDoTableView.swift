//
//  ToDoTableView.swift
//  OneWayDemo
//
//  Created by zhengxianda on 2018/4/16.
//  Copyright © 2018年 Toki. All rights reserved.
//

import UIKit

protocol ToDoTableViewDelegate {
    func toDoTableView(_ toDoTableView: ToDoTableView, toDoTableViewCell: ToDoTableViewCell, toDoView: ToDoView, statusBoxView: StatusBoxView, statusButtonTapped statusButton: UIButton, with status: ToDo.Status)
}

class ToDoTableView: UITableView {

    //代理
    var agent: ToDoTableViewDelegate?
    
    //MARK: - 状态
    struct State: StateType {
        var toDoList: [ToDo] = []
        var sectionCount: Int = 0
        var toDoCellEvent: ToDoTableViewCell.Action?
    }
    
    //MARK: - 事件
    enum Action: ActionType {
        case updateToDoList(toDoList: [ToDo])
        case updateToDoCellEvent(cellEvent: ToDoTableViewCell.Action?)
    }
    
    //MARK: - 关联 事件、状态变化、异步命令
    lazy var reducer: (Action, State) -> State = { [unowned self] (action: Action, state: State) in
        var state:State = state
        
        switch action {
        case .updateToDoList(let toDoList):
            state.toDoList = toDoList
            state.sectionCount = state.toDoList.count
        case .updateToDoCellEvent(let toDoCellEvent):
            state.toDoCellEvent = toDoCellEvent
        }
        return (state)
    }
    
    //MARK: - 仓库
    var store: TKStore<Action, State>!
    
    // MARK: - 用户界面相关属性
    
    // MARK: - 初始化
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
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
        //处理状态变化
        if previousState == nil || !previousState!.toDoList.elementsEqual(state.toDoList, by: { (toDo, newToDo) -> Bool in
            return toDo.title == newToDo.title &&
                toDo.status == newToDo.status
        }) {
            reloadData()
        }
    }
    
}

extension ToDoTableView: UITableViewDelegate {
    
}

extension ToDoTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.state.sectionCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoTableViewCell.identify, for: indexPath) as? ToDoTableViewCell ?? ToDoTableViewCell()
        cell.agent = self
        
        let toDo = store.state.toDoList[indexPath.row]
        cell.store.dispatch(.toDoView(action: .updateTitle(title: toDo.title)))
        cell.store.dispatch(.toDoView(action: .updateStatus(status: toDo.status)))
        cell.store.dispatch(.toDoView(action: .statusBoxView(action: .updateStatus(status: toDo.status))))
        
        if let toDoCellEvent = store.state.toDoCellEvent {
            cell.store.dispatch(toDoCellEvent)
        }
        
        return cell as UITableViewCell
    }
}

extension ToDoTableView: ToDoTableViewCellDelegate {
    func toDoTableViewCell(_ toDoTableViewCell: ToDoTableViewCell, toDoView: ToDoView, statusBoxView: StatusBoxView, statusButtonTapped statusButton: UIButton, with status: ToDo.Status) {
        agent?.toDoTableView(self, toDoTableViewCell: toDoTableViewCell, toDoView: toDoView, statusBoxView: statusBoxView, statusButtonTapped: statusButton, with: status)
    }
}

//MARK: - 用户界面相关配置
extension ToDoTableView {
    
    func setupUI() {
        delegate = self
        dataSource = self
        register(ToDoTableViewCell.self, forCellReuseIdentifier: ToDoTableViewCell.identify)
    }
    
    func setupUIResponse() {
        
    }
    
}

//MARK: - 仓库相关配置
extension ToDoTableView {
    func setupStore() {
        store = TKStore<Action, State>(reducer: reducer, initialState: State())
        store.subscribe { [unowned self] state, previousState in
            self.stateDidChanged(state: state, previousState: previousState)
        }
        stateDidChanged(state: store.state, previousState: nil)
    }
}
