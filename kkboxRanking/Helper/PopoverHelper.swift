//
//  PopoverHelper.swift
//  kkboxRanking
//
//  Created by 黃柏嘉 on 2023/6/13.
//

import UIKit

class PopoverHelper:NSObject,UIPopoverPresentationControllerDelegate{
    
    static let shared = PopoverHelper()
    private var viewController:UIViewController?
    private var dismissHandler:(()->())?
    
    func configure(from viewController:UIViewController,
                   dismissHandler:(()->())?)->UIPopoverPresentationController
    {
        
        self.viewController = viewController
        self.dismissHandler = dismissHandler
        
        viewController.modalPresentationStyle = .popover
        
        guard let presentationController = viewController.presentationController as? UIPopoverPresentationController
        else {
            return UIPopoverPresentationController(presentedViewController: viewController, presenting: nil)
        }
        
        presentationController.delegate = self
        
        return presentationController
    }
    
    //MARK: UIPopoverPresentationController Delegate
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        dismissHandler?()
        self.dismissHandler = nil
    }
}

extension UIViewController{
    
    func popover(on parent:UIViewController,
                 sourceView:UIView,
                 preferredContentSize:CGSize,
                 customInsets:UIEdgeInsets,
                 dismissHandler:(()->())?){
        
        let popController = PopoverHelper.shared.configure(from: self, dismissHandler: dismissHandler)
        
        let sourceRect = sourceView.convert(sourceView.bounds, to: parent.view)
        
        popController.sourceRect = sourceRect
        popController.sourceView = parent.view
        //是否可重疊sourceRect
        popController.canOverlapSourceViewRect = true
        popController.passthroughViews = [sourceView]
        //彈出箭頭的方法
        popController.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
        popController.popoverBackgroundViewClass = RightAngleBackgroundView.self
        popController.popoverLayoutMargins = customInsets
        self.preferredContentSize = preferredContentSize
        
        parent.present(self, animated: true)
    }
}
