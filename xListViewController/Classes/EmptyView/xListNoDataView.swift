//
//  xListNoDataView.swift
//  xListViewController
//
//  Created by Mac on 2021/6/12.
//

import UIKit

class xListNoDataView: UIView {

    // MARK: - Public Func
    public class func loadNib() -> xListNoDataView {
        let bundle = Bundle.init(for: self.classForCoder())
        let arr = bundle.loadNibNamed("xListNoDataView", owner: nil, options: nil)!
        let view = arr.first! as! xListNoDataView
        return view
    }

}
