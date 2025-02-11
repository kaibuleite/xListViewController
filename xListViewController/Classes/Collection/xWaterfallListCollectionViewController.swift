//
//  xWaterfallListCollectionViewController.swift
//  xListViewController
//
//  Created by Mac on 2025/2/11.
//

import UIKit

open class xWaterfallListCollectionViewController: xDefaultListCollectionViewController {

    // MARK: - Open Override Func
    open override func viewDidLoad() {
        super.viewDidLoad()
    }    

}

// MARK: - UICollection view delegate flowLayout
extension xWaterfallListCollectionViewController {
    
//    // section 头部大小
//    override func collectionView(_ collectionView: UICollectionView,
//                                 layout collectionViewLayout: UICollectionViewLayout,
//                                 referenceSizeForHeaderInSection section: Int) -> CGSize
//    {
//        return self.flowLayout.headerReferenceSize
//    }
//    // 尾部大小
//    override func collectionView(_ collectionView: UICollectionView,
//                                 layout collectionViewLayout: UICollectionViewLayout,
//                                 referenceSizeForFooterInSection section: Int) -> CGSize
//    {
//        return self.flowLayout.footerReferenceSize
//    }
    
}

// MARK: - Waterfall Collection View Delegate FlowLayout
extension xWaterfallListCollectionViewController: xWaterfallCollectionViewDelegateFlowLayout {
    
    public func xCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, colum section: Int) -> Int {
        return self.getWaterfallItemColumn(in: section)
    }
    
    public func xCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacing section: Int) -> CGFloat {
        return self.getWaterfallItemMinimumLineSpacing(in: section)
    }
    public func xCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacing section: Int) -> CGFloat {
        return self.getWaterfallItemMinimumInteritemSpacing(in: section)
    }
    
    public func xCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sectionInsetForItems section: Int) -> UIEdgeInsets {
        return self.getWaterfallItemSectionInset(in: section)
    }
    
    public func xCollectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, itemWidth: CGFloat, caculateHeight indexPath: IndexPath) -> CGFloat {
        // 计算高度
        var h = CGFloat.zero
        guard let model = self.dataArray.xObject(at: indexPath.row) else {
            h = self.getWaterfallItemHeight(at: indexPath)
            return h
        }
        if let cacheH = model.xExInfo[xWaterfallCellHeight] as? CGFloat {
            // 读取缓存
            h = cacheH
        } else {
            // 计算高度
            h = self.getWaterfallItemHeight(at: indexPath)
            // 缓存高度
            model.xExInfo[xWaterfallCellHeight] = h
        }
        return h
    }
    
    // MARK: - 瀑布流参数
    /// 返回当前section中的列数
    @objc open func getWaterfallItemColumn(in section : Int) -> Int {
        return 2
    }
    /// 返回当前section中cell的行间距
    @objc open func getWaterfallItemMinimumLineSpacing(in section : Int) -> CGFloat {
        return 10
    }
    /// 返回当前section中cell的间距
    @objc open func getWaterfallItemMinimumInteritemSpacing(in section : Int) -> CGFloat {
        return 10
    }
    /// 返回当前section中cell的内间距
    @objc open func getWaterfallItemSectionInset(in section : Int) -> UIEdgeInsets {
        return .xNewEqual(10)
    }
    /// 返回当前indexpath的高度,可以根据宽度来计算
    @objc open func getWaterfallItemHeight(at idp: IndexPath) -> CGFloat
    {
        return 10
    }
    
}
