//
//  xCollectionViewCell.swift
//  Alamofire
//
//  Created by Mac on 2020/9/15.
//

import UIKit
import xModel

open class xCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Open Override Func
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Open Func
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
    
    /// 内容高度
    open class func contentSize() -> CGSize
    {
        var size = CGSize.zero
        size.height += 45
        return size
    }
}
