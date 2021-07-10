//
//  notificationPageViewController.swift
//  AHS
//
//  Created by Richard Wei on 7/9/21.
//

import Foundation
import UIKit

class notificationPageViewController : presentableViewController{
    override func viewDidLoad() {
        super.viewDidLoad();
        
        setupPanGesture();
        
        self.view.backgroundColor = .systemRed;
    }
}
