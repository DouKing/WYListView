//
//  WYSegmentCell.swift
//  WYListViewController
//
//  Created by iosci on 2016/10/20.
//  Copyright © 2016年 secoo. All rights reserved.
//

import UIKit

class WYSegmentCell: UICollectionViewCell {

    @IBOutlet weak var titleButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(withTitle title: String?) {
        titleButton.setTitle(title, for: .normal)
    }
}
