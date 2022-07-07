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
    }
    
}

// MARK: - Cell数据
extension xDefaultListCollectionViewController {
    
    // MARK: - 注册Cell
    /// 注册Cell
    open override func registerCells() {
        xCellClass.register(in: self, identifier: "Cell")
    }
    // MARK: - 默认Cell
    /// 默认Cell
    open func defaultCell(at idp : IndexPath) -> UICollectionViewCell
    {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: idp) as! xCollectionViewCell
        // 数据填充
        let model = self.dataArray[idp.row]
        cell.setContentData(in: self, at: idp, with: model)
        
        return cell
    }
}

// MARK: - Collection view data source
extension xDefaultListCollectionViewController {
    
    open override func collectionView(_ collectionView: UICollectionView,
                                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        return self.defaultCell(at: indexPath)
    }
} 
