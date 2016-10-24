//
//  WYContentCell.swift
//  WYListViewController
//
//  Created by iosci on 2016/10/22.
//  Copyright © 2016年 secoo. All rights reserved.
//

import UIKit

protocol WYContentCellDataSource {
    func numberOfRows(in contentCell: WYContentCell) -> Int
    func contentCell(_ cell: WYContentCell, titleForRow row: Int) -> String?
}

protocol WYContentCellDelegate {
    func contentCell(_ cell: WYContentCell, didSelectRow row: Int)
    func contentCell(_ cell: WYContentCell, didScrollTo offsetY: CGFloat)
}

class WYContentCell: UICollectionViewCell {

    var dataSource: WYContentCellDataSource?
    var delegate: WYContentCellDelegate?
    
    var section: Int = 0
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            let nib = UINib(nibName: "WYListCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: WYListCell.cellId)
        }
    }
    
    func reload(animated: Bool, selectRow row: Int? = nil, offsetY: CGFloat? = nil) {
        self.reload { [unowned self] in
            var indexPath: IndexPath?
            if let selectedRow = row {
                indexPath = IndexPath(row: selectedRow, section: 0)
                self.tableView.scrollToRow(at: indexPath!, at: .none, animated: animated)
            }
            self.tableView.selectRow(at: indexPath, animated: animated, scrollPosition: .none)
            if offsetY != nil {
                self.tableView.setContentOffset(CGPoint(x: self.tableView.contentOffset.x, y: offsetY!), animated: false)
            }
        }
    }

    func reload(completion: (() -> ())? = nil) {
        self.tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + TimeInterval(0.15)) {
            if completion != nil {
                completion!()
            }
        }
    }
    
}

extension WYContentCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = self.dataSource else {
            return 0
        }
        return dataSource.numberOfRows(in: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WYListCell.cellId, for: indexPath) as! WYListCell
        cell.setup(withTitle: self.dataSource?.contentCell(self, titleForRow: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.scrollToRow(at: indexPath, at: .none, animated: true)
        self.delegate?.contentCell(self, didSelectRow: indexPath.row)
        self.delegate?.contentCell(self, didScrollTo: tableView.contentOffset.y)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidEndScroll(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidEndScroll(scrollView)
    }
    
    private func scrollViewDidEndScroll(_ scrollView: UIScrollView) {
        self.delegate?.contentCell(self, didScrollTo: scrollView.contentOffset.y)
    }
}

fileprivate extension WYListCell {
    static let cellId = "kWYListCellId"
}
