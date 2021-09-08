//
//  aboutUsPageBackgroundGradient.swift
//  AHS
//
//  Created by Richard Wei on 9/3/21.
//

import Foundation
import UIKit

extension aboutUsPageViewController{
    
    internal func setupBackgroundGradient(){
        
        backgroundGradientSet = [];
        
        for sublayer in self.view.layer.sublayers ?? []{
            if sublayer == backgroundGradient{
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
        
        backgroundGradientSet.append([one, two]);
        backgroundGradientSet.append([two, three]);
        backgroundGradientSet.append([three, four]);
        backgroundGradientSet.append([four, five]);
        backgroundGradientSet.append([five, six]);
        backgroundGradientSet.append([six, seven]);
        backgroundGradientSet.append([seven, one]);
        
        //
        
        backgroundGradient.colors = backgroundGradientSet[backgroundCurrentGradient];
        backgroundGradient.startPoint = CGPoint(x:0, y:0);
        backgroundGradient.endPoint = CGPoint(x:1, y:1);
        backgroundGradient.drawsAsynchronously = true;
        self.view.layer.insertSublayer(backgroundGradient, at: 0);
    }
    
    internal func animateBackgroundGradient(){
        if backgroundCurrentGradient < backgroundGradientSet.count - 1 {
            backgroundCurrentGradient += 1;
        } else {
            backgroundCurrentGradient = 0;
        }
        
        //print("animate - \(backgroundCurrentGradient)")
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors");
        gradientChangeAnimation.duration = 2.0;
        gradientChangeAnimation.toValue = backgroundGradientSet[backgroundCurrentGradient];
        gradientChangeAnimation.fillMode = .forwards;
        gradientChangeAnimation.isRemovedOnCompletion = false;
        gradientChangeAnimation.delegate = self;
        backgroundGradient.add(gradientChangeAnimation, forKey: "colorChange");
    }
    
}


extension aboutUsPageViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            backgroundGradient.colors = backgroundGradientSet[backgroundCurrentGradient];
            animateBackgroundGradient();
        }
    }
}
