//
//  popTransition.swift
//  AHS
//
//  Created by Richard Wei on 5/25/21.
//

import Foundation
import UIKit
import AudioToolbox

open class popTransition: NSObject, UIViewControllerAnimatedTransitioning{
    
    private let duration: TimeInterval;
    
    public init(duration: TimeInterval = 0.25) {
        self.duration = duration;
        super.init();
    }
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration;
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from)
        else {
            return;
        }
        
        UIImpactFeedbackGenerator(style: .light).impactOccurred();
        

        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            fromViewController.view.frame = CGRect(x: AppUtility.getCurrentScreenSize().width, y: 0, width: fromViewController.view.frame.width, height: fromViewController.view.frame.height);
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    static public func handlePan(_ gestureRecognizer: UIPanGestureRecognizer, fromViewController: UIViewController, dismissCompletionHandler: (() -> Void)? = nil){
        if (gestureRecognizer.state == .began || gestureRecognizer.state == .changed){
            let translation = gestureRecognizer.translation(in: fromViewController.view);
            
            fromViewController.view.frame = CGRect(x: max(fromViewController.view.frame.minX + translation.x, 0), y: 0, width: fromViewController.view.frame.width, height: fromViewController.view.frame.height);
            
            gestureRecognizer.setTranslation(.zero, in: fromViewController.view);
        }
        else if (gestureRecognizer.state == .ended){
            let thresholdPercent : CGFloat = 0.25; // if minx > thresholdPercent * uiscreen.main.bounds.width
            if (fromViewController.view.frame.minX >= thresholdPercent * AppUtility.getCurrentScreenSize().width){
        
                guard let compHandler = dismissCompletionHandler else{
                    fromViewController.dismiss(animated: true);
                    return;
                }
                
                compHandler();
                
            }
            else{
                UIView.animate(withDuration: 0.2, animations: {
                    fromViewController.view.frame = CGRect(x: 0, y: 0, width: fromViewController.view.frame.width, height: fromViewController.view.frame.height);
                });
            }
        }
    }
}
