//
//  TestListCollectionViewController.swift
//  xListViewController_Example
//
//  Created by Mac on 2024/5/28.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import xListViewController

class TestListCollectionViewController: xDefaultListCollectionViewController {

    // MARK: - Override Property
    override var isAddHeaderRefresh: Bool { return true }
    override var isAddFooterRefresh: Bool { return true }
    override var isAutoRefresh: Bool { return true }
    override var xCellClass: xCollectionViewCell.Type { return TestListCollectionViewCell.self }
    
    // MARK: - Public Property
    
    // MARK: - Override Func
    override func viewDidLoad() {
        super.viewDidLoad()
        // 基本配置
        self.view.backgroundColor = .groupTableViewBackground
        self.flowLayout.reset(item: .init(width: 100, height: 100))
        self.isShowDataEmptyTip = true
    }
    
    // MARK: - 请求数据
    override func refreshDataList() {
        super.refreshDataList()
    }
    
    // MARK: - 点击Cell
    override func clickCell(at idp: IndexPath) {
        print("点击Cell\(idp.row)")
    }

}
