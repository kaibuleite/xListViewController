//
//  xListHeaderContainer.swift
//  Pods-xSDK_Example
//
//  Created by Mac on 2024/6/4.
//

import UIKit
import xExtension

open class xListHeaderContainer: UIViewController {
    
    // MARK: - Handler
    public typealias xHandlerRefreshContainerList = (CGRect) -> Void
    
    // MARK: - IBOutlet Property
    @IBOutlet public weak var contentStack: UIStackView!
    
    // MARK: - Public Property
    /// 加载回调
    var refreshHandler : xHandlerRefreshContainerList?
    /// 内容高度
    public var contentHeight : CGFloat {
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        let h = self.contentStack.frame.height
        return h
    } 
    
    // MARK: - 内存释放
    deinit {
        self.refreshHandler = nil
        let info = self.xClassInfoStruct
        let space = info.space
        let name = info.name
        print("🧢【\(space).\(name)】")
    }
    
    // MARK: - Override Func
    open override func viewDidLoad() {
        super.viewDidLoad()
        // 基本配置
        self.view.backgroundColor = .clear
    }
    
    // MARK: - 加载内容
    /// 加载内容
    public func reloaHeaderSectionData(_ array : [xListHeaderSection])
    {
        // 移除旧控件
        self.contentStack.xRemoveAllSubViews()
        // 添加新空间
        for header in array {
            self.addChild(header)
            self.contentStack.addArrangedSubview(header.view)
        }
        self.refreshContainerList()
    }
    
    // MARK: - 刷新容器
    /// 刷新容器
    public func refreshContainerList(from section : xListHeaderSection? = nil)
    {
        guard let containerList = self.parent else {
            print("⚠️ 列表头部获取失败")
            return
        }
        var frame = self.view.bounds
        frame.size.height = self.contentHeight
        self.view.frame = frame
        let sectionName = section?.xClassInfoStruct.name ?? "Container"
        
        if let list = containerList as? xListTableViewController {
            list.tableView.reloadData()
            list.reloadEmptyView()
            print("♻️ 刷新Table列表【\(sectionName)】")
        } else
        if let list = containerList as? xListCollectionViewController {
            list.reset(header: frame.size)
            list.reloadEmptyView()
            print("♻️ 刷新Colle列表【\(sectionName)】")
        } else {
            print("⚠️ 未知的列表 = \(containerList)")
        }
        self.refreshHandler?(frame)
    }
    
    // MARK: - 添加回调
    /// 添加回调
    public func addRefreshContainerList(handler : @escaping xListHeaderContainer.xHandlerRefreshContainerList)
    {
        self.refreshHandler = handler
    }

}
