//
//  TestListModuleCell.swift
//  xListViewController_Example
//
//  Created by Mac on 2024/5/28.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import xModel
import xListViewController

class TestListModuleCell: xModuleCell {

    // MARK: - IBOutlet Property
    @IBOutlet weak var logoIcon: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    // MARK: - Public Property
    
    // MARK: - Override Func
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - 内容填充
    /// 普通填充
    override func setContentData(_ model: xModuleModel)
    {
        self.nameLbl.text = model.xName
        guard let url = model.xLogo.xToURL() else {
            print("⚠️\(model.xName) Image Load Failure 1 \(model.xLogo)")
            return
        }
        DispatchQueue.global().async {
            guard let data = try? Data.init(contentsOf: url) else {
                print("⚠️\(model.xName) Image Load Failure 2 \(model.xLogo)")
                return
            }
            DispatchQueue.main.async {
                // 测试版不做缓存策略
                self.logoIcon.image = .init(data: data)
            }
        }
    }
    
}
