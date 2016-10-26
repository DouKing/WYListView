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
    
    @IBAction func presentAction(_ sender: UIBarButtonItem) {
        let listVC = WYListView()
        listVC.dataSource = self
        listVC.transitioningDelegate = self
        listVC.modalPresentationStyle = .custom
        self.present(listVC, animated: true, completion: nil)
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
                    nav.navigationBar.clipsToBounds = true
                    nav.navigationBar.isTranslucent = false
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

// MARK: - WYListViewDataSource -
extension HomeTableViewController: WYListViewDataSource {
    func numberOfSections(in listView: WYListView) -> Int {
        return 5
    }
    
    func listView(_ listView: WYListView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func listView(_ listView: WYListView, titleForSection section: Int) -> String? {
        return "section:\(section)"
    }
    
    func listView(_ listView: WYListView, titleForRowAtIndexPath indexPath: IndexPath) -> String? {
        return "section: \(indexPath.section), row: \(indexPath.row)"
    }
    
}
