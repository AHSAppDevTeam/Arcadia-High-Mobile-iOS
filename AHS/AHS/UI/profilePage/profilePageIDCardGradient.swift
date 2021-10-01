//
//  profilePageIDCardGradient.swift
//  AHS
//
//  Created by Richard Wei on 8/3/21.
//

import Foundation
import UIKit

extension profilePageViewController{
    
    internal func setupIDBackgroundGradient(){
        
        backgroundIDGradientSet = [];
        
        for sublayer in idCardButton.layer.sublayers ?? []{
            if sublayer == backgroundIDGradient{
                sublayer.removeFromSuperlayer();
            }
        }
        
        // colors here
        
        let one = UIColor.init(hex: "#E69C4C").cgColor;
        let two = UIColor.init(hex: "#E1786B").cgColor;
        let three = UIColor.init(hex: "#BD6586").cgColor;
        let four = UIColor.init(hex: "#845F8C").cgColor;
        let five = UIColor.init(hex: "#BC6C92").cgColor;
        let six = UIColor.init(hex: "#EB7F88").cgColor;
        let seven = UIColor.init(hex: "#FF9F76").cgColor;
        
        backgroundIDGradientSet.append([one, two]);
        backgroundIDGradientSet.append([two, three]);
        backgroundIDGradientSet.append([three, four]);
        backgroundIDGradientSet.append([four, five]);
        backgroundIDGradientSet.append([five, six]);
        backgroundIDGradientSet.append([six, seven]);
        backgroundIDGradientSet.append([seven, one]);
        
        //
        
        backgroundIDGradient.colors = backgroundIDGradientSet[backgroundIDCurrentGradient];
        backgroundIDGradient.startPoint = CGPoint(x:0, y:0);
        backgroundIDGradient.endPoint = CGPoint(x:1, y:1);
        backgroundIDGradient.drawsAsynchronously = true;
        backgroundIDGradient.frame = CGRect(x: 0, y: 0, width: idCardButtonWidth, height: idCardButtonHeight);
        
        idCardButton.layer.insertSublayer(backgroundIDGradient, at: 0);
    }
    
    internal func animateIDBackgroundGradient(){
        
        if backgroundIDCurrentGradient < backgroundIDGradientSet.count - 1 {
            backgroundIDCurrentGradient += 1;
        } else {
            backgroundIDCurrentGradient = 0;
        }
        
        //print("animate - \(backgroundIDCurrentGradient)")
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors");
        gradientChangeAnimation.duration = 2.0;
        gradientChangeAnimation.toValue = backgroundIDGradientSet[backgroundIDCurrentGradient];
        gradientChangeAnimation.fillMode = .forwards;
        gradientChangeAnimation.isRemovedOnCompletion = false;
        gradientChangeAnimation.delegate = self;
        backgroundIDGradient.add(gradientChangeAnimation, forKey: "colorChange");
    }
    
}


extension profilePageViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            backgroundIDGradient.colors = backgroundIDGradientSet[backgroundIDCurrentGradient];
            animateIDBackgroundGradient();
        }
    }
}
