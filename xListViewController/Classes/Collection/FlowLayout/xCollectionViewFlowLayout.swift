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

/*
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
 */

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
