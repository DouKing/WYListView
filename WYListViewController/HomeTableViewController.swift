//
//  HomeTableViewController.swift
//  WYListViewController
//
//  Created by iosci on 2016/10/19.
//  Copyright © 2016年 secoo. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Private Methods -
    
    func _handleClosePresentAction() -> Void {
        self.dismiss(animated: true, completion: nil)
    }

}

// MARK: - WYListViewControllerDataSource -
extension HomeTableViewController: WYListViewControllerDataSource {
    func numberOfSections(in listViewController: WYListViewController) -> Int {
        return 10
    }
    
    func listViewController(_ listVC: WYListViewController, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func listViewController(_ listVC: WYListViewController, titleForSection section: Int) -> String? {
        return "section:" + String(section)
    }
    
    func listViewController(_ listVC: WYListViewController, titleForRowAtIndexPath indexPath: IndexPath) -> String? {
        return "row:" + String(indexPath.row)
    }
}

// MARK: - Table view data source -
extension HomeTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        switch indexPath.row {
            case 0: cell.textLabel?.text = "PUSH"
            case 1: cell.textLabel?.text = "Present in navigation"
            case 2: cell.textLabel?.text = "Present"
            default:break
        }
        cell.textLabel?.text = "\(indexPath.row)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let listVC = WYListViewController()
        listVC.dataSource = self
        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(listVC, animated: true)
        case 1:
            let nav = UINavigationController(rootViewController: listVC)
            nav.navigationBar.isTranslucent = false
            nav.setAnimateStyle(.normal)
            listVC.title = "呵呵"
            listVC.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(_handleClosePresentAction))
            self.present(nav, animated: true, completion: nil)
        case 2:
            listVC.setAnimateStyle(.normal)
            self.present(listVC, animated: true, completion: nil)
        default: break
        }
    }

}
