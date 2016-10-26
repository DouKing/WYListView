//
//  IBDesignableOnePixelConstant.swift
//  WYListViewController
//
//  Created by iosci on 2016/10/20.
//  Copyright © 2016年 secoo. All rights reserved.
//

import UIKit

@IBDesignable
class WYDesignablePixelConstant: NSLayoutConstraint {
    @IBInspectable var pixelConstant: Int = 0 {
        didSet {
            self.constant = CGFloat(pixelConstant) / UIScreen.main.scale
        }
    }
}

@IBDesignable
class WYCollectionViewFlowLayout: UICollectionViewFlowLayout {
    @IBInspectable var estimatedItemSizeConstant: CGSize = .zero {
        didSet {
            self.estimatedItemSize = estimatedItemSizeConstant
        }
    }
}
