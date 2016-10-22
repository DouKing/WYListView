//
//  WYListViewController.swift
//  WYListViewController
//
//  Created by iosci on 2016/10/20.
//  Copyright © 2016年 secoo. All rights reserved.
//

import UIKit

@objc
public protocol WYListViewControllerDataSource {
    func numberOfSections(in listViewController: WYListViewController) -> Int
    func listViewController(_ listVC: WYListViewController, numberOfRowsInSection section: Int) -> Int
    func listViewController(_ listVC: WYListViewController, titleForSection section: Int) -> String?
    func listViewController(_ listVC: WYListViewController, titleForRowAtIndexPath indexPath: IndexPath) -> String?
    
    @objc optional func listViewController(_ listVC: WYListViewController, selectRowInSection section: Int) -> NSNumber? //@objc不支持Int?
    @objc optional func sectionHeight(in listViewController: WYListViewController) -> CGFloat
    @objc optional func listViewController(_ listVC: WYListViewController, rowHeightAtIndexPath indexPath: IndexPath) -> CGFloat
}

public enum WYListViewControllerAnimateStyle {
    case normal, system
}

public extension UIViewController {
    func setAnimateStyle(_ animateStyle: WYListViewControllerAnimateStyle) {
        switch animateStyle {
        case .normal:
            var vc = self
            if let nav = self as? UINavigationController {
                vc = nav.viewControllers.first!
            }
            if let listVC = vc as? WYListViewController {
                self.modalPresentationStyle = .custom
                self.transitioningDelegate = listVC.animateController
            }
        default:
            self.modalPresentationStyle = .fullScreen
            self.transitioningDelegate = nil
            break
        }
    }
}

open class WYListViewController: UIViewController {
    
    private var navigationBarTranslucent: Bool?
    fileprivate let tableViewBaseTag: Int = 2000
    fileprivate let animateController: WYListAnimateController = WYListAnimateController()
    public var dataSource: WYListViewControllerDataSource?
    
    @IBOutlet fileprivate weak var segmentView: UICollectionView! {
        didSet {
            segmentView.dataSource = self
            segmentView.delegate = self
            let nib = UINib(nibName: "WYSegmentCell", bundle: nil)
            segmentView.register(nib, forCellWithReuseIdentifier: WYSegmentCell.cellId)
        }
    }
    
    @IBOutlet fileprivate weak var contentView: UICollectionView! {
        didSet {
            contentView.dataSource = self
            contentView.delegate = self
            let nib = UINib(nibName: "WYContentCell", bundle: nil)
            contentView.register(nib, forCellWithReuseIdentifier: WYContentCell.cellId)
        }
    }
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationBarTranslucent = self.navigationController?.navigationBar.isTranslucent
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let translucent = self.navigationBarTranslucent {
            self.navigationController?.navigationBar.isTranslucent = translucent
        }
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let flowLayout = self.contentView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = self.contentView.bounds.size
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource -
extension WYListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let dataSource = self.dataSource else {
            return 0
        }
        return dataSource.numberOfSections(in: self)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.segmentView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WYSegmentCell.cellId, for: indexPath) as! WYSegmentCell
            guard let dataSource = self.dataSource else {
                return cell
            }
            let title = dataSource.listViewController(self, titleForSection: indexPath.item)
            cell.setup(withTitle: title)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WYContentCell.cellId, for: indexPath) as! WYContentCell
        guard let dataSource = self.dataSource else {
            return cell
        }
        let title = dataSource.listViewController(self, titleForRowAtIndexPath: IndexPath(row: 0, section: indexPath.row))
        cell.titleLabel.text = title
        return cell
        
    }
}

// MARK: -UITableViewDataSource, UITableViewDelegate -
extension WYListViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = self.dataSource else {
            return 0
        }
        let index = tableView.tag - self.tableViewBaseTag
        return dataSource.listViewController(self, numberOfRowsInSection: index)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WYListCell.cellId, for: indexPath) as! WYListCell
        guard let dataSource = self.dataSource else {
            return cell
        }
        let section = tableView.tag - self.tableViewBaseTag
        let title = dataSource.listViewController(self, titleForRowAtIndexPath: IndexPath(row: indexPath.row, section: section))
        cell.setup(withTitle: title)
        return cell
    }
}

fileprivate extension WYSegmentCell {
    static let cellId = "kWYSegmentCellId"
}

fileprivate extension WYListCell {
    static let cellId = "kWYListCellId"
}

fileprivate extension WYContentCell {
    static let cellId = "kWYContentCellId"
}
