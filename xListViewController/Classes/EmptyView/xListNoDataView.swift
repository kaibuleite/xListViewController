//
//  xListNoDataView.swift
//  xListViewController
//
//  Created by Mac on 2021/6/12.
//

import UIKit

open class xListNoDataView: UIView {

    // MARK: - Enum
    /// 提示类型
    public enum TipIconStyle {
        /// 默认
        case deft
        /// 包裹
        case pack
        /// 脸
        case face
        /// 消息
        case msg
    }
    
    // MARK: - IBOutlet Property
    @IBOutlet public weak var tipIcon: UIImageView?
    @IBOutlet public weak var tipLbl: UILabel?
    
    // MARK: - Override Func
    open class func xDefaultViewController() -> Self {
        let bundle = Bundle.init(for: self.classForCoder())
        let name = self.xClassInfoStruct.name
        let arr = bundle.loadNibNamed(name, owner: nil, options: nil)!
        let view = arr.first!
        return view as! Self
    }
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.isHidden = true
    }

    // MARK: - 部署列表
    /// 部署TVC列表
    open func setContainerList(_ tvc : xListTableViewController)
    {
        var frame = tvc.tableView.bounds
        frame.size.height = frame.width
        /*
         var height = frame.size.height
         // section头部高度
         let headerH = tvc.tableView(tvc.tableView, heightForHeaderInSection: 0)
         height -= headerH * 2
         // section尾部高度
         let footerH = tvc.tableView(tvc.tableView, heightForFooterInSection: 0)
         height -= footerH * 2
         if height < 0 {
             print("⚠️ Table View 头部和尾部高度太大，内容无法展示出来")
             height = 0
         }
         */
        self.frame = frame
    }
    /// 部署CVC列表
    open func setContainerList(_ cvc : xListCollectionViewController)
    {
        var frame = cvc.collectionView.bounds
        frame.size.height = frame.width
        /*
         var height = frame.size.height
         // section头部高度
         let headerH = cvc.flowLayout.headerReferenceSize.height
         height -= headerH * 2
         // section尾部高度
         let footerH = cvc.flowLayout.footerReferenceSize.height
         height -= footerH * 2
         if height < 0 {
             print("⚠️ Collect View 头部和尾部高度太大，内容无法展示出来")
             height = 0
         }
         */
        self.frame = frame
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
