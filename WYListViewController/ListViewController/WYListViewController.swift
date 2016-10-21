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
    
    @IBOutlet private weak var segmentView: UICollectionView!
    @IBOutlet private weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.configureSegmentView()
        self.setupTableViews()
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
        self.configureScrollViewContent()
    }
    
    private func configureSegmentView() {
        self.segmentView.dataSource = self
        self.segmentView.delegate = self
        let nib = UINib(nibName: "WYSegmentCell", bundle: nil)
        self.segmentView.register(nib, forCellWithReuseIdentifier: WYSegmentCell.cellId)
    }
    
    private func setupTableViews() {
        guard let dataSource = self.dataSource else {
            return
        }
        let number = dataSource.numberOfSections(in: self)
        for i in 0..<number {
            let tableView = UITableView(frame: .zero, style: .plain)
            tableView.tag = i + tableViewBaseTag
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            let nib = UINib(nibName: "WYListCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: WYListCell.cellId)
            self.scrollView.addSubview(tableView)
        }
    }
    
    private func configureScrollViewContent() {
        var number: Int = 0
        if let dataSource = self.dataSource {
            number = dataSource.numberOfSections(in: self)
        }
        let width = self.scrollView.frame.size.width
        let height = self.scrollView.frame.size.height
        
        self.scrollView.contentSize = CGSize(width: CGFloat(number) * width, height: 0)
        for i in 0..<number {
            let tag = i + tableViewBaseTag
            let tableView = self.scrollView.viewWithTag(tag)!
            let frame = CGRect(x: CGFloat(i) * width, y: 0, width: width, height: height)
            tableView.frame = frame
        }
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WYSegmentCell.cellId, for: indexPath) as! WYSegmentCell
        guard let dataSource = self.dataSource else {
            return cell
        }
        let title = dataSource.listViewController(self, titleForSection: indexPath.item)
        cell.setup(withTitle: title)
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
