//
//  xDefaultListTableViewController.swift
//  xListViewController
//
//  Created by Mac on 2022/7/6.
//

import UIKit
import xModel

// MARK: - 初始化列表
open class xDefaultListTableViewController: xListTableViewController {
    
    // MARK: - Public Property
    open var xCellClass : xTableViewCell.Type {
        return xTableViewCell.self
    }
    
    // MARK: - Override Func
    open override func viewDidLoad() {
        super.viewDidLoad()
        // 基本配置
        let height = self.xCellClass.contentHeight()
        self.tableView.rowHeight = height
    }
    
    // MARK: - 注册Cell
    /// 注册Cell
    open override func registerCells() {
        self.xCellClass.register(in: self, identifier: "Cell")
    }
    
}
