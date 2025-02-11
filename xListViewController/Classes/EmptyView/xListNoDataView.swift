//
//  xListNoDataView.swift
//  xListViewController
//
//  Created by Mac on 2021/6/12.
//

import UIKit
import xDefine
import xExtension

open class xListNoDataView: UIView {

    // MARK: - Enum
    /// 提示类型
    public enum TipIconStyle: Int {
        /// 默认
        case deft = 0
        /// 包裹
        case pack = 1
        /// 脸
        case face = 2
        /// 消息
        case msg = 3
    }
    
    // MARK: - IBOutlet Property
    @IBOutlet public weak var tipIcon: UIImageView?
    @IBOutlet public weak var tipLbl: UILabel?
    
    // MARK: - 实例化对象
    /// 实例化对象
    /// - Parameters:
    ///   - style: 提示样式
    ///   - message: 提示信息
    open class func newTip(style : xListNoDataView.TipIconStyle,
                           message : String) -> Self
    {
        var name = ""
        switch style {
        case .pack: name = "no_data_pack"
        case .face: name = "no_data_face"
        case .msg:  name = "no_data_message"
        default:    name = "no_data"
        }
        let bundle = Bundle.init(for: Self.classForCoder())
        let image = name.xToImage(in: bundle)
        let view = Self.newTip(image: image,
                               message: message)
        return view
    }
    /// 实例化对象
    ///   - image: 提示图片
    ///   - message: 提示信息
    open class func newTip(image : UIImage? = nil,
                           message : String) -> Self
    {
        let bundle = Bundle.init(for: self.classForCoder())
        let name = self.xClassInfoStruct.name
        let arr = bundle.loadNibNamed(name, owner: nil, options: nil)!
        let view = arr.first! as! Self
        
        view.tipIcon?.image = image
        view.tipIcon?.isHidden = (image == nil)
        view.tipLbl?.text = message
        view.frame = .init(x: 0, y: 0,
                           width: xScreenWidth,
                           height: xScreenWidth)
        return view
    }
    
    // MARK: - 设置提示内容
    /// 设置提示内容
    open func setTip(icon : UIImage? = nil,
                     message : String)
    {
        self.tipIcon?.image = icon
        self.tipIcon?.isHidden = (icon == nil)
        self.tipLbl?.text = message
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    /// 设置提示内容
    open func setTip(style : xListNoDataView.TipIconStyle,
                     message : String)
    {
        var name = ""
        switch style {
        case .pack: name = "no_data_pack"
        case .face: name = "no_data_face"
        case .msg:  name = "no_data_message"
        default:    name = "no_data"
        }
        self.tipIcon?.isHidden = true
        if name.count > 0 {
            let bundle = Bundle.init(for: self.classForCoder)
            let img = name.xToImage(in: bundle)
            self.tipIcon?.image = img
            self.tipIcon?.isHidden = (img == nil)
        }
        self.tipLbl?.text = message
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
}
