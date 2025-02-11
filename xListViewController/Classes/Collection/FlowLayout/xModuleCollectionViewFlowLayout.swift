//
//  xModuleCollectionViewFlowLayout.swift
//  xListViewController
//
//  Created by Mac on 2025/2/11.
//

import UIKit

public class xModuleCollectionViewFlowLayout: xCollectionViewFlowLayout {
    
    // MARK: - Public Property
    /// 列数
    var column = 5
    /// 行数
    var row = 2
    /// Item样式
    var itemAttributeArray : [UICollectionViewLayoutAttributes] = .init()
    // 分页控件
    let pageControl = UIPageControl()
    // 内容区域
    var contentSize = CGSize.zero
    /// 根据返回的contentsize大小,控制uicollectionview的显示
    public override var collectionViewContentSize: CGSize
    {
        return self.contentSize
    }
    
    // MARK: - Override Func
    override public func prepare() {
        super.prepare()
        // 配置该模式下固定参数
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
        self.sectionInset = .zero
        self.headerReferenceSize = .zero
        self.footerReferenceSize = .zero
        self.scrollDirection = .horizontal
        self.itemAttributeArray.removeAll()
        guard let collectionView = self.collectionView else { return }
        collectionView.isPagingEnabled = true
        // 计算参数
        let maxW = collectionView.bounds.width
        let maxH = collectionView.bounds.height
        let itemW = maxW / CGFloat(self.column)
        let itemH = maxH / CGFloat(self.row)
        let rowCount = collectionView.numberOfItems(inSection: 0)
        var idp = IndexPath(row: 0, section: 0)
        var ofx = CGFloat.zero
        var ofy = CGFloat.zero
        let pageSize = self.row * self.column
        var pageCount = 0
        
        for i in 0 ..< rowCount {
            idp.row = i
            guard let att = self.layoutAttributesForItem(at: idp)?.copy() as? UICollectionViewLayoutAttributes else { continue }
            var frame = att.frame
            // 计算高度
            frame.size.width = itemW
            frame.size.height = itemH
            // 计算位置
            let page    = i / pageSize
            let column  = i % self.column
            let row     = i / self.column % self.row
            ofx =   maxW * CGFloat(page)
            ofx +=  itemW * CGFloat(column)
            ofy =   itemH * CGFloat(row)
            pageCount = page + 1
            frame.origin.x = ofx
            frame.origin.y = ofy
            // 更新frame
            att.frame = frame
            self.itemAttributeArray.append(att)
        }
        // 更新滚动区域保证完全换页
        self.contentSize.height = 0
        self.contentSize.width = CGFloat(pageCount) * maxW
        // 分页控件
        self.pageControl.isHidden = pageCount <= 1
        self.pageControl.numberOfPages = pageCount
        self.pageControl.currentPage = 0
        if self.pageControl.superview == nil {
            collectionView.superview?.addSubview(self.pageControl)
        }
        // 分页控件位置
        var frame = CGRect.zero
        frame.size.width = maxW
        frame.size.height = 30
        frame.origin.y = maxH - frame.height
        self.pageControl.frame = frame
        collectionView.bringSubviewToFront(self.pageControl)
    }
    
    /// 计算每个item的布局属性,我们将要调用该方法去计算每个item的布局,在增加,刷新item的时候,该方法也会调用,如果我们需要实现自定义的动画效果,需要在计算中做些调整,
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?
    {
        if let attr = self.itemAttributeArray.xObject(at: indexPath.row) {
            return attr
        }
        return super.layoutAttributesForItem(at: indexPath)
    }
    
    /// 将计算法的UICollectionViewLayoutAttributes数组返回给显示的rect
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?
    {
        return self.itemAttributeArray
    }
    
}
