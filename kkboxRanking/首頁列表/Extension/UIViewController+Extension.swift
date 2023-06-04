//
//  UIViewController+Extension.swift
//  kkboxRanking
//
//  Created by 黃柏嘉 on 2023/6/4.
//

import UIKit

extension UIViewController{
    public func customBackButton()->UIButton{
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        backButton.tintColor = .white
        backButton.setImage(UIImage(named: "Back"), for: .normal)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        return backButton
    }
    
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
}
