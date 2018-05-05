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
    
    //MARK: - 事件
    enum Action: ActionType {
        case queryToDoList
        case toDoTableView(action: ToDoTableView.Action)
    }
    
    //MARK: - 关联 事件、状态变化、异步命令
    lazy var reducer: (Action, State) -> State = { [unowned self] (action: Action, state: State) in
        
        var state:State = state
        
        switch action {
        case .queryToDoList:
            ToDoDataManager.shared.getToDoItems(completionHandler: { (toDoList) in
                self.store.dispatch(.toDoTableView(action: .updateToDoList(toDoList: toDoList)))
            })
        case .toDoTableView(let action):
            self.toDoTableView.store.dispatch(action)
        }
        return state
    }
    
    //MARK: - 仓库
    var store: TKStore<Action, State>!
    
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

    //MARK: - 处理状态变化
    func stateDidChanged(state: State, previousState: State?) {
        
    }
}

//MARK: - 代理事件
extension ViewController: ToDoTableViewDelegate {
    func toDoTableView(_ toDoTableView: ToDoTableView, toDoTableViewCell: ToDoTableViewCell, toDoView: ToDoView, statusBoxView: StatusBoxView, statusButtonTapped statusButton: UIButton, with status: ToDo.Status) {
//        switch status {
//        case .none:
//            break
//        case .doing:
//            statusBoxView.store.dispatch(.updateStatus(status: .completed))
//        case .completed:
//            statusBoxView.store.dispatch(.updateStatus(status: .doing))
//        }
    }
}


//MARK: - 用户界面相关配置
extension ViewController {
    
    func setupUI() {
        toDoTableView.agent = self
        toDoTableView.allowsSelection = false
        view.addSubview(toDoTableView)
        toDoTableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func setupUIResponse() {
        
    }
}

//MARK: - 仓库相关配置
extension ViewController {
    func setupStore() {
        store = TKStore<Action, State>(reducer: reducer, initialState: State())
        store.subscribe { [unowned self] state, previousState in
            self.stateDidChanged(state: state, previousState: previousState)
        }
        
        store.dispatch(.toDoTableView(action:
            .updateToDoCellEvent(cellEvent:
              .toDoView(action:
                .statusBoxView(action:
                    .updateChangeStatusEvent(changeStatusEvent: { (statusBoxView, status) in
                        switch status {
                        case .none:
                            break
                        case .doing:
                            statusBoxView.store.dispatch(.updateStatus(status: .completed))
                        case .completed:
                            statusBoxView.store.dispatch(.updateStatus(status: .doing))
                        }
                    }))))))
        
        stateDidChanged(state: store.state, previousState: nil)
    }
}
