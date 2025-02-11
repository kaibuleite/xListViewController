//
//  xDefaultListCollectionViewController.swift
//  xListViewController
//
//  Created by Mac on 2022/7/6.
//

import UIKit
import xModel

// MARK: - 初始化列表
open class xDefaultListCollectionViewController: xListCollectionViewController {
    
    // MARK: - Public Property
    open var xCellClass : xCollectionViewCell.Type {
        return xCollectionViewCell.self
    }
    
    // MARK: - Override Func
    open override func viewDidLoad() {
        super.viewDidLoad()
        // 基本配置
        self.view.backgroundColor = .clear
        self.collectionView.backgroundColor = .clear
        let size = self.xCellClass.contentSize()
        self.reset(item: size)
    }
    
    // MARK: - 注册Cell
    /// 注册Cell
    open override func registerCells() {
        xCellClass.register(in: self, identifier: "Cell")
    }
    
}
