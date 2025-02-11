//
//  xListTableViewController.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/15.
//

import UIKit
import MJRefresh
import xDefine
import xExtension
import xModel

open class xListTableViewController: xTableViewController {
    
    // MARK: - Public Property
    /// 是否添加刷新控件
    open var isAddHeaderRefresh : Bool { return true }
    open var isAddFooterRefresh : Bool { return true }
    open var isAddFooterAutoRefresh : Bool { return false }
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
    public var dataEmptyView : UIView?
    
    // MARK: - Open Override Func
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.dataEmptyView = xListNoDataView.newTip(style: .face, message: "没有数据哦~")
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
    @objc open func refreshHeader()
    {
        self.page.resetPage()
        self.dataArray.removeAll()
        self.refreshDataList()
    }
    /// 刷新尾部
    @objc open func refreshFooter()
    {
        self.page.current += 1
        self.refreshDataList()
    }
    /// 数据刷新成功
    @objc open func refreshSuccess()
    {
        self.tableView.mj_header?.endRefreshing()
        if self.page.isMore {
            self.tableView.mj_footer?.endRefreshing()
        } else {
            self.tableView.mj_footer?.endRefreshingWithNoMoreData()
        }
    }
    /// 数据刷新失败
    @objc open func refreshFailure()
    {
        self.tableView.mj_header?.endRefreshing()
        self.tableView.mj_footer?.endRefreshing()
    }
    /// 拼接数据源
    /// - Parameters:
    ///   - list: 新的数据
    ///   - shuffled: 是否随机
    @objc open func reloadData(_ array : [xModel],
                               shuffled : Bool = false)
    {
        if shuffled {
            let arr = array.shuffled()
            self.dataArray.append(contentsOf: arr)
        } else {
            self.dataArray.append(contentsOf: array)
        }
        self.refreshSuccess()
        self.reloadEmptyView()
        self.tableView.reloadData()
        
        self.printScrollingEnd(tip: "***** 停止类型4: MJRefresh数据加载完成")
        self.reloadDragScrollinEndVisibleCells()
    }
    /// 设置数据源
    /// - Parameters:
    ///   - list: 新的数据
    ///   - shuffled: 是否随机
    @objc open func setData(_ array : [xModel],
                            shuffled : Bool = false)
    {
        if shuffled {
            let arr = array.shuffled()
            self.dataArray = arr
        } else {
            self.dataArray = array
        }
        self.refreshSuccess()
        self.reloadEmptyView()
        self.tableView.reloadData()
        
        self.reloadDragScrollinEndVisibleCells()
    }
    
}

extension xListTableViewController {
    
    // MARK: - 刷新控件
    /// 添加刷新
    @objc open func addMJRefresh() {
        if self.isAddHeaderRefresh {
            self.addHeaderRefresh()
        }
        // 优先展示自动刷新Footer
        if self.isAddFooterAutoRefresh {
            self.addFooterAutoRefresh()
        } else
        if self.isAddFooterRefresh {
            self.addFooterRefresh()
        }
    }
    /// 添加头部刷新
    @objc open func addHeaderRefresh()
    {
        let header = MJRefreshNormalHeader.init(refreshingTarget: self,
                                                refreshingAction: #selector(refreshHeader))
        for v in header.subviews {
            if let obj = v as? UILabel { obj.textColor = self.mjHeaderTintColor }
            if let obj = v as? UIImageView { obj.tintColor = self.mjHeaderTintColor }
            if let obj = v as? UIActivityIndicatorView { obj.color = self.mjHeaderTintColor }
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
            if let obj = v as? UIActivityIndicatorView { obj.color = self.mjHeaderTintColor }
        }
        self.tableView.mj_footer = footer
    }
    @objc open func addFooterAutoRefresh() {
        let footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self,
                                                    refreshingAction: #selector(refreshFooter))
        footer.triggerAutomaticallyRefreshPercent = -1
        for v in footer.subviews {
            if let obj = v as? UILabel { obj.textColor = self.mjFooterTintColor }
            if let obj = v as? UIImageView { obj.tintColor = self.mjFooterTintColor }
            if let obj = v as? UIActivityIndicatorView { obj.color = self.mjHeaderTintColor }
        }
        footer.setTitle("已经到底了", for: .noMoreData)
        self.tableView.mj_footer = footer
    }
    /// 刷新数据
    @objc open func refreshDataList() {
        // 模拟数据
        var list = [xModel]()
        if arc4random() % 2 == 0 {
            list = xModel.newRandomList()
        }
        self.reloadData(list)
    }
    
    // MARK: - 空数据
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
        guard let emptyView = self.dataEmptyView else { return }
        var frame = self.tableView.bounds
        frame.size.height = xScreenWidth
        emptyView.frame = frame
        self.tableView.tableFooterView = emptyView
    }
    /// 隐藏空数据提示
    @objc open func hiddenEmptyView()
    {
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: xScreenWidth, height: 0.01))
    }
    
}

// MARK: - Table view data source
extension xListTableViewController {
    
    open override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    open override func tableView(_ tableView: UITableView,
                                 numberOfRowsInSection section: Int) -> Int
    {
        return self.dataArray.count
    }
    open override func tableView(_ tableView: UITableView,
                                 cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = getCell(at: indexPath)
        return cell
    }
    
    /// 获取Cell
    @objc open func getCell(at idp : IndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: idp)
        // 数据填充
        if let xCell = cell as? xTableViewCell,
           let model = self.getCellContentData(at: idp) {
            xCell.setContentData(in: self, at: idp, with: model)
        }
        return cell
    }
    /// 获取Cell数据
    @objc open func getCellContentData(at idp : IndexPath) -> xModel?
    {
        let model = self.dataArray.xObject(at: idp.row)
        return model
    }
    
}

// MARK: - Table view elegate
extension xListTableViewController {
    
    open override func tableView(_ tableView: UITableView,
                                 heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView.estimatedRowHeight > 0 {
            return UITableView.automaticDimension
        } else {
            return tableView.rowHeight
        }
    }
}
