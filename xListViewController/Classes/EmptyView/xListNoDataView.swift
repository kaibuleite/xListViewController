//
//  xListNoDataView.swift
//  xListViewController
//
//  Created by Mac on 2021/6/12.
//

import UIKit

open class xListNoDataView: UIView {

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
    open func setContainerList(_ tvc : xTableViewController)
    {
        var frame = tvc.tableView.bounds
        var height = frame.size.height
        // section头部高度
        height -= tvc.tableView(tvc.tableView, heightForHeaderInSection: 0) * 2
        // section尾部高度
        height -= tvc.tableView(tvc.tableView, heightForFooterInSection: 0) * 2
        if height < 0 {
            print("⚠️ Table头部和尾部高度太大，内容无法展示出来")
            height = 0
        }
        frame.size.height = height
        self.frame = frame
    }
    /// 部署CVC列表
    open func setContainerList(_ cvc : xCollectionViewController)
    {
        var frame = cvc.collectionView.bounds
        var height = frame.size.height
        // section头部高度
        height -= cvc.flowLayout.headerReferenceSize.height * 2
        // section尾部高度
        height -= cvc.flowLayout.footerReferenceSize.height * 2
        if height < 0 {
            print("⚠️ Collect头部和尾部高度太大，内容无法展示出来")
            height = 0
        }
        frame.size.height = height
        self.frame = frame
    }
    
    // MARK: - 重新加载数据
    /// 重新加载数据
    public func setTip(icon : UIImage? = nil,
                       message : String)
    {
        self.tipIcon?.image = icon
        self.tipIcon?.isHidden = (icon == nil)
        self.tipLbl?.text = message
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
}
