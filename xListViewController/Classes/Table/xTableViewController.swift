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
    
    // MARK: - IBInspectable Property
    /// 控制器描述
    @IBInspectable public var xTitle : String = ""
    
    // MARK: - Public Property
    /// 用于内存释放提示(可快速定位被释放的对象)
    open var typeEmoji : String { return "🧬" }
    /// 是否显示中
    public var isAppear = false
    /// 是否完成数据加载
    public var isRequestDataCompleted = true
    /// 是否关闭顶部下拉回弹
    public var isCloseTopBounces = false
    /// 是否关闭底部上拉回弹
    public var isCloseBottomBounces = false
    /// 是否开启重新刷新滚动结束后显示的Cell功能
    public var isOpenReloadDragScrollingEndVisibleCells = false
    /// 是否还在拖拽滚动事件中
    public var isDragScrolling : Bool {
        if self.tableView.isDragging { return true }
        if self.tableView.isDecelerating { return true }
        return false
    }
    /// 是否打印滚动日志(默认不打印)
    public var isPrintScrollingLog = false
    
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
    
    // MARK: - Open Override Func
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    required public override init(style: UITableView.Style) {
        super.init(style: style)
        self.initSourceCode = true
    }
    
    open override class func xDefaultViewController() -> Self {
        let tvc = self.xDefaultViewController(style: .plain)
        return tvc
    }
    open class func xDefaultViewController(style: UITableView.Style) -> Self {
        let tvc = self.init(style: style)
        return tvc
    }
    open override func viewDidLoad() {
        super.viewDidLoad()
        // 基本配置
        self.view.backgroundColor = UIColor.groupTableViewBackground
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.keyboardDismissMode = .onDrag
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
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.isAppear = true
    }
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.isAppear = false
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
        return 0.01
    }
    open override func tableView(_ tableView: UITableView,
                                 heightForFooterInSection section: Int) -> CGFloat
    {
        return 0.01
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
    open override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.beginScrollHandler?(scrollView.contentOffset)
    }
    /* 开始减速 */
    open override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
    }
    /* 滚动中 */
    open override func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        var offset = scrollView.contentOffset
        self.scrollingHandler?(offset)
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
            let maxOfy = scrollView.contentSize.height - scrollView.bounds.height - 1
            if (offset.y > maxOfy) {
                offset.y = maxOfy
                scrollView.bounces = false
            }
            scrollView.contentOffset = offset
        }
    }
    /* 停止拖拽（直接放开手指，没有拖动操作） */
    open override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard self.checkDragScrollingEnd(scrollView) else { return }
        guard self.isPrintScrollingLog else { return }
        print("***** 停止类型1: 拖拽后没有减速惯性\n")
    }
    /* 滚动完毕就会调用（人为拖拽scrollView导致滚动完毕，才会调用这个方法） */
    open override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard self.checkDragScrollingEnd(scrollView) else { return }
        guard self.isPrintScrollingLog else { return }
        print("***** 停止类型2: 拖拽后减速惯性消失\n")
    }
    /* 滚动完毕就会调用（不是人为拖拽scrollView导致滚动完毕，才会调用这个方法）*/
    open override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.reloadDragScrollinEndVisibleCells()
        guard self.isPrintScrollingLog else { return }
        print("***** 停止类型3: 代码动画结束\n")
    }
    /* 调整内容插页，配合MJ_Header使用 */
    open override func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
    }
    
    // MARK: - 检测滚动事件是否结束
    /// 检测滚动事件是否结束
    func checkDragScrollingEnd(_ scrollView: UIScrollView) -> Bool
    {
        // 拖拽事件
        if self.isDragScrolling { return false }
        // 边界回弹
        if !self.isCloseTopBounces {
            let ofy1 = scrollView.contentOffset.y
            let ofy2 = CGFloat(-1)
            guard ofy1 >= ofy2 else { return false }
        }
        if !self.isCloseBottomBounces {
            let ofy1 = scrollView.contentOffset.y
            let ofy2 = scrollView.contentSize.height - scrollView.bounds.height + 1
            guard ofy1 <= ofy2 else { return false }
        }
        self.endScrollHandler?(scrollView.contentOffset)
        self.reloadDragScrollinEndVisibleCells()
        return true
    }
    /// 刷新显示中的Cell
    func reloadDragScrollinEndVisibleCells()
    {
        guard self.isOpenReloadDragScrollingEndVisibleCells else { return }
        guard let idpArr = self.tableView.indexPathsForVisibleRows else { return }
        self.tableView.reloadRows(at: idpArr, with: .none)
    }
}
