//
//  WYListAnimateController.swift
//  WYListViewController
//
//  Created by iosci on 2016/10/21.
//  Copyright © 2016年 secoo. All rights reserved.
//

import UIKit

open class WYListPresentationController: UIPresentationController {
    
    weak var bgView: UIView!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(handleDeviceOrientationNotification(_:)), name: Notification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    @objc private func handleDismiss() {
        self.presentingViewController.dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleDeviceOrientationNotification(_ note: Notification) {
        self.bgView.frame = (self.containerView?.bounds)!
        self.presentedView?.frame = self.frameOfPresentedViewInContainerView
    }
    
    override open func presentationTransitionWillBegin() {
        guard let containerView = self.containerView else {
            print("error!")
            return
        }
        let bgView  = UIView(frame: containerView.bounds)
        bgView.backgroundColor = UIColor.clear
        containerView.insertSubview(bgView, at: 0)
        self.bgView = bgView
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
        self.bgView.addGestureRecognizer(tap)
        
        self.presentingViewController.viewWillDisappear(true)
        self.presentingViewController.transitionCoordinator?.animate(alongsideTransition: { [unowned self] (UIViewControllerTransitionCoordinatorContext) in
            self.presentingViewController.view.transform = self.presentingViewController.view.transform.scaledBy(x: 0.9, y: 0.9)
            self.bgView.backgroundColor = UIColor(white: 0, alpha: 0.6)
            }, completion: nil)
    }
    
    override open func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            self.presentingViewController.viewDidDisappear(true)
            self.bgView.removeFromSuperview()
        }
    }
    
    override open func dismissalTransitionWillBegin() {
        self.presentingViewController.viewWillAppear(true)
        self.presentingViewController.transitionCoordinator?.animate(alongsideTransition: { [unowned self] (transitionCoordinatorContext) in
            self.presentingViewController.view.transform = CGAffineTransform.identity
            self.bgView.backgroundColor = UIColor.clear
            }, completion: nil)
    }
    
    override open func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            self.presentingViewController.viewDidAppear(true)
            self.bgView.removeFromSuperview()
        }
    }
    
    override open var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = self.containerView else {
            return CGRect.zero
        }
        let width: CGFloat = containerView.bounds.size.width
        let height: CGFloat = min(400.0, containerView.bounds.size.height - 44)
        return CGRect(x: 0, y: containerView.bounds.size.height - height, width: width, height: height)
    }
    
    override open var presentedView: UIView? {
        let v = self.presentedViewController.view
        v?.layer.cornerRadius = 5
        v?.clipsToBounds = true
        return v
    }
}
