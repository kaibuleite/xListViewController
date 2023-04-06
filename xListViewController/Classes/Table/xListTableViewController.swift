//
//  xListTableViewController.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/15.
//

import UIKit
import MJRefresh
import xModel

open class xListTableViewController: xTableViewController {
    
    // MARK: - Public Property
    /// 是否添加刷新控件
    open var isAddHeaderRefresh : Bool { return true }
    open var isAddFooterRefresh : Bool { return true }
    /// 是否自动刷新
    open var isAutoRefresh : Bool { return true }
    /// mj_header主题色
    open var mjHeaderTintColor : UIColor { return .black }
    /// mj_footer主题色
    open var mjFooterTintColor : UIColor { return .black }
    
    /// 分页数据
    public let page = xPage()
    /// 数据源
    public var dataArray = [xModel]()
    /// 空数据展示图
    public lazy var dataEmptyView : UIView = {
        return self.getEmptyView()
    }()
    
    // MARK: - Open Override Func
    open override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            // 主线程执行(方便在子类的 viewDidLoad 里设置部分参数)
            self.addMJRefresh()
        }
    }
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard self.isAutoRefresh else { return }
        self.refreshHeader()
    }
    
    // MARK: - 数据刷新
    /// 刷新头部
    @objc public func refreshHeader()
    {
        self.page.current = 1
        self.hiddenEmptyView()
        self.refreshDataList()
    }
    /// 刷新尾部
    @objc public func refreshFooter()
    {
        self.page.current += 1
        self.hiddenEmptyView()
        self.refreshDataList()
    }
    /// 数据刷新成功
    public func refreshSuccess()
    {
        self.tableView.mj_header?.endRefreshing()
        if self.page.isMore {
            self.tableView.mj_footer?.endRefreshing()
        } else {
            self.tableView.mj_footer?.endRefreshingWithNoMoreData()
        }
    }
    /// 数据刷新失败
    public func refreshFailure()
    {
        self.tableView.mj_header?.endRefreshing()
        self.tableView.mj_footer?.endRefreshing()
    }
    /// 拼接数据源
    /// - Parameter list: 新的数据
    public func reloadData(list : [xModel])
    {
        if self.page.current <= 1 {
            self.dataArray = list
        } else {
            self.dataArray.append(contentsOf: list)
        }
        if self.isPrintScrollingLog {
            print("***** 停止类型4: MJRefresh数据加载完成\n")
        }
        self.reloadEmptyView()
        self.reloadDragScrollinEndVisibleCells()
    }
    
}

extension xListTableViewController {
    
    // MARK: - 刷新控件
    /// 添加刷新
    @objc open func addMJRefresh() {
        if self.isAddHeaderRefresh { self.addHeaderRefresh() }
        if self.isAddFooterRefresh { self.addFooterRefresh() }
    }
    /// 添加头部刷新
    @objc open func addHeaderRefresh()
    {
        let header = MJRefreshNormalHeader.init(refreshingTarget: self,
                                                refreshingAction: #selector(refreshHeader))
        for v in header.subviews {
            if let obj = v as? UILabel { obj.textColor = self.mjHeaderTintColor }
            if let obj = v as? UIImageView { obj.tintColor = self.mjHeaderTintColor }
        }
        self.tableView.mj_header = header
    }
    /// 添加尾部刷新
    @objc open func addFooterRefresh()
    {
        let footer = MJRefreshBackNormalFooter.init(refreshingTarget: self,
                                                    refreshingAction: #selector(refreshFooter))
        for v in footer.subviews {
            if let obj = v as? UILabel { obj.textColor = self.mjFooterTintColor }
            if let obj = v as? UIImageView { obj.tintColor = self.mjFooterTintColor }
        }
        self.tableView.mj_footer = footer
    }
    /// 刷新数据
    @objc open func refreshDataList() {
        // 模拟数据
        let list = xModel.newRandomList()
        self.refreshSuccess()
        self.reloadData(list: list)
    }
    
    // MARK: - 空数据
    /// 空数据展示图
    @objc open func getEmptyView() -> UIView {
        var frame = self.tableView.bounds
        frame.size.height = 400
        let view = xListNoDataView.loadXib()
        view.frame = frame
        return view
    }
    /// 重新加载空数据Footer
    @objc open func reloadEmptyView()
    {
        let isEmptyData = (self.dataArray.count == 0)
        if isEmptyData {
            self.showEmptyView()
        } else {
            self.hiddenEmptyView()
        }
    }
    /// 显示空数据提示
    @objc open func showEmptyView()
    {
        self.dataEmptyView.isHidden = false
        self.tableView.tableFooterView = self.dataEmptyView
        self.tableView.reloadData()
    }
    /// 隐藏空数据提示
    @objc open func hiddenEmptyView()
    {
        self.dataEmptyView.isHidden = true
        self.tableView.tableFooterView = nil
        self.tableView.reloadData()
    }
    
}

// MARK: - Table view data source
extension xListTableViewController {
    
    open override func tableView(_ tableView: UITableView,
                                 numberOfRowsInSection section: Int) -> Int
    {
        return self.dataArray.count
    }
}
