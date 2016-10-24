//
//  DetailViewController.swift
//  WYListViewController
//
//  Created by iosci on 2016/10/24.
//  Copyright © 2016年 secoo. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    lazy var dataSource: NSDictionary = {
        let path = Bundle.main.path(forResource: "test", ofType: "plist")
        let info = NSDictionary(contentsOfFile: path!)
        return info!
    }()
    
    lazy var provinces: [[String: String]] = {
        let provinces = self.dataSource["provinces"]
        return provinces! as! [[String : String]]
    }()
    
    lazy var cities: [String: [[String: String]]] = {
        let provinces = self.dataSource["cities"]
        return provinces! as! [String : [[String : String]]]
    }()
    
    lazy var areas: [String: [[String: String]]] = {
        let provinces = self.dataSource["areas"]
        return provinces! as! [String : [[String : String]]]
    }()

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
    }

}

// MARK: - WYListViewDataSource -
extension DetailViewController: WYListViewDataSource, WYListViewDelegate {
    func numberOfSections(in listView: WYListView) -> Int {
        return 5
    }
    
    func listView(_ listView: WYListView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func listView(_ listView: WYListView, titleForSection section: Int) -> String? {
        return "section:" + String(section)
    }
    
    func listView(_ listView: WYListView, titleForRowAtIndexPath indexPath: IndexPath) -> String? {
        return "section:" + String(indexPath.section) + ", row:" + String(indexPath.row)
    }
    
    func listView(_ listView: WYListView, didSelectRowAtIndexPath indexPath: IndexPath) {
        print("did select (\(indexPath.section), \(indexPath.row))")
    }
}
