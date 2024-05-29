//
//  ModuleListViewController.swift
//  xListViewController
//
//  Created by Mac on 2024/5/28.
//

import UIKit
import xExtension

open class xListModuleViewController: UIViewController {
    
    // MARK: - Handler
    public typealias HandlerClickCell = (xModuleModel) -> Void
    
    // MARK: - IBOutlet Property
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK: - Public Property
    /// Cell样式
    open var xCellClass : xModuleCell.Type = xModuleCell.self
    /// 用于内存释放提示(可快速定位被释放的对象)
    open var typeEmoji : String { return "🗄" }
    /// 数据源
    public var dataArray = [xModuleModel]()
    /// 是否显示分页
    public var isShowPageControl = true
    /// 行数
    public var row = Int(2)
    /// 列数
    public var column = Int(5)
    /// 行间距
    public var rowSpacing = CGFloat(10)
    /// 列间距
    public var columnSpacing = CGFloat(10)
    
    // MARK: - Private Property
    /// 回调
    var clickCellHandler : xListModuleViewController.HandlerClickCell?
    
    // MARK: - 内存释放
    deinit {
        self.clickCellHandler = nil
        self.contentScrollView.delegate = nil
        
        let info = self.xClassInfoStruct
        let space = info.space
        let name = info.name
        print("\(self.typeEmoji)【\(space).\(name)】")
    }
    
    // MARK: - Override Func
    open override class func xDefaultViewController() -> Self {
        let vc = Self.xNewXib()
        return vc
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        // 基本配置
        self.view.backgroundColor = .white
        self.contentScrollView.delegate = self
    }

    // MARK: - 添加回调
    /// 添加回调
    public func addClickCell(handler : @escaping xListModuleViewController.HandlerClickCell)
    {
        self.clickCellHandler = handler
    }
    
    // MARK: - 更新配置
    /// 更新Cell配置
    /// - Parameter cell: cell样式
    public func update(cell : xModuleCell.Type)
    {
        self.xCellClass = cell
    }
    /// 更新配置
    /// - Parameters:
    ///   - row: 行数
    ///   - rowSpacing: 行间距
    ///   - column: 列数
    ///   - columnSpacing: 列间距
    public func update(row : Int,
                       rowSpacing : CGFloat,
                       column : Int,
                       columnSpacing : CGFloat)
    {
        self.row = row
        self.rowSpacing = rowSpacing
        self.column = column
        self.columnSpacing = columnSpacing
    }
    
    // MARK: - 加载数据
    /// 加载数据
    open func reloadData(_ array : [xModuleModel])
    {
        self.dataArray = array
        self.contentScrollView.contentSize = .zero
        self.contentScrollView.setContentOffset(.zero, animated: false)
        // 清空旧控件
        for v in self.contentScrollView.subviews {
            v.removeFromSuperview()
        }
        let totalW = self.contentScrollView.bounds.width
        let totalH = self.contentScrollView.bounds.height
        let totalRowSpacing = self.rowSpacing * CGFloat(self.row + 1)
        let totalColumnSpacing = self.columnSpacing * CGFloat(self.column + 1)
        let itemW = (totalW - totalColumnSpacing) / CGFloat(self.column)
        let itemH = (totalH - totalRowSpacing) / CGFloat(self.row)
        
        var frame = CGRect.zero
        frame.size.width = itemW
        frame.size.height = itemH
        var ofx = CGFloat.zero
        var ofy = CGFloat.zero
        let pageSize = self.row * self.column
        var pageCount = 0
        
        for i in 0 ..< array.count {
            // 计算位置
            let page    = i / pageSize
            let column  = i % self.column
            let row     = i / self.column % self.row
            ofx =   totalW * CGFloat(page)
            ofx +=  itemW * CGFloat(column) + self.columnSpacing * CGFloat(column + 1)
            ofy =   itemH * CGFloat(row) + self.rowSpacing * CGFloat(row + 1)
            pageCount = page + 1    
            frame.origin.x = ofx
            frame.origin.y = ofy
//            print("idx = \(i), page = \(page), row = \(row), column = \(column), frame = \(frame)")
            // 添加Cell
            let cell = self.xCellClass.loadXib()
            cell.frame = frame
            self.contentScrollView.addSubview(cell)
            // 加载数据
            let model = array[i]
            cell.setContentData(model)
            cell.xAddClick {
                [weak self] (sender) in
                self?.clickCellHandler?(model)
            }
        }
        self.pageControl.currentPage = 0
        self.pageControl.numberOfPages = pageCount
        self.pageControl.isHidden = !(pageCount > 1)
        
        let contentW = totalW * CGFloat(pageCount)
        self.contentScrollView.contentSize = .init(width: contentW, height: 0)
        
        print("😁😁😁")
        print("当前配置信息\(self.row)行, \(self.column)列")
        print("行间距 = \(self.rowSpacing), 列间距 = \(self.column)")
        print("ItemSize = \(itemW), \(itemH)")
        print("PageCount = \(pageCount)")
        print("ContentSize = \(contentW)")
    }
    
}

// MARK: - Scroll view delegate
extension xListModuleViewController : UIScrollViewDelegate {
    
    /* 开始拖拽 */
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) { }
    /* 开始减速 */
    open func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) { }
    /* 滚动中 */
    open func scrollViewDidScroll(_ scrollView: UIScrollView) { }
    /* 停止拖拽（直接放开手指，没有拖动操作） */
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.updatePageControl(scrollView)
    }
    /* 滚动完毕就会调用（人为拖拽scrollView导致滚动完毕，才会调用这个方法） */
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.updatePageControl(scrollView)
    }
    /* 滚动完毕就会调用（不是人为拖拽scrollView导致滚动完毕，才会调用这个方法）*/
    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.updatePageControl(scrollView)
    }
     
    /// 换页信息
    func updatePageControl(_ scrollView: UIScrollView)
    {
        guard !self.pageControl.isHidden else { return }
        let ofx = scrollView.contentOffset.x
        let page = Int(ofx / scrollView.bounds.size.width)
        guard page < self.pageControl.numberOfPages else { return }
        self.pageControl.currentPage = page
    }
    
}
