//
//  TestListTableViewController.swift
//  xListViewController_Example
//
//  Created by Mac on 2024/5/28.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import xListViewController

class TestListTableViewController: xDefaultListTableViewController {

    
    // MARK: - Override Property
    override var isAddHeaderRefresh: Bool { return false }
    override var isAddFooterRefresh: Bool { return false }
    override var isAutoRefresh: Bool { return false }
    override var xCellClass: xTableViewCell.Type { return TestListTableViewCell.self }
    
    // MARK: - Public Property
    
    // MARK: - Override Func
    override func viewDidLoad() {
        super.viewDidLoad()
        // 基本配置
        self.view.backgroundColor = .groupTableViewBackground
        self.tableView.separatorStyle = .none
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
