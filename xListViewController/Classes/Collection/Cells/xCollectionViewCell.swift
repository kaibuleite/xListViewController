//
//  xCollectionViewCell.swift
//  Alamofire
//
//  Created by Mac on 2020/9/15.
//

import UIKit
import xModel

open class xCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Override Func
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - 设置内容数据
    /// 设置内容数据
    open func setContentData(in cvc : xCollectionViewController? = nil,
                             at idp : IndexPath,
                             with model : xModel)
    {
        /*
        cvc.isOpenReloadDragScrollingEndVisibleCells = true
        if cvc.isDragScrolling {
            // 设置缓存图片
            let icon = UIImageView.init()
            let imgurl = ""
            if let img = xAppManager.getSDCacheImage(forKey: imgurl) {
                icon.image = img
            } else {
                icon.image = xAppManager.shared.placeholderImage
            }
        } else {
            // 异步下载图片（该方法会在scrollview停止滚动后才调用，优化性能
            let icon = UIImageView.init()
            let imgurl = ""
            icon.sd_setImage(with: imgurl.xToURL(), placeholderImage: xAppManager.shared.placeholderImage, options: .retryFailed, completed: nil)
        }*/
    } 
    
    // MARK: - 内容大小
    /// 内容大小
    open class func contentSize() -> CGSize
    {
        var size = CGSize.zero
        size.width += 100
        size.height += 100
        return size
    }
    
    // MARK: - 注册数据
    /// 注册数据
    open class func register(in cvc : UICollectionViewController,
                             identifier idf : String)
    {
        let bundle = Bundle.init(for: self.classForCoder())
        let name = self.xClassInfoStruct.name
        let nib = UINib.init(nibName: name, bundle: bundle)
        cvc.collectionView.register(nib, forCellWithReuseIdentifier: idf)
    }
    
}
