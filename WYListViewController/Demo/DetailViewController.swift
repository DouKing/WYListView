//
//  DetailViewController.swift
//  WYListViewController
//
//  Created by iosci on 2016/10/26.
//  Copyright © 2016年 secoo. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        let listVC = WYListView()
        listVC.dataSource = self
        listVC.delegate = self
        listVC.view.frame = self.contentView.bounds
        self.addChildViewController(listVC)
        self.contentView.addSubview(listVC.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - WYListViewDataSource -
extension DetailViewController: WYListViewDataSource, WYListViewDelegate {
    func numberOfSections(in listView: WYListView) -> Int {
        return 10
    }
    
    func listView(_ listView: WYListView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func listView(_ listView: WYListView, titleForSection section: Int) -> String? {
        return "section:\(section)"
    }
    
    func listView(_ listView: WYListView, titleForRowAtIndexPath indexPath: IndexPath) -> String? {
        return "section: \(indexPath.section), row: \(indexPath.row)"
    }
    
    func listView(_ listView: WYListView, didSelectRowAtIndexPath indexPath: IndexPath) {
        print("select: \(indexPath.section, indexPath.row)")
    }
}
