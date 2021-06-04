//
//  spotlightPageViewController.swift
//  AHS
//
//  Created by Richard Wei on 6/4/21.
//

import Foundation
import UIKit


class spotlightPageViewController : presentableViewController{
    
    public var categoryID : String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        setupPanGesture();
        
        self.view.backgroundColor = .systemBlue;
        
        print("category id - \(categoryID)");
        
    }
    
}
