//
//  xListNoDataView.swift
//  xListViewController
//
//  Created by Mac on 2021/6/12.
//

import UIKit

public class xListNoDataView: UIView {

    // MARK: - IBOutlet Property
    @IBOutlet public weak var tipIcon: UIImageView!
    @IBOutlet public weak var tipLbl: UILabel!
    
    // MARK: - Public Func  
    class func loadXib() -> Self {
        let bundle = Bundle.init(for: self.classForCoder())
        let name = self.xClassInfoStruct.name
        let arr = bundle.loadNibNamed(name, owner: nil, options: nil)!
        let view = arr.first!
        return view as! Self
    }
    
    // MARK: - Override Func
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }

}
