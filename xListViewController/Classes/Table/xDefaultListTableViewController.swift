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
    open var isAddRefresh : Bool { return true }
    open var isAutoRefresh : Bool { return true }
    open var xCellClass : xTableViewCell.Type {
        return xTableViewCell.self
    }
    
    // MARK: - Override Func 
    open override func viewDidLoad() {
        super.viewDidLoad()
        // 基本配置
        self.view.backgroundColor = .clear
        self.tableView.backgroundColor = .clear
    }
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard self.isAutoRefresh else { return }
        self.refreshHeader()
    }
    
    // TODO: - 点击Cell
    /// 点击Cell
    open func clickCell(at idp : IndexPath)
    {
        // 子类实现具体操作
    }
    
}

// MARK: - 数据刷新
extension xDefaultListTableViewController {
    
    open override func addMJRefresh() {
        guard self.isAddRefresh else { return }
        self.addHeaderRefresh()
        self.addFooterRefresh()
    }
    open override func refreshDataList() {
        // 模拟数据
        let list = xModel.newRandomList()
        self.reloadData(list: list)
        self.refreshSuccess()
    }
}

// MARK: - Cell数据
extension xDefaultListTableViewController {
    
    // MARK: - 注册Cell
    /// 注册Cell
    open override func registerCells() {
        xCellClass.register(in: self, identifier: "Cell")
    }
    
    // MARK: - 默认Cell
    /// 默认Cell
    open func defaultCell(at idp : IndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: idp) as! xTableViewCell
        // 数据填充
        let model = self.dataArray[idp.row]
        cell.setContentData(in: self, at: idp, with: model)
        
        return cell
    }
}

// MARK: - Table view data source
extension xDefaultListTableViewController {
    
    open override func tableView(_ tableView: UITableView,
                                 numberOfRowsInSection section: Int) -> Int
    {
        return self.dataArray.count
    }
    open override func tableView(_ tableView: UITableView,
                                 cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        return defaultCell(at: indexPath)
    }
}

// MARK: - Table view delegate
extension xDefaultListTableViewController {
    
    open override func tableView(_ tableView: UITableView,
                                 didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        self.clickCell(at: indexPath)
    }
}

