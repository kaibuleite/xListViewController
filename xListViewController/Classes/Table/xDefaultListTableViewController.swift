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
        self.view.backgroundColor = .clear
        self.tableView.backgroundColor = .clear
        let height = self.xCellClass.contentHeight()
        self.tableView.rowHeight = height
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
    @objc open func defaultCell(at idp : IndexPath) -> UITableViewCell
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
                                 cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        return defaultCell(at: indexPath)
    }
}
