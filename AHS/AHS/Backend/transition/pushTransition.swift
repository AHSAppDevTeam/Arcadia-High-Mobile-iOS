//
//  pushTransition.swift
//  AHS
//
//  Created by Richard Wei on 5/25/21.
//

import Foundation
import UIKit
import AudioToolbox

open class pushTransition: NSObject, UIViewControllerAnimatedTransitioning{
    private let duration: TimeInterval;
    
    public init(duration: TimeInterval = 0.2) {
        self.duration = duration;
        super.init();
    }
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration;
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to)
        else {
            return;
        }
        
        UIImpactFeedbackGenerator(style: .light).impactOccurred();
        
        transitionContext.containerView.insertSubview(toViewController.view, aboveSubview: fromViewController.view)
        toViewController.view.frame = CGRect(x: AppUtility.getCurrentScreenSize().width, y: 0, width: toViewController.view.frame.width, height: toViewController.view.frame.height);
        
        
        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            toViewController.view.frame = CGRect(x: 0, y: 0, width: toViewController.view.frame.width, height: toViewController.view.frame.height);
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
