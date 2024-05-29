//
//  ViewController.swift
//  xListViewController
//
//  Created by 177955297@qq.com on 06/11/2021.
//  Copyright (c) 2021 177955297@qq.com. All rights reserved.
//

import UIKit
import xModel
import xListViewController

class ViewController: UIViewController {
    
    // MARK: - IBOutlet Property
    @IBOutlet weak var childContainer: UIView!
    
    // MARK: - Public Property
    var dataType = 0
    
    // MARK: - Child
    let childTableList = TestListTableViewController.xDefaultViewController(style: .grouped)
    let childColleList = TestListCollectionViewController.xDefaultViewController(direction: .vertical)
    let childModuleList = xListModuleViewController.xDefaultViewController()
    
    // MARK: - Override Func
    override func viewDidLoad() {
        super.viewDidLoad()
        // 基本配置
        self.view.backgroundColor = .white
        self.childModuleList.update(cell: TestListModuleCell.self)
        self.childModuleList.update(row: 2, rowSpacing: 10, column: 4, columnSpacing: 10)
        self.childModuleList.addClickCell {
            (module) in
            print(module.xName)
        }
        
        DispatchQueue.main.async {
            self.addChildren()
        }
    }
    
    override func addChildren() {
        self.xAddChild(viewController: self.childTableList, in: self.childContainer)
        self.xAddChild(viewController: self.childColleList, in: self.childContainer)
        self.xAddChild(viewController: self.childModuleList, in: self.childContainer)
    }

    // MARK: - 切换
    @IBAction func tableBtnClick()
    {
        print("\(#function) in \(type(of: self))")
        self.view.endEditing(true)
        self.dataType = 0
        self.childTableList.view.isHidden = false
        self.childColleList.view.isHidden = true
        self.childModuleList.view.isHidden = true
        self.refreshBtnClick()
    }
    @IBAction func collectionBtnClick()
    {
        print("\(#function) in \(type(of: self))")
        self.view.endEditing(true)
        self.dataType = 1
        self.childTableList.view.isHidden = true
        self.childColleList.view.isHidden = false
        self.childModuleList.view.isHidden = true
        self.refreshBtnClick()
    }
    @IBAction func moduleBtnClick()
    {
        print("\(#function) in \(type(of: self))")
        self.view.endEditing(true)
        self.dataType = 2
        self.childTableList.view.isHidden = true
        self.childColleList.view.isHidden = true
        self.childModuleList.view.isHidden = false
        
        self.refreshBtnClick()
    }
    
    // MARK: - 刷新
    @IBAction func refreshBtnClick()
    {
        print("\(#function) in \(type(of: self))")
        self.view.endEditing(true)
         
        if self.dataType == 0 {
            self.childTableList.refreshHeader()
        } else
        if self.dataType == 1 {
            self.childColleList.refreshHeader()
        } else {
            // 模拟数据
            var arr = [[String : Any]]()
            arr.append(["id" : "21", "name" : "生鲜超市", "pic" : "https://mall-fudouzhongkang.oss-cn-shenzhen.aliyuncs.com/upload/slider/000/000/001/6593839bce91a189.png"])
            arr.append(["id" : "22", "name" : "商城", "pic" : "https://mall-fudouzhongkang.oss-cn-shenzhen.aliyuncs.com/upload/slider/000/000/001/659384015df44735.png"])
            arr.append(["id" : "72", "name" : "生活服务", "pic" : "https://mall-fudouzhongkang.oss-cn-shenzhen.aliyuncs.com/upload/slider/000/000/001/65e6bcbb87528786.png"])
            arr.append(["id" : "173", "name" : "央街夜市", "pic" : "https://mall-fudouzhongkang.oss-cn-shenzhen.aliyuncs.com/upload/slider/000/000/001/66544ab91911a191.png"])
            arr.append(["id" : "71", "name" : "旅游度假", "pic" : "https://mall-fudouzhongkang.oss-cn-shenzhen.aliyuncs.com/upload/slider/000/000/001/663c976c34f94759.png"])
            arr.append(["id" : "2", "name" : "自营品牌", "pic" : "https://mall-fudouzhongkang.oss-cn-shenzhen.aliyuncs.com/upload/slider/000/000/001/659383b8ceb77873.png"])
            arr.append(["id" : "78", "name" : "创业就业", "pic" : "https://mall-fudouzhongkang.oss-cn-shenzhen.aliyuncs.com/upload/slider/000/000/001/65e67c64e8942155.png"])
            arr.append(["id" : "131", "name" : "婚恋介绍", "pic" : "https://mall-fudouzhongkang.oss-cn-shenzhen.aliyuncs.com/upload/slider/000/000/001/659383cc809bc984.png"])
            arr.append(["id" : "130", "name" : "健康食疗", "pic" : "https://mall-fudouzhongkang.oss-cn-shenzhen.aliyuncs.com/upload/slider/000/000/001/659383a6b1bab406.png"])
            arr.append(["id" : "66", "name" : "家装团购", "pic" : "https://mall-fudouzhongkang.oss-cn-shenzhen.aliyuncs.com/upload/slider/000/000/001/659383c0b5a3d618.png"])
            let list = xModuleModel.newList(with: arr) as! [xModuleModel]
            self.childModuleList.reloadData(list + list)
            
        }
    }
    
}

