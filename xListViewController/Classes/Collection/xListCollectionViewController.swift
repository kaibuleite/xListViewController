//
//  xListCollectionViewController.swift
//  Alamofire
//
//  Created by Mac on 2020/9/15.
//

import UIKit
import MJRefresh
import xDefine
import xModel

open class xListCollectionViewController: xCollectionViewController {
    
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
    public var dataEmptyView : UIView? {
        didSet {
            oldValue?.removeFromSuperview()
        }
    }
    
    // MARK: - Open Override Func
    open class func xNewWaterfall() -> Self {
        let layout = xWaterfallCollectionViewFlowLayout()
        let cvc = Self.init(collectionViewLayout: layout)
        cvc.reset(scroll: .vertical) // 瀑布流只支持垂直滚动
        cvc.reset(item: .init(width: 10, height: 10)) // 宽度自动计算
        return cvc
    }
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
        self.collectionView.mj_header?.endRefreshing()
        if self.page.isMore {
            self.collectionView.mj_footer?.endRefreshing()
        } else {
            self.collectionView.mj_footer?.endRefreshingWithNoMoreData()
        }
    }
    /// 数据刷新失败
    @objc open func refreshFailure()
    {
        self.collectionView.mj_header?.endRefreshing()
        self.collectionView.mj_footer?.endRefreshing()
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
        self.collectionView.reloadData()
        
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
        self.collectionView.reloadData()
        
        self.reloadDragScrollinEndVisibleCells()
    }
    
}

extension xListCollectionViewController {
    
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
    @objc open func addHeaderRefresh() {
        let header = MJRefreshNormalHeader.init(refreshingTarget: self,
                                                refreshingAction: #selector(refreshHeader))
        for v in header.subviews {
            if let obj = v as? UILabel { obj.textColor = self.mjHeaderTintColor }
            if let obj = v as? UIImageView { obj.tintColor = self.mjHeaderTintColor }
            if let obj = v as? UIActivityIndicatorView { obj.color = self.mjHeaderTintColor }
        }
        self.collectionView?.mj_header = header
    }
    /// 添加尾部刷新
    @objc open func addFooterRefresh() {
        let footer = MJRefreshBackNormalFooter.init(refreshingTarget: self,
                                                    refreshingAction: #selector(refreshFooter))
        for v in footer.subviews {
            if let obj = v as? UILabel { obj.textColor = self.mjFooterTintColor }
            if let obj = v as? UIImageView { obj.tintColor = self.mjFooterTintColor }
            if let obj = v as? UIActivityIndicatorView { obj.color = self.mjHeaderTintColor }
        }
        self.collectionView?.mj_footer = footer
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
        self.collectionView.mj_footer = footer
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
        self.collectionView.addSubview(emptyView)
        var frame = self.collectionView.bounds
        frame.size.height = xScreenWidth
        if let header = self.headerContainer {
            frame.origin.y = header.contentHeight
        }
        emptyView.frame = frame
        self.reset(footer: frame.size)
    }
    /// 隐藏空数据提示
    @objc open func hiddenEmptyView()
    {
        guard let emptyView = self.dataEmptyView else { return }
        emptyView.removeFromSuperview()
        self.isCloseBottomBounces = false   // 开启上拉加载
        self.reset(footer: .zero)
    }
    
}

// MARK: - Collection view data source
extension xListCollectionViewController {
    
    open override func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    open override func collectionView(_ collectionView: UICollectionView,
                                      numberOfItemsInSection section: Int) -> Int
    {
        return self.dataArray.count
    }
    open override func collectionView(_ collectionView: UICollectionView,
                                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = getCell(at: indexPath)
        return cell
    }
    
    /// 获取Cell
    @objc open func getCell(at idp : IndexPath) -> UICollectionViewCell
    {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: idp)
        // 数据填充
        if let xCell = cell as? xCollectionViewCell,
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

// MARK: - Collection view delegate flowLayout
extension xListCollectionViewController {
    
    /*
     单个 Section Header 直接 addSubView 到 Collection View 里就好
     多个 Section Header 再使用此方法
     
    open override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = self.headerContainer?.view
            return header as! UICollectionReusableView
        } else {
            let footer = self.dataEmptyView
            return footer as! UICollectionReusableView
        }
     }
     */
}
