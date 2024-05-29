//
//  xModuleCell.swift
//  xListViewController
//
//  Created by Mac on 2024/5/28.
//

import UIKit
import xExtension

open class xModuleCell: UIButton {
    
    // MARK: - Public Property
    
    // MARK: - Override Func
    open class func loadXib() -> Self {
        let bundle = Bundle.init(for: self.classForCoder())
        let name = self.xClassInfoStruct.name
        let arr = bundle.loadNibNamed(name, owner: nil, options: nil)!
        let view = arr.first!
        return view as! Self
    }
    open override func awakeFromNib() {
        super.awakeFromNib()
        
    } 
    
    // MARK: - 内容填充
    /// 普通填充
    open func setContentData(_ model: xModuleModel)
    {
        self.backgroundColor = .xNewRandom(alpha: 0.3)
    }
    
}
