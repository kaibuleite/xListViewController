//
//  xCollectionViewFlowLayout.swift
//  xListViewController
//
//  Created by Mac on 2022/7/7.
//

import UIKit

open class xCollectionViewFlowLayout: UICollectionViewFlowLayout {

    // MARK: - Override Func
    open override func prepare() {
        super.prepare()
        /* 用reset方法设置
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
        
        self.sectionInset = .zero
        
        self.headerReferenceSize = .zero
        self.footerReferenceSize = .zero
        self.itemSize = .init(width: 100, height: 100)
         */
    }
}

// MARK: - Extension Func
extension xCollectionViewFlowLayout {
    
    /// 更新Layout配置
    @objc open func reset(scroll direction : UICollectionView.ScrollDirection)
    {
        self.scrollDirection = direction
        self.collectionView?.reloadData()
    }
    @objc open func reset(minimumLine spacing1 : CGFloat,
                          minimumInteritem spacing2 : CGFloat)
    {
        self.minimumLineSpacing = spacing1
        self.minimumInteritemSpacing = spacing2
        self.collectionView?.reloadData()
    }
    @objc open func reset(section inset : UIEdgeInsets)
    {
        self.sectionInset = inset
        self.collectionView?.reloadData()
    }
    @objc open func reset(header size : CGSize)
    {
        self.headerReferenceSize = size
        self.collectionView?.reloadData()
    }
    @objc open func reset(footer size : CGSize)
    {
        self.footerReferenceSize = size
        self.collectionView?.reloadData()
    }
    @objc open func reset(item size : CGSize)
    {
        self.itemSize = size
        self.collectionView?.reloadData()
    }
    
}

extension UIEdgeInsets {
    
    /// 等值对象
    public static func xNewEqual(_ value : CGFloat) -> UIEdgeInsets
    {
        let ret = UIEdgeInsets.init(top: value, left: value, bottom: value, right: value)
        return ret
    }
    /// 等值对象
    public static func xNewEqualLR(_ value : CGFloat) -> UIEdgeInsets
    {
        let ret = UIEdgeInsets.init(top: 0, left: value, bottom: 0, right: value)
        return ret
    }
    /// 等值对象
    public static func xNewEqualTB(_ value : CGFloat) -> UIEdgeInsets
    {
        let ret = UIEdgeInsets.init(top: value, left: 0, bottom: value, right: 0)
        return ret
    }
}

// MARK: - 瀑布流布局
extension xCollectionViewFlowLayout {
    
    /* 瀑布流教程 https://www.jianshu.com/p/14ab3346024b */
    
    // 父类需要根据返回的contentsize大小,控制uicollectionview的显示
    //open override var collectionViewContentSize: CGSize
    
    /* 如果需要支持头视图和脚视图,那么需要重写该方法
    open override func layoutAttributesForSupplementaryView(ofKind elementKind: String,
                                                            at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?
    {
        <#code#>
    }*/
    
    /* 装饰视图的布局计算
    open override func layoutAttributesForDecorationView(ofKind elementKind: String,
                                                         at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?
    {
        <#code#>
    }*/
    
    /* 计算每个item的布局属性,我们将要调用该方法去计算每个item的布局,在增加,刷新item的时候,该方法也会调用,如果我们需要实现自定义的动画效果,需要在计算中做些调整.
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?
    {
        <#code#>
    }*/
    
    /* 这个方法比较关键,我们需要将计算法的UICollectionViewLayoutAttributes数组返回给显示的rect,系统会根据属性数组来计算cell的复用和布局的显示.
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        <#code#>
    }*/
    
}
