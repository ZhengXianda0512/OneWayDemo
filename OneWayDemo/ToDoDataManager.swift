//
//  ToDoDataManager.swift
//  OneWayDemo
//
//  Created by zhengxianda on 2018/4/12.
//  Copyright © 2018年 Toki. All rights reserved.
//

import Foundation

let dummy = [ToDo(title: "first", status: .doing),
             ToDo(title: "second", status: .completed),
             ToDo(title: "thrid", status: .doing)]

struct ToDoDataManager {
    static let shared = ToDoDataManager()
    
    func getToDoItems(completionHandler: (([ToDo]) -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completionHandler?(dummy)
        }
    }
}

struct ToDo {
    //UI状态
    enum Status {
        case none
        case doing
        case completed
    }
    
    var title: String = ""
    var status: Status = .none
}
