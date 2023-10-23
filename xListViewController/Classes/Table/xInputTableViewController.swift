//
//  xInputTableViewController.swift
//  xListViewController
//
//  Created by Mac on 2023/10/23.
//

import UIKit

open class xInputTableViewController: xTableViewController {
    
    // MARK: - Public Property
    /// 输入框容器
    public var inputArray = [UITextField]()
    
    // MARK: - Open Override Func
    open override func viewDidLoad() {
        super.viewDidLoad()
        // 设置输入框容器内容
        self.inputArray = .init()
        /// 为输入框容器添加校验事件
        //
    }  
    
    // MARK: - 检查是否所有输入框都输入内容
    /// 检查是否所有输入框都输入内容
    open func checkAllInputCompleted() -> Bool
    {
        for input in self.inputArray {
            let text = input.text ?? ""
            guard text.count == 0 else { continue }
            return false
        }
        return true
    }
    
}
