//
//  ViewController.swift
//  OneWayDemo
//
//  Created by zhengxianda on 2018/4/11.
//  Copyright © 2018年 Toki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var actionButton : UIButton = {
        let temp = UIButton()
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actionButton.backgroundColor = UIColor.gray
        actionButton.setTitle("Action", for: UIControlState.normal)
        actionButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        view.addSubview(actionButton)
        actionButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
        
        actionButton.addTarget(self, action: #selector(action), for: UIControlEvents.touchUpInside)
    }
    
    @objc func action() {
       navigationController?.pushViewController(ToDoViewController(), animated: true)
    }
    
}

