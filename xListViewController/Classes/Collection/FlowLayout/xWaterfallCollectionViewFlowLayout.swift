//
//  xWaterfallCollectionViewFlowLayout.swift
//  xListViewController
//
//  Created by Mac on 2025/2/11.
//

import UIKit
import xDefine
import xExtension

// MARK: - 常量
public let xCollectionElementKindSectionDecoration = "xCollectionElementKindSectionDecoration"
public let xWaterfallCellHeight = "xWaterfallCellHeight"

// MARK: - 瀑布流分块信息
class xWaterfallCollectionFlowLayoutSectionInfo: NSObject {

    /// 头部样式
    var headerAttribute : UICollectionViewLayoutAttributes?
    /// Item样式
    var itemAttributeArray : [UICollectionViewLayoutAttributes] = .init()
    /// 尾部样式
    var footerAttribute : UICollectionViewLayoutAttributes?
    /// 装饰视图样式
    var decorAttribute : UICollectionViewLayoutAttributes?
    
    /// 列数
    var column = Int.zero
    /// 每列的最后一个元素,获取最大值或最小值
    var columnLastItemFrame : [Int : CGRect] = .init()
    /// 起始位置
    var origin = CGPoint.zero
    /// item宽度
    var itemWidth = CGFloat.zero
    /// item间距
    var itemEdgeInset = UIEdgeInsets.zero
    /// 行间距
    var minimumLineSpacing = CGFloat.zero
    /// 项目间距
    var minimumInteritemSpacing = CGFloat.zero
    
    // MARK: - 实例化对象、初始化参数
    init(column : Int,
         itemWidth : CGFloat,
         itemEdgeInset : UIEdgeInsets,
         minimumLineSpacing : CGFloat,
         minimumInteritemSpacing : CGFloat )
    {
        self.column = column
        self.itemWidth = itemWidth
        self.itemEdgeInset = itemEdgeInset
        self.minimumLineSpacing = minimumLineSpacing
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.origin = .init(x: itemEdgeInset.left,
                            y: itemEdgeInset.top)
    }
    /// 更新排序
    func updateLastItem(column : Int,
                        frame : CGRect)
    {
        self.columnLastItemFrame[column] = frame
    }
    /// 初始化每列最后一个元素
    func initColumnLastItemFrame(_ rect : CGRect)
    {
        self.columnLastItemFrame[0] = rect
        for i in 1 ..< self.column {
            var frame = rect
            frame.origin.x += (rect.width + self.minimumInteritemSpacing) * CGFloat(i)
            frame.origin.y += 0.1 * CGFloat(i)  // 方便计算
            frame.size.height = -0.1 * CGFloat(i)
            self.columnLastItemFrame[i] = frame
        }
//        self.columnLastItemFrame[0] = rect
//        for i in 1 ..< self.column {
//            var frame = CGRect.zero
//            frame.origin.x = rect.minX
//            frame.origin.x += (rect.width + self.minimumInteritemSpacing) * CGFloat(i)
//            frame.origin.y = rect.minY
//            frame.origin.y += 0.1 * CGFloat(i)
//            frame.size.width = rect.width
//            frame.size.height = -0.1 * CGFloat(i)
//            self.columnLastItemFrame[i] = frame
//        }
    }
    
    // MARK: - Y轴
    ///获取当前section的y轴最小值
    func getSectionMinY() -> CGFloat
    {
        if let header = self.headerAttribute{
            return header.frame.minY
        }
        if let firstItem = self.itemAttributeArray.first {
            return firstItem.frame.minY - self.itemEdgeInset.top
        }
        if let footer = self.headerAttribute {
            return footer.frame.minY
        }
        return self.itemEdgeInset.top
    }
    ///获取当前section的y轴最大值
    func getSectionMaxY() -> CGFloat
    {
        if let footer = self.footerAttribute {
            return footer.frame.maxY
        }
        if self.itemAttributeArray.count > 0 {
            return self.getBottomItemLastFrame().frame.maxY + self.itemEdgeInset.bottom
        }
        if let header = self.headerAttribute{
            return header.frame.maxY
        }
//        return self.itemEdgeInset.top + self.itemEdgeInset.bottom
        return 0
    }
    
    // MARK: - 获取最下方Item位置
    /// 获取最下方Item中最高的位置
    func getBottomItemFirstFrame() -> (column: Int, frame: CGRect)
    {
        let first = self.columnLastItemFrame.first
        var column = first?.key ?? 0
        var frame = first?.value ?? .zero
        for item in self.columnLastItemFrame {
            if item.value.maxY < frame.maxY {
                column = item.key
                frame = item.value
            }
        }
        return (column, frame)
    }
    /// 获取最下方Item中最低的位置
    func getBottomItemLastFrame() -> (column: Int, frame: CGRect)
    {
        let first = self.columnLastItemFrame.first
        var column = first?.key ?? 0
        var frame = first?.value ?? .zero
        for item in self.columnLastItemFrame {
            if item.value.maxY > frame.maxY {
                column = item.key
                frame = item.value
            }
        }
        return (column, frame)
    }
    
}

// MARK: - 代理方法
public protocol xWaterfallCollectionViewDelegateFlowLayout: UICollectionViewDelegateFlowLayout {
    
    /// 返回当前section中的列数
    func xCollectionView(_ collectionView: UICollectionView,
                         layout collectionViewLayout: UICollectionViewLayout,
                         colum section: Int) -> Int
    /// 返回当前section中cell的行间距
    func xCollectionView(_ collectionView: UICollectionView,
                         layout collectionViewLayout: UICollectionViewLayout,
                         minimumLineSpacing section: Int) -> CGFloat
    /// 返回当前section中cell的间距
    func xCollectionView(_ collectionView: UICollectionView,
                         layout collectionViewLayout: UICollectionViewLayout,
                         minimumInteritemSpacing section: Int) -> CGFloat
    /// 返回当前section中cell的内间距
    func xCollectionView(_ collectionView: UICollectionView,
                         layout collectionViewLayout: UICollectionViewLayout,
                         sectionInsetForItems section: Int) -> UIEdgeInsets
    /// 返回当前indexpath的高度,可以根据宽度来计算
    func xCollectionView(_ collectionView: UICollectionView,
                         layout collectionViewLayout: UICollectionViewLayout,
                         itemWidth: CGFloat,
                         caculateHeight indexPath: IndexPath) -> CGFloat
}

// MARK: - 瀑布流样式
public class xWaterfallCollectionViewFlowLayout: xCollectionViewFlowLayout {
    
    // 分区的内容信息,用来做布局处理
    var sectionInfoArray = [Int : xWaterfallCollectionFlowLayoutSectionInfo]()
    
    /// 获取每个item的宽度
    public func getItemWidth(for section: Int) -> CGFloat
    {
        if let collectionView = self.collectionView,
           let delegate = collectionView.delegate as? xWaterfallCollectionViewDelegateFlowLayout
        {
            let colum = delegate.xCollectionView(collectionView, layout: self, colum: section)
            let edge = delegate.xCollectionView(collectionView, layout: self, sectionInsetForItems: section)
            let space = delegate.xCollectionView(collectionView, layout: self, minimumInteritemSpacing: section)
            var totalSpace = CGFloat.zero
            if colum > 1 {
                totalSpace = space * CGFloat(colum - 1)
            }
            var width = collectionView.bounds.size.width
            width -= edge.left
            width -= edge.right
            width -= totalSpace
            width /= CGFloat(colum)
            return width
        }
        return xScreenWidth
    }
    
    /// 获取当前各分区y轴最大的值
    public func getContentMaxY() -> CGFloat
    {
        let first = self.sectionInfoArray.first
        var value = first?.value.getSectionMaxY() ?? 0
        for sec in self.sectionInfoArray {
            let maxY = sec.value.getSectionMaxY()
            if maxY > value {
                value = maxY
            }
        }
        return value
    }
    
    /// 根据返回的contentsize大小,控制uicollectionview的显示
    public override var collectionViewContentSize: CGSize
    {
        guard let collectionView = self.collectionView else { return .zero }
        var size = CGSize.zero
        size.width = collectionView.bounds.width
        size.height = max(self.getContentMaxY(), collectionView.bounds.height)
        return size
    }
    
    // MARK: - 注册修饰视图
    var decorationsKindArray = [String]()
    /// 注册修饰视图
    public func registerDecorationView(nib : UINib,
                                       section : Int)
    {
        let kind = xCollectionElementKindSectionDecoration + "\(section)"
        self.decorationsKindArray.append(kind)
        self.register(nib, forDecorationViewOfKind: kind)
    }
    
}

// MARK: - 重写样式
extension xWaterfallCollectionViewFlowLayout {
    
    override public func prepare() {
        super.prepare()
        self.sectionInfoArray.removeAll()
        guard let collectionView = self.collectionView else { return }
        guard let delegate = collectionView.dataSource as? xWaterfallCollectionViewDelegateFlowLayout else { return }
        let secCount = collectionView.numberOfSections
        /// 获取到分区
        for secIdx in 0 ..< secCount {
            let column = delegate.xCollectionView(collectionView, layout: self, colum: secIdx)
            let itemWidth = self.getItemWidth(for: secIdx) // 高度根据列数、边距、间距动态计算
            let itemEdge = delegate.xCollectionView(collectionView, layout: self, sectionInsetForItems: secIdx)
            let minimumLineSpacing = delegate.xCollectionView(collectionView, layout: self, minimumLineSpacing: secIdx)
            let minimumInteritemSpacing = delegate.xCollectionView(collectionView, layout: self, minimumInteritemSpacing: secIdx)
            let secInfo = xWaterfallCollectionFlowLayoutSectionInfo.init(column: column,
                                                                         itemWidth: itemWidth,
                                                                         itemEdgeInset: itemEdge,
                                                                         minimumLineSpacing: minimumLineSpacing,
                                                                         minimumInteritemSpacing: minimumInteritemSpacing)
            self.sectionInfoArray[secIdx] = secInfo
            // 处理header数据
            var idp = IndexPath(row: 0, section: secIdx)
            var key = UICollectionView.elementKindSectionHeader
            if let att = self.layoutAttributesForSupplementaryView(ofKind: key, at: idp)?.copy() as? UICollectionViewLayoutAttributes {
                var frame = att.frame
                if idp.section > 0, let info = self.sectionInfoArray[idp.section - 1] {
                    frame.origin.y = info.getSectionMaxY() // 上一块末尾
                }
                att.frame = frame
                secInfo.headerAttribute = att
            }
            // 处理cell数据
            let cellCount = collectionView.numberOfItems(inSection: secIdx)
            for rowIdx in 0 ..< cellCount {
                idp.row = rowIdx
                guard let att = self.layoutAttributesForItem(at: idp)?.copy() as? UICollectionViewLayoutAttributes else { continue }
                var frame = att.frame
                // 计算高度
                let itemHeight = delegate.xCollectionView(collectionView, layout: self, itemWidth: itemWidth, caculateHeight: idp)
                frame.size = .init(width: itemWidth, height: itemHeight)
                if rowIdx == 0 {
                    frame.origin.x = secInfo.origin.x
                    frame.origin.y = self.getContentMaxY() + itemEdge.top
                    secInfo.initColumnLastItemFrame(frame)
                } else {
                    // 查找当前section中哪列最短
                    let item = secInfo.getBottomItemFirstFrame()
                    let spacing = item.frame.size.height < 0 ? 0 : minimumLineSpacing
                    frame.origin.x = item.frame.minX
                    frame.origin.y = item.frame.maxY + spacing
                    secInfo.updateLastItem(column: item.column, frame: frame) // 更新最下方位置信息
                }
                att.frame = frame
                secInfo.itemAttributeArray.append(att)
            }
            // 处理footer数据
            key = UICollectionView.elementKindSectionFooter
            if let att = self.layoutAttributesForSupplementaryView(ofKind: key, at: idp)?.copy() as? UICollectionViewLayoutAttributes {
                var frame = att.frame
                frame.origin.y = secInfo.getSectionMaxY()
                att.frame = frame
                secInfo.footerAttribute = att
            }
            // 处理decora数据
            key = xCollectionElementKindSectionDecoration + "\(secIdx)"
            guard (self.decorationsKindArray.firstIndex(of: key) != nil) else { continue }
            if let att = self.layoutAttributesForDecorationView(ofKind: key, at: idp)?.copy() as? UICollectionViewLayoutAttributes {
                var frame = collectionView.bounds
                frame.origin.y = secInfo.getSectionMinY()
                frame.size.height = secInfo.getSectionMaxY() - secInfo.getSectionMinY()
                att.frame = frame
                secInfo.decorAttribute = att
            }
        }
    }
    
    /// 计算每个item的布局属性,我们将要调用该方法去计算每个item的布局,在增加,刷新item的时候,该方法也会调用,如果我们需要实现自定义的动画效果,需要在计算中做些调整,
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?
    {
        if let secInfo = self.sectionInfoArray[indexPath.section], secInfo.itemAttributeArray.count > indexPath.row {
            return secInfo.itemAttributeArray[indexPath.row]
        }
        return super.layoutAttributesForItem(at: indexPath)
    }
    
    /// 如果我们需要支持头视图和脚视图,那么需要重写该方法
    public override func layoutAttributesForSupplementaryView(ofKind elementKind: String,
                                                              at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?
    {
        if let secInfo = self.sectionInfoArray[indexPath.section] {
            if elementKind == UICollectionView.elementKindSectionHeader, let att = secInfo.headerAttribute {
                return att
            }
            if elementKind == UICollectionView.elementKindSectionFooter, let att = secInfo.footerAttribute {
                return att
            }
        }
        return super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
    }
    
    /// 装饰视图的布局计算
    public override func layoutAttributesForDecorationView(ofKind elementKind: String,
                                                           at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?
    {
        if let secInfo = self.sectionInfoArray[indexPath.section] {
            if let att = secInfo.decorAttribute {
                return att
            }
        }
        let att = UICollectionViewLayoutAttributes.init(forDecorationViewOfKind: elementKind, with: indexPath)
        att.zIndex = -1
        return att
    }
    
    /// 将计算法的UICollectionViewLayoutAttributes数组返回给显示的rect
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?
    {
        var list = [UICollectionViewLayoutAttributes]()
        let count = self.sectionInfoArray.values.count
        for i in  0 ..< count {
            guard let secInfo = self.sectionInfoArray[i] else { continue }
            if let header = secInfo.headerAttribute, header.frame.intersects(rect) {
                list.append(header)
            }
            for itemAttr in secInfo.itemAttributeArray {
                guard itemAttr.frame.intersects(rect) else { continue } // frame在rect内
                list.append(itemAttr)
            }
            if let footer = secInfo.footerAttribute, footer.frame.intersects(rect) {
                list.append(footer)
            }
            if let decor = secInfo.decorAttribute, decor.frame.intersects(rect){
                list.append(decor)
            }
        }
        return list
    }
    
}

// MARK: - 滚动事件
extension xWaterfallCollectionViewFlowLayout {
    
    @objc public func scrollToHeader(with section: Int,
                                     animated: Bool = true)
    {
        let idp = IndexPath(row: 0, section: section)
        self.scrollTo(idp, isHeader: true, animated: animated)
    }
    
    @objc public func scrollToFooter(with section: Int,
                                     animated: Bool = true)
    {
        let idp = IndexPath(row: 0, section: section)
        self.scrollTo(idp, isFooter: true, animated: animated)
    }
    
    @objc public func scrolllToIndex(index: IndexPath,
                                     animated: Bool = true)
    {
        self.scrollTo(index, animated: animated)
    }
    
    func scrollTo(_ idp: IndexPath,
                  isHeader: Bool = false,
                  isFooter: Bool = false,
                  animated: Bool)
    {
        let secInfo = self.sectionInfoArray[idp.section]
        var ofy = CGFloat.zero
        if isHeader, let att = secInfo?.headerAttribute {
            ofy = att.frame.origin.y
        }
        if isHeader, let att = secInfo?.footerAttribute {
            ofy = att.frame.origin.y
        }
        if let att = secInfo?.itemAttributeArray.xObject(at: idp.row) {
            ofy = att.frame.origin.y
        }
        let offset = CGPoint.init(x: 0, y: ofy)
        self.collectionView?.setContentOffset(offset, animated: true)
    }
}
