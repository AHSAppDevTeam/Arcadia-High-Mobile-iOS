//
//  notificationSettingsPageViewController.swift
//  AHS
//
//  Created by Richard Wei on 8/29/21.
//

import Foundation
import UIKit

class notificationSettingsPageViewController : presentableViewController{
    
    internal let mainScrollView : UIScrollView = UIScrollView();
    
    //
    
    override func viewDidLoad(){
        super.viewDidLoad();
        
        self.setupPanGesture();
        
        self.view.backgroundColor = .white
        
        //
        
        mainScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height);
        self.view.addSubview(mainScrollView);
        
        //
    }
}
