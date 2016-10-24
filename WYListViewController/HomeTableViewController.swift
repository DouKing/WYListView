//
//  HomeTableViewController.swift
//  WYListViewController
//
//  Created by iosci on 2016/10/19.
//  Copyright © 2016年 secoo. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc private func _handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            if id.hasPrefix("present") {
                let nav = segue.destination as! UINavigationController
                let rootVC = nav.viewControllers.first
                rootVC?.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(_handleDismiss))
                if id == "presentAnimation" {
                    nav.transitioningDelegate = self
                    nav.modalPresentationStyle = .custom
                }
            }
        }
    }
}

extension HomeTableViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return WYListPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
