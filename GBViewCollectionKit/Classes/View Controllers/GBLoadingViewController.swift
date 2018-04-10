//
//  GBLoadingViewController.swift
//  UpsalesTest
//
//  Created by Gennady Berezovsky on 22.01.18.
//  Copyright © 2018 Gennady Berezovsky. All rights reserved.
//

import UIKit

open class GBLoadingViewController: UIViewController {

    @IBOutlet var activityIndicator: UIActivityIndicatorView?
    @IBOutlet var textLabel: UILabel?
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        activityIndicatorView.startAnimating()
        
        self.textLabel?.text = ""
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
    }

}
