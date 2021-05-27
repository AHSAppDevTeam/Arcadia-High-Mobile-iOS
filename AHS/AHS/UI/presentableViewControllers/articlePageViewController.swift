//
//  articlePageViewController.swift
//  AHS
//
//  Created by Richard Wei on 5/25/21.
//

import Foundation
import UIKit


class articlePageViewController : presentableViewController{
    
    public var articleID : String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.view.backgroundColor = .systemBlue;
        
        setupPanGesture();
    }
    
    
    
}
