//
//  profilePageScheduleGradient.swift
//  AHS
//
//  Created by Richard Wei on 11/16/21.
//

import Foundation
import UIKit

extension profilePageViewController{
    
    internal func setupBackgroundScheduleGradient(){
        backgroundScheduleGradientSet = [];
        
        for sublayer in scheduleView.layer.sublayers ?? []{
            if sublayer == backgroundScheduleGradient{
                sublayer.removeFromSuperlayer();
            }
        }
        
        // colors here
        
        let one = UIColor.init(hex: "#70afb4").cgColor;
        let two = UIColor.init(hex: "#167e96").cgColor;
        /*let three = UIColor.init(hex: "#BD6586").cgColor;
        let four = UIColor.init(hex: "#845F8C").cgColor;
        let five = UIColor.init(hex: "#BC6C92").cgColor;
        let six = UIColor.init(hex: "#EB7F88").cgColor;
        let seven = UIColor.init(hex: "#FF9F76").cgColor;*/
        
        backgroundScheduleGradientSet.append([one, two]);
        backgroundScheduleGradientSet.append([two, one]);
        /*backgroundIDGradientSet.append([two, three]);
        backgroundIDGradientSet.append([three, four]);
        backgroundIDGradientSet.append([four, five]);
        backgroundIDGradientSet.append([five, six]);
        backgroundIDGradientSet.append([six, seven]);
        backgroundIDGradientSet.append([seven, one]);*/
        
        //
        
        backgroundScheduleGradient.colors = backgroundScheduleGradientSet[backgroundScheduleCurrentGradient];
        backgroundScheduleGradient.startPoint = CGPoint(x:0, y:0);
        backgroundScheduleGradient.endPoint = CGPoint(x:1, y:1);
        backgroundScheduleGradient.drawsAsynchronously = true;
        backgroundScheduleGradient.frame = CGRect(x: 0, y: 0, width: scheduleViewWidth, height: scheduleViewHeight);
        
        scheduleView.layer.insertSublayer(backgroundScheduleGradient, at: 0);
    }
    
    /*internal func animateBackgroundScheduleGradient(){
        if backgroundScheduleCurrentGradient < backgroundScheduleGradientSet.count - 1 {
            backgroundScheduleCurrentGradient += 1;
        } else {
            backgroundScheduleCurrentGradient = 0;
        }
        
        //print("animate - \(backgroundIDCurrentGradient)")
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors");
        gradientChangeAnimation.duration = 2.0;
        gradientChangeAnimation.toValue = backgroundScheduleGradientSet[backgroundScheduleCurrentGradient];
        gradientChangeAnimation.fillMode = .forwards;
        gradientChangeAnimation.isRemovedOnCompletion = false;
        gradientChangeAnimation.delegate = self;
        backgroundScheduleGradient.add(gradientChangeAnimation, forKey: "colorChangeSchedule");
    }*/
    
}
