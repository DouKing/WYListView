//
//  WYListCell.swift
//  WYListViewController
//
//  Created by iosci on 2016/10/20.
//  Copyright © 2016年 secoo. All rights reserved.
//

import UIKit

class WYListCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.configure(withSelected: selected)
    }
    
    func setup(withTitle title: String?) {
        self.titleLabel.text = title
    }
  
    private func configure(withSelected selected: Bool) {
        self.selectedImageView.isHidden = !selected
        if selected {
            self.titleLabel.font = UIFont.boldSystemFont(ofSize: 13)
        } else {
            self.titleLabel.font = UIFont.systemFont(ofSize: 13)
        }
    }
}
