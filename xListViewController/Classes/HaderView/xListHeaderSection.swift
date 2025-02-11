//
//  xListHeaderSection.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2024/6/4.
//

import UIKit
import xExtension

open class xListHeaderSection: UIViewController {
    
    // MARK: - IBOutlet Property
    @IBOutlet public weak var contentView: UIView?
    @IBOutlet public weak var contentHeightLayout: NSLayoutConstraint?
    @IBOutlet public weak var sectionTopLayout: NSLayoutConstraint?
    @IBOutlet public weak var sectionLeadingLayout: NSLayoutConstraint?
    
    // MARK: - Public Property
    /// 上间距
    public var topMargin : CGFloat = .zero
    /// 下间距
    public var bottomMargin : CGFloat = .zero
    /// 左右间距
    public var leadingMargin : CGFloat = 10
    
    /// 控件是否加载完成
    public var allKitControlIsLoad = false
    // 分块总高度
    var sectionHeightLayout: NSLayoutConstraint?
    
    // MARK: - 内存释放
    deinit { 
        let info = self.xClassInfoStruct
        let space = info.space
        let name = info.name
        print("👒【\(space).\(name)】")
    }
    
    // MARK: - Override Func
    open override func viewDidLoad() {
        super.viewDidLoad()
        // 基本配置
        self.view.isHidden = true
        self.view.backgroundColor = .clear
        let layout = self.view.xAddHeightLayout(constant: 100)
        self.sectionHeightLayout = layout
        // 防止约束冲突
        self.sectionLeadingLayout?.priority = .init(900)
        if self.contentView == nil {
            print("⚠️⚠️⚠️ 请关联 contentView [\(self)]")
        }
    }
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.allKitControlIsLoad = true
    }
    
    // MARK: - 更新内容高度
    /// 更新内容高度
    public func updateContentHeight()
    {
        self.sectionTopLayout?.constant = self.topMargin
        self.sectionLeadingLayout?.constant = self.leadingMargin
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        let contentHeight = self.contentView?.bounds.height ?? 0
        self.sectionHeightLayout?.constant = self.topMargin + contentHeight + self.bottomMargin
        self.view.isHidden = (contentHeight <= 0)
        self.refreshContainerList()
    }
    /// 更新内容高度
    public func refreshContainerList()
    {
        guard let container = self.parent as? xListHeaderContainer else { return }
        container.refreshContainerList(from: self)
    }
    
    // MARK: - 更新配置
    /// 更新配置
    public func updateMargin(top : CGFloat = 0,
                             bottom : CGFloat = 0,
                             leading : CGFloat = 0)
    {
        self.topMargin = top
        self.bottomMargin = bottom
        self.leadingMargin = leading
    }
    
}
