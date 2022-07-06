//
//  xTableViewCell.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/15.
//

import UIKit
import xModel

open class xTableViewCell: UITableViewCell {
    
    // MARK: - Open Override Func
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Open Func
    /// 设置内容数据
    open func setContentData(in tvc : xTableViewController? = nil,
                             at idp : IndexPath,
                             with model : xModel)
    {
        /*
        tvc.isOpenReloadDragScrollingEndVisibleCells = true
        if tvc.isDragScrolling {
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
    open class func contentHeight() -> CGFloat
    {
        var h = CGFloat.zero
        h += 45
        return h
    }
    
}
