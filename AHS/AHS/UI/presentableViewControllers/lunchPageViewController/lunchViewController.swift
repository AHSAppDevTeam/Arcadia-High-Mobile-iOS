//
//  lunchViewController.swift
//  AHS
//
//  Created by Mathew Xie on 4/27/23.
//

import Foundation
import UIKit

class lunchViewController : presentableViewController, UIScrollViewDelegate {
    internal let mainScrollView : UIButtonScrollView = UIButtonScrollView();
    internal var nextY : CGFloat = 0;
    internal var topCategoryPickerButtons : [UIButton] = [];
    internal let horizontalPadding : CGFloat = 10;
    internal let verticalPadding : CGFloat = 5;

    //
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        mainScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height);
        mainScrollView.alwaysBounceVertical = true;
        mainScrollView.delegate = self;
        self.view.addSubview(mainScrollView);
        setupLunch()
    }
    
    private func setupLunch() {
        mainScrollView.backgroundColor = .blue
    }
}

