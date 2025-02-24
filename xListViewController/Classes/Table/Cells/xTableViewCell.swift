//
//  xTableViewCell.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2020/9/15.
//

import UIKit
import xExtension
import xModel

open class xTableViewCell: UITableViewCell {
    
    // MARK: - Public Property
    public var idp = IndexPath.init(row: -1, section: -1)
    
    // MARK: - Override Func
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - 设置内容数据
    /// 设置内容数据
    open func setContentData(in tvc : xTableViewController? = nil,
                             at idp : IndexPath,
                             with model : xModel)
    {
        self.idp = idp
        /* 设置Cell内容 */
    }
    
    /// 重新加载显示时的数据
    open func reloadVisibleContentData()
    {
        /*
         该方法会在scrollview停止滚动后才调用
         为了优化网络加载图片导致的卡顿可以将图片放到这里加载
         model 和 list 在 setContentData 时保存
         */
//        print("Reload Visible \(self.idp.row)")
    }
    
    // MARK: - 内容高度
    /// 内容高度
    open class func contentHeight() -> CGFloat
    {
        var h = CGFloat.zero
        h += 45
        return h
    }
    
    // MARK: - 注册数据
    /// 注册数据
    open class func register(in tvc : UITableViewController,
                             identifier idf : String)
    {
        let bundle = Bundle.init(for: self.classForCoder())
        let name = self.xClassInfoStruct.name
        let nib = UINib.init(nibName: name, bundle: bundle)
        tvc.tableView.register(nib, forCellReuseIdentifier: idf)
    }
    
}
