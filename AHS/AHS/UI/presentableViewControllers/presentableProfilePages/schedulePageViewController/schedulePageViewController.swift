//
//  schedulePageViewController.swift
//  AHS
//
//  Created by Richard Wei on 8/29/21.
//

import Foundation
import UIKit

class schedulePageViewController : presentableViewController{
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.setupPanGesture();
        
        self.view.backgroundColor = .systemRed;
    }
}
