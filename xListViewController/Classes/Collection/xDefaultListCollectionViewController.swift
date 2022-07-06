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
    open var DefaultCellName : String {
        return "Cell"
    }
    open var DefaultCellIdentifier : String {
        return "Cell"
    }
    
    // MARK: - Override Func
    open override func viewDidLoad() {
        super.viewDidLoad()
        // 基本配置
        self.view.backgroundColor = .clear
        self.collectionView.backgroundColor = .clear
    }
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.refreshHeader()
    }
    
    // TODO: - 点击Cell
    /// 点击Cell
    open func clickCell(at idp : IndexPath)
    {
        // 子类实现具体操作
    }

}

// MARK: - 数据刷新
extension xDefaultListCollectionViewController {
    
    open override func addMJRefresh() {
        self.addHeaderRefresh()
        self.addFooterRefresh()
    }
    open override func refreshDataList() {
        // 模拟数据
        let list = xModel.newRandomList()
        self.reloadData(list: list)
        self.refreshSuccess()
    }
}

// MARK: - Cell数据
extension xDefaultListCollectionViewController {
    
    // MARK: - 注册Cell
    /// 注册Cell
    open override func registerCells() {
        let bundle = Bundle.init(for: self.classForCoder)
        self.register(nibName: DefaultCellName, bundle: bundle, identifier: DefaultCellIdentifier)
    }
    // MARK: - 默认Cell
    /// 默认Cell
    open func defaultCell(at idp : IndexPath) -> UICollectionViewCell
    {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: DefaultCellIdentifier, for: idp) as! xCollectionViewCell
        // 数据填充
        let model = self.dataArray[idp.row]
        cell.setContentData(in: self, at: idp, with: model)
        
        return cell
    }
}

// MARK: - Collection view data source
extension xDefaultListCollectionViewController {
    
    open override func collectionView(_ collectionView: UICollectionView,
                                      numberOfItemsInSection section: Int) -> Int
    {
        return self.dataArray.count
    }
    open override func collectionView(_ collectionView: UICollectionView,
                                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        return self.defaultCell(at: indexPath)
    }
}

// MARK: - Collection view delegate
extension xDefaultListCollectionViewController {
    
    open override func collectionView(_ collectionView: UICollectionView,
                                      didSelectItemAt indexPath: IndexPath)
    {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.clickCell(at: indexPath)
    }
}
