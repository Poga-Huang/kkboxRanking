//
//  RightAngleBackgroundView.swift
//  kkboxRanking
//
//  Created by 黃柏嘉 on 2023/6/13.
//

import UIKit

class RightAngleBackgroundView: UIPopoverBackgroundView {
    
    override var arrowOffset: CGFloat{
        get{
            return 0.0
        }
        set{}
    }
    
    override var arrowDirection: UIPopoverArrowDirection{
        get{
            return .any
        }
        set{}
    }
    
    override class func arrowBase() -> CGFloat {
        return 0.0
    }
    
    override class func arrowHeight() -> CGFloat {
        return 0.0
    }
    
    override class func contentViewInsets() -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    override func awakeFromNib() {
        layer.cornerRadius = 0
        layer.masksToBounds = false
        self.clipsToBounds = false
    }
}
