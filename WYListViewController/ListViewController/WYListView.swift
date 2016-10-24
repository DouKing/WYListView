//
//  WYListViewController.swift
//  WYListViewController
//
//  Created by iosci on 2016/10/20.
//  Copyright © 2016年 secoo. All rights reserved.
//

import UIKit

@objc
public protocol WYListViewDataSource {
    func numberOfSections(in listView: WYListView) -> Int
    func listView(_ listView: WYListView, numberOfRowsInSection section: Int) -> Int
    func listView(_ listView: WYListView, titleForSection section: Int) -> String?
    func listView(_ listView: WYListView, titleForRowAtIndexPath indexPath: IndexPath) -> String?
    
    @objc optional func listView(_ listView: WYListView, selectRowInSection section: Int) -> NSNumber? //@objc不支持Int?
    @objc optional func sectionHeight(in listView: WYListView) -> CGFloat
    @objc optional func listView(_ listView: WYListView, rowHeightAtIndexPath indexPath: IndexPath) -> CGFloat
}

open class WYListView: UIViewController {
    
    fileprivate let tableViewBaseTag: Int = 2000
    fileprivate var currentSection: Int?
    public var dataSource: WYListViewDataSource?
    
    fileprivate weak var floatView: UIView?
    
    @IBOutlet fileprivate weak var segmentView: UICollectionView! {
        didSet {
            segmentView.dataSource = self
            segmentView.delegate = self
            let nib = UINib(nibName: "WYSegmentCell", bundle: nil)
            segmentView.register(nib, forCellWithReuseIdentifier: WYSegmentCell.cellId)
            
            let floatView = UIView(frame: .zero)
            floatView.backgroundColor = .red
            floatView.alpha = 0
            self.floatView = floatView
            segmentView.addSubview(floatView)
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
    
    deinit {
        self.endObserveDeviceOrientation()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.observeDeviceOrientation()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.observeDeviceOrientation()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + TimeInterval(0.15)) {
            [unowned self] in
            self.scrollToLastSection(animated: false)
        }
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let flowLayout = self.contentView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = self.contentView.bounds.size
    }
    
    private func observeDeviceOrientation() {
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(handleDeviceOrientationNotification(_:)), name: Notification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    private func endObserveDeviceOrientation() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIDeviceOrientationDidChange, object: nil)
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
    
    private func changeCollectionViewLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = self.contentView.bounds.size
        self.contentView.setCollectionViewLayout(flowLayout, animated: true)
        if let section = self.currentSection {
            self.scroll(to: section, animated: false)
        }
    }
    
    @objc private func handleDeviceOrientationNotification(_ note: Notification) {
        self.changeCollectionViewLayout()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource -
extension WYListView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
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
            let title = dataSource.listView(self, titleForSection: indexPath.item)
            cell.setup(withTitle: title)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WYContentCell.cellId, for: indexPath) as! WYContentCell
        guard let dataSource = self.dataSource else {
            return cell
        }
        let title = dataSource.listView(self, titleForRowAtIndexPath: IndexPath(row: 0, section: indexPath.row))
        cell.titleLabel.text = title
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.scroll(to: indexPath.item, animated: true)
    }
}

// MARK: - Scroll -
extension WYListView {
    
    fileprivate func scrollToLastSection(animated: Bool, completion: (() -> Swift.Void)? = nil) {
        guard let dataSource = self.dataSource else {
            return
        }
        let number = dataSource.numberOfSections(in: self)
        if number < 1 {
            return
        }
        self.scroll(to: number - 1, animated: animated, completion: completion)
    }
    
    fileprivate func scroll(to section: Int, animated: Bool, completion: (() -> Swift.Void)? = nil) {
        guard let dataSource = self.dataSource else {   return  }
        let number = dataSource.numberOfSections(in: self)
        self.currentSection = min(max(section, 0), number - 1)
        let indexPath = IndexPath(item: self.currentSection!, section: 0)
        self.segmentView.scrollToItem(at: indexPath, at: .init(rawValue: 0), animated: animated)
        self.contentView.scrollToItem(at: indexPath, at: .init(rawValue: 0), animated: animated)
        
        let layoutAttributes = self.segmentView.collectionViewLayout.initialLayoutAttributesForAppearingItem(at: indexPath)
        var rect = CGRect.zero
        if let lab = layoutAttributes {
            rect = lab.frame
        }
        let insert: CGFloat = 40, height: CGFloat = 2
        let frame = CGRect(x: rect.origin.x + insert, y: rect.size.height - height,
                           width: rect.size.width - insert * 2, height: height)
        if animated {
            UIView.animate(withDuration: 0.25, animations: { [unowned self] in
                self.floatView?.frame = frame
            }) { [unowned self] (finished) in
                self.floatView?.alpha = 1
            }
        } else {
            self.floatView?.frame = frame
            self.floatView?.alpha = 1
            if completion != nil {
                completion!()
            }
        }
    }
    
    private func scrollViewDidEndScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.contentView else {
            return
        }
        let section = scrollView.contentOffset.x / scrollView.bounds.size.width
        self.scroll(to: Int(section), animated: true)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidEndScroll(scrollView)
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
