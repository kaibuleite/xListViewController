//
//  xModuleModel.swift
//  xListViewController
//
//  Created by Mac on 2024/5/28.
//

import xModel

public class xModuleModel: xModel {

    /// ID
    public var xID = ""
    var id = "" { willSet { self.xID = newValue } }
    /// 分类关键词
    public var xKey = ""
    var key = "" { willSet { self.xKey = newValue } }
    /// 名称
    public var xName = ""
    var name = "" { willSet { self.xName = newValue } }
    var value = "" { willSet { self.xName = newValue } }
    /// 图片
    public var xLogo = ""
    var pic = "" { willSet { self.xLogo = newValue } }
    /// 链接
    public var xURL = ""
    var url = "" { willSet { self.xURL = newValue } }
    
    // MARK: - 实例化对象
    /// 实例化对象
    /// - Parameters:
    ///   - id: id
    ///   - name: 名称
    ///   - logo: logo
    public func xNew(id : String,
                     name : String,
                     logo : String)
    {
        self.xID = id
        self.xName = name
        self.xLogo = logo
    }
    
}
