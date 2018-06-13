//
//  ViewController.swift
//  OneWayDemoProtocol
//
//  Created by zhengxianda on 2018/6/13.
//  Copyright © 2018年 Toki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var actionButton : UIButton = {
        let temp = UIButton()
        return temp
    }()
    
    lazy var person : Person = {
        let temp = Person()
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
        person.updateName("name")
        person.updateGender("gender")
        person.updateStature(Stature(height: 99, weight: 66))
        
        person.dispatch(PersonAction(.updateGender(gender: "dispatch-gender")))
        person.dispatch(PersonAction(.updateName(name: "dispatch-name")))
        person.dispatch(PersonAction(.updateStature(stature: Stature(height: 299, weight: 266))))

        person.query()
    }

}

