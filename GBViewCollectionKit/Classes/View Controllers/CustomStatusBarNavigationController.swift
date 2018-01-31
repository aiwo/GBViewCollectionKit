//
//  CustomStatusBarNavigationController.swift
//  UpsalesTest
//
//  Created by Gennady Berezovsky on 21.01.18.
//  Copyright © 2018 Gennady Berezovsky. All rights reserved.
//

import UIKit

class CustomStatusBarNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let viewController = self.viewControllers.last {
            return viewController.preferredStatusBarStyle
        }
        return .default
    }
    
}
