//
//  GBLoadingViewController.swift
//  Haptic
//
//  Created by Gennady Berezovsky on 22.01.18.
//  Copyright © 2018 Gennady Berezovsky. All rights reserved.
//

import UIKit

open class GBLoadingViewController: UIViewController {
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        activityIndicatorView.startAnimating()
        
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
    }

}
