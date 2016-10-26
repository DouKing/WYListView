//
//  DetailViewController.swift
//  WYListViewController
//
//  Created by iosci on 2016/10/24.
//  Copyright © 2016年 secoo. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    enum AddressType: Int {
        case province, city, area
    }
    var sectionDataSource: [String?] = [nil]
    var selectedRows: [Int?] = [nil, nil, nil]
    
    let name = "n"
    let code = "c"

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
        return self.sectionDataSource.count
    }
    
    func listView(_ listView: WYListView, numberOfRowsInSection section: Int) -> Int {
        guard let type = AddressType(rawValue: section) else {
            return 0
        }
        switch type {
        case .province:
            return self.provinces.count
        case .city:
            guard let index = self.selectedRows[AddressType.province.rawValue] else { return 0 }
            guard let code = self.provinces[index][self.code] else { return 0 }
            guard let cities = self.cities[code] else { return 0 }
            return cities.count
        case .area:
            guard let index = self.selectedRows[AddressType.province.rawValue] else { return 0 }
            guard let code = self.provinces[index][self.code] else { return 0 }
            guard let cities = self.cities[code] else { return 0 }
            
            guard let idx = self.selectedRows[AddressType.city.rawValue] else { return 0 }
            guard let c = cities[idx][self.code] else { return 0 }
            guard let areas = self.areas[c] else { return 0 }
            return areas.count
        }
    }
    
    func listView(_ listView: WYListView, titleForSection section: Int) -> String? {
        return self.sectionDataSource[section]
    }
    
    func listView(_ listView: WYListView, titleForRowAtIndexPath indexPath: IndexPath) -> String? {
        guard let type = AddressType(rawValue: indexPath.section) else {
            return nil
        }
        switch type {
        case .province:
            return self.provinces[indexPath.row][self.name]
        case .city:
            guard let index = self.selectedRows[AddressType.province.rawValue] else { return nil }
            guard let code = self.provinces[index][self.code] else { return nil }
            guard let cities = self.cities[code] else { return nil }
            return cities[indexPath.row][self.name]
        case .area:
            guard let index = self.selectedRows[AddressType.province.rawValue] else { return nil }
            guard let code = self.provinces[index][self.code] else { return nil }
            guard let cities = self.cities[code] else { return nil }
            
            guard let idx = self.selectedRows[AddressType.city.rawValue] else { return nil }
            guard let c = cities[idx][self.code] else { return nil }
            guard let areas = self.areas[c] else { return nil }
            return areas[indexPath.row][self.name]
        }
    }
    
    func listView(_ listView: WYListView, didSelectRowAtIndexPath indexPath: IndexPath) {
        let row = self.selectedRows[indexPath.section]
        
        self.selectedRows[indexPath.section] = indexPath.row
        self.sectionDataSource[indexPath.section] = self.listView(listView, titleForRowAtIndexPath: indexPath)
        
        if let selectedRow = row {
            if selectedRow != indexPath.row {
                
            }
        }
        
        if let selectedRow = row, selectedRow == indexPath.row {
        } else {
            self.selectedRows.remove(after: indexPath.section)
            self.sectionDataSource.remove(after: indexPath.section)
            if indexPath.section < AddressType.area.rawValue {
                self.sectionDataSource.append(nil)
                for _ in (indexPath.section + 1)...AddressType.area.rawValue {
                    self.selectedRows.append(nil)
                }
            }
        }
        
        var selectedIndexPaths: [IndexPath] = []
        for (idx, row) in self.selectedRows.enumerated() {
            if row != nil {
                selectedIndexPaths.append(IndexPath(row: row!, section: idx))
            }
        }
        listView.reloadData(selectRowsAtIndexPaths: selectedIndexPaths)
        listView.scroll(to: min(indexPath.section + 1, AddressType.area.rawValue), animated: true, after: 0.3)
    }
}

extension Array {
    mutating func remove(after index: Int) {
        while self.count > index + 1 {
            self.removeLast()
        }
    }
}
