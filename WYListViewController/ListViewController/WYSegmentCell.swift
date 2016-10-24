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
    
    static let contentInsert: CGFloat = 40
    
    class func width(withTitle title: String?) -> CGFloat {
        let t = NSString(string: (title == nil) ? "请选择" : title!)
        let width = t.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0),
                                   options: [.usesFontLeading, .usesLineFragmentOrigin, .truncatesLastVisibleLine],
                                   attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 13)],
                                   context: nil).size.width
        return width + WYSegmentCell.contentInsert * 2
    }
    
    func setup(withTitle title: String?) {
        if let text = title {
            titleButton.setTitleColor(UIColor.black, for: .normal)
            titleButton.setTitle(text, for: .normal)
        } else {
            titleButton.setTitleColor(UIColor.lightGray, for: .normal)
            titleButton.setTitle("请选择", for: .normal)
        }
    }
}
