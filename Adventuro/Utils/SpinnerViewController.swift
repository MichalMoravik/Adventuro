//
//  test.swift
//  Adventuro
//
//  Created by Michal Moravík on 13/06/2019.
//  Copyright © 2019 Michal Moravík. All rights reserved.
//

import Foundation
import UIKit

class SpinnerViewController: UIViewController {
    static let shared = SpinnerViewController()
    var spinner = UIActivityIndicatorView(style: .whiteLarge)
    override func loadView() {
        spinner.color = .black
        view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 1.0)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func startSpinner(targetViewController:UIViewController) {
        targetViewController.addChild(SpinnerViewController.shared)
        SpinnerViewController.shared.view.frame = targetViewController.view.frame
        targetViewController.view.addSubview(SpinnerViewController.shared.view)
        SpinnerViewController.shared.didMove(toParent: targetViewController)
    }
    
    func stopSpinner() {
        SpinnerViewController.shared.willMove(toParent: nil)
        SpinnerViewController.shared.view.removeFromSuperview()
        SpinnerViewController.shared.removeFromParent()
    }
}
