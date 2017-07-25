//
//  TabbarViewController.swift
//  projectCoin
//
//  Created by Apple on 14.07.17.
//  Copyright © 2017 kumardastan. All rights reserved.
//

import UIKit
import SCLAlertView

import EasyPeasy

class TabbarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let titles = ["Main", "Edit"]
        for (index, item) in (self.tabBar.items?.enumerated())! {
            item.image = UIImage(named: "\(index)")
            item.title = titles[index]
        }
    }
    
}


