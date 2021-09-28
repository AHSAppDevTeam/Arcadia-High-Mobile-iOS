//
//  schedulePageViewController.swift
//  AHS
//
//  Created by Richard Wei on 8/29/21.
//

import Foundation
import UIKit
import JTAppleCalendar

class schedulePageViewController : presentableViewController{
    
    //
    
    let mainScrollView : UIButtonScrollView = UIButtonScrollView();
    
    //
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.setupPanGesture();
        
        self.view.backgroundColor = BackgroundColor;
        
        //
        
        mainScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height);
        
        mainScrollView.alwaysBounceVertical = true;
        
        self.view.addSubview(mainScrollView);
        
        //
        
        //mainScrollView.backgroundColor = .systemBlue;
        
    }
    
    internal func renderStaticContent(){
        
    
        
    }
    
    internal func renderContent(){
        
    }
    
}
