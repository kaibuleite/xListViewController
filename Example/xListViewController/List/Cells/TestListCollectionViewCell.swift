//
//  TestListCollectionViewCell.swift
//  xListViewController_Example
//
//  Created by Mac on 2024/5/28.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import xModel
import xListViewController

class TestListCollectionViewCell: xCollectionViewCell {

    // MARK: - IBOutlet Property
    
    // MARK: - Public Property
    
    // MARK: - Override Func
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - 内容填充
    /// 普通填充
    override func setContentData(in cvc: xCollectionViewController? = nil,
                                 at idp: IndexPath,
                                 with model: xModel)
    {
        self.backgroundColor = .xNewRandom(alpha: 0.3)
    }
    
    // MARK: - 内容大小
    /// 内容大小
    override class func contentSize() -> CGSize
    {
        var size = CGSize.zero
        size.width = 100
        size.height = 100
        return size
    }
    
}
