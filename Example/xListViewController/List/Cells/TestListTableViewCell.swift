//
//  TestListTableViewCell.swift
//  xListViewController_Example
//
//  Created by Mac on 2024/5/28.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import xModel
import xListViewController

class TestListTableViewCell: xTableViewCell {

    // MARK: - IBOutlet Property
    
    // MARK: - Public Property
    
    // MARK: - Override Func
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - 内容填充
    /// 普通填充
    override func setContentData(in tvc: xTableViewController? = nil,
                                 at idp: IndexPath,
                                 with model: xModel)
    {
        self.contentView.backgroundColor = .xNewRandom(alpha: 0.3)
    }
    
    // MARK: - 内容高度
    /// 内容高度
    override class func contentHeight() -> CGFloat
    {
        var h = CGFloat.zero
        h += 60
        return h
    }
    
}
