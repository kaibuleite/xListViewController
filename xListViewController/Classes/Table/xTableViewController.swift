//
//  xTableViewController.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/15.
//

import UIKit
import xDefine
import xExtension

open class xTableViewController: UITableViewController {
    
    // MARK: - Handler
    /// 滚动开始回调
    public typealias xHandlerScrollViewChangeStatus = (CGPoint) -> Void
    
    // MARK: - Public Property
    /// 用于内存释放提示(可快速定位被释放的对象)
    open var typeEmoji : String { return "🧬" }
    
    /// 是否显示中
    public var isAppear = false
    /// 数据请求状态
    public var isRequestDataCompleted = true
    
    /// 是否关闭顶部下拉回弹
    public var isCloseTopBounces = false
    /// 是否关闭底部上拉回弹
    public var isCloseBottomBounces = false
    
    /// 头部渐变背景色
    public var headerGradientBackgroundColorLayer = CAGradientLayer()
    /// 表头容器
    public var headerContainer : xListHeaderContainer?
    
    /// 是否打印滚动日志(默认不打印)
    public var isPrintScrollingLog = false
    /// 是否开启重新刷新滚动结束后显示的Cell功能
    public var isOpenReloadDragScrollingEndVisibleCells = true
    /// 是否还在拖拽滚动事件中
    public var isDragScrolling : Bool {
        if self.tableView.isDragging { return true }
        if self.tableView.isDecelerating { return true }
        return false
    }
    
    /// 默认SectionHeaderHeight
    public var defaultSectionHeaderHeight = CGFloat(0.01)
    /// 默认SectionFooterHeight
    public var defaultSectionFooterHeight = CGFloat(0.01)
    
    // MARK: - Private Property
    /// 对象实例化来源(默认来自Storyboard或者Xib)
    var initSourceCode = false
    /// 滚动开始回调
    var beginScrollHandler : xHandlerScrollViewChangeStatus?
    /// 滚动中回调
    var scrollingHandler : xHandlerScrollViewChangeStatus?
    /// 滚动完成回调
    var endScrollHandler : xHandlerScrollViewChangeStatus?
    
    // MARK: - 内存释放
    deinit {
        self.beginScrollHandler = nil
        self.scrollingHandler = nil
        self.endScrollHandler = nil
        
        let info = self.xClassInfoStruct
        let space = info.space
        let name = info.name
        print("\(self.typeEmoji)【\(space).\(name)】")
    }
    
    // MARK: - 实例化对象
    open override class func xDefaultViewController() -> Self {
        let vc = Self.init(style: .grouped)
        return vc
    }
    open class func xDefaultViewController(style: UITableView.Style) -> Self {
        let vc = Self.init(style: style)
        return vc
    }
    
    // MARK: - Open Override Func
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    required public override init(style: UITableView.Style) {
        super.init(style: style)
        self.initSourceCode = true
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        // 基本配置
        self.view.backgroundColor = .init(red: 242/255,
                                          green: 242/255,
                                          blue: 247/255,
                                          alpha: 1)
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.layer.insertSublayer(self.headerGradientBackgroundColorLayer, at: 0)
        self.headerGradientBackgroundColorLayer.zPosition = -1
        self.headerGradientBackgroundColorLayer.isHidden = true
        // 内容高度
        self.tableView.estimatedRowHeight = 0
        self.tableView.estimatedSectionHeaderHeight = 0
        self.tableView.estimatedSectionFooterHeight = 0
        if #available(iOS 15.0, *) {
            self.tableView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
        //self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.rowHeight = 44
        if self.initSourceCode {
            // 通过代码实例化默认设置头尾都为空
            self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: xScreenWidth, height: 0.01))
            self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: xScreenWidth, height: 0.01))
        } else {
            // 通过Storyboard或Xib实例化不管
        }
        // 注册控件
        self.registerHeaders()
        self.registerCells()
        self.registerFooters()
        // 主线程操作
        DispatchQueue.main.async {
            self.addKit()
            self.addChildren()
            self.requestData()
        }
    }
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestDataWhenViewWillAppear()
    }
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.requestDataWhenViewDidAppear()
        self.isAppear = true
    }
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.requestDataWhenViewWillDisappear()
    }
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.requestDataWhenViewDidDisappear()
        self.isAppear = false
    }
    
    // MARK: - 头部配置
    /// 设置头部渐变色
    open func setHeaderGradientBackgroundColor(colors : [UIColor],
                                               startX : CGFloat = 0.5,
                                               endX : CGFloat = 0.5,
                                               height : CGFloat = 0)
    {
        var frame = self.view.bounds
        var showHeight = height
        if showHeight == 0 { showHeight = frame.height / 2 } // 默认显示半个高度
        frame.size.height *= 2
        frame.origin.y = -frame.height + showHeight
        let layer = self.headerGradientBackgroundColorLayer
        layer.frame = frame
        layer.isHidden = false
        layer.colors = colors.map { return $0.cgColor }
        layer.startPoint = .init(x: startX, y: (1 - showHeight / frame.height))
        layer.endPoint = .init(x: endX, y: 1)
        layer.setNeedsDisplay()
    }
    /// 设置头部UI
    open func setHeaderSectionData(_ array : [xListHeaderSection],
                                   spacing : CGFloat = 10)
    {
        let header = self.headerContainer ?? .xNew()
        if header.parent == nil {
            self.addChild(header)
            self.tableView.tableHeaderView = header.view
            self.headerContainer = header
        }
        header.contentStack.spacing = spacing
        header.reloaHeaderSectionData(array)
        self.tableView.reloadData()
    }
    
    // MARK: - 注册Cell
    /// 注册NibCell
    /// - Parameters:
    ///   - name: xib名称
    ///   - identifier: 重用符号
    public func register(nibName : String,
                         bundle : Bundle? = nil,
                         identifier : String)
    {
        let nib = UINib.init(nibName: nibName,
                             bundle: bundle)
        self.tableView.register(nib,
                                forCellReuseIdentifier: identifier)
    }
    /// 注册ClassCell
    /// - Parameters:
    ///   - nibName: xib名称
    ///   - identifier: 重用符号
    public func register(cellClass : AnyClass?,
                        identifier : String)
    {
        self.tableView.register(cellClass,
                                forCellReuseIdentifier: identifier)
    }
    
    // MARK: - 添加回调
    /// 添加开始滚动回调
    public func addBeginScrollHandler(_ handler : @escaping xTableViewController.xHandlerScrollViewChangeStatus)
    {
        self.beginScrollHandler = handler
    }
    /// 添加滚动中回调
    public func addScrollingHandler(_ handler : @escaping xTableViewController.xHandlerScrollViewChangeStatus)
    {
        self.scrollingHandler = handler
    }
    /// 添加滚动完成回调
    public func addEndScrollHandler(_ handler : @escaping xTableViewController.xHandlerScrollViewChangeStatus)
    {
        self.endScrollHandler = handler
    }

}

// MARK: - Extension Func
extension xTableViewController {
    
    /// 注册Headers
    @objc open func registerHeaders() { }
    /// 注册Cells
    @objc open func registerCells() { }
    /// 注册Footers
    @objc open func registerFooters() { }
    /// 点击Cell
    @objc open func clickCell(at idp : IndexPath) { }
}

// MARK: - Table view delegate
extension xTableViewController {
    
    open override func tableView(_ tableView: UITableView,
                                 heightForHeaderInSection section: Int) -> CGFloat
    {
        return self.defaultSectionHeaderHeight
    }
    open override func tableView(_ tableView: UITableView,
                                 heightForFooterInSection section: Int) -> CGFloat
    {
        return self.defaultSectionFooterHeight
    }
    open override func tableView(_ tableView: UITableView,
                                 didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        self.clickCell(at: indexPath)
    }
}

// MARK: - Scroll view delegate
extension xTableViewController {
    
    /* 开始拖拽 */
    open override func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        self.beginScrollHandler?(scrollView.contentOffset)
    }
    /* 滚动中 */
    open override func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        self.checkBounces(scrollView)
        let offset = scrollView.contentOffset
        self.scrollingHandler?(offset)
    }
    /* 停止拖拽（直接放开手指，没有拖动操作） */
    open override func scrollViewDidEndDragging(_ scrollView: UIScrollView,
                                                willDecelerate decelerate: Bool)
    {
        guard !decelerate else { return } // 没有惯性才算停止
        self.printScrollingEnd(tip: "***** 停止类型1: 拖拽后没有减速惯性")
        self.checkDragScrollingEnd(scrollView)
    }
    /* 开始减速 */
    open override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView)
    {
        
    }
    /* 人为拖拽scrollView导致滚动完毕，才会调用这个方法 */
    open override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        self.printScrollingEnd(tip: "***** 停止类型2: 拖拽后减速惯性消失")
        self.checkDragScrollingEnd(scrollView)
    }
    /* 不是人为拖拽scrollView导致滚动完毕(如代码调用)，才会调用这个方法*/
    open override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
    {
        self.printScrollingEnd(tip: "***** 停止类型3: 代码动画结束")
        self.checkDragScrollingEnd(scrollView)
    }
    /* 调整内容插页，配合MJ_Header使用 */
    open override func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView)
    {
    }
    
    // MARK: - 滚动事件
    /// 检测边界
    func checkBounces(_ scrollView: UIScrollView)
    {
        var offset = scrollView.contentOffset
        // 关闭顶部下拉
        if self.isCloseTopBounces {
            scrollView.bounces = true
            if (offset.y < 0) {
                offset.y = 0
                scrollView.bounces = false
            }
            scrollView.contentOffset = offset
        }
        // 关闭底部上拉
        if self.isCloseBottomBounces {
            scrollView.bounces = true
            let totalHeight = scrollView.contentSize.height
            let maxHeight = totalHeight - scrollView.bounds.height
            if (offset.y > maxHeight) {
                offset.y = maxHeight
                scrollView.bounces = false
            }
            scrollView.contentOffset = offset
        }
    }
    /// 检测滚动事件是否结束
    func checkDragScrollingEnd(_ scrollView: UIScrollView)
    {
        self.checkBounces(scrollView)
        self.reloadDragScrollinEndVisibleCells()
        self.endScrollHandler?(scrollView.contentOffset)
    }
    /// 输出滚动结束提示信息
    func printScrollingEnd(tip : String)
    {
        guard self.isPrintScrollingLog else { return }
        guard !self.isDragScrolling else { return }
        print(tip)
    }
    /// 刷新显示中的Cell
    func reloadDragScrollinEndVisibleCells()
    {
        guard self.isOpenReloadDragScrollingEndVisibleCells else { return }
        guard !self.isDragScrolling else { return }
        let list = self.tableView.visibleCells
        for cell in list {
            guard let xCell = cell as? xTableViewCell else { continue }
            xCell.reloadVisibleContentData()
        }
    }
    
}
