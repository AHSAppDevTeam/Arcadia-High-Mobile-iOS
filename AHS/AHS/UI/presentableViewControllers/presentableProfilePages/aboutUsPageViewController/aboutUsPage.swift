//
//  aboutUsPageViewController.swift
//  AHS
//
//  Created by Richard Wei on 8/29/21.
//

import Foundation
import UIKit

class aboutUsPageViewController : presentableViewController{
    
    internal let mainScrollView :  UIButtonScrollView = UIButtonScrollView();
    internal let refreshControl : UIRefreshControl = UIRefreshControl();
    
    //
    
    internal let backgroundGradient = CAGradientLayer();
    
    internal var backgroundGradientSet = [[CGColor]]();
    internal var backgroundCurrentGradient: Int = 0;
    
    //
    
    internal let dismissButton : UIButton = UIButton();
    
    internal let dismissImageView : UIImageView = UIImageView();
    
    //
    
    override func viewDidLoad(){
        super.viewDidLoad();
        
        self.setupPanGesture();
        
        self.view.backgroundColor = BackgroundColor;
        
        //
        
        mainScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height);
        mainScrollView.alwaysBounceVertical = true;
        mainScrollView.addSubview(refreshControl);
        
        self.view.addSubview(mainScrollView);
        
        //
        
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged);
        refreshControl.beginRefreshing();
        
        //
        
        let dismissButtonWidth = mainScrollView.frame.width;
        let dismissButtonHeight = dismissButtonWidth * 0.09;
        
        dismissButton.frame = CGRect(x: 0, y: 0, width: dismissButtonWidth, height: dismissButtonHeight);
        
        //
        
        let dismissImageViewHorizontalPadding : CGFloat = 10;
        let dismissImageViewVerticalPadding : CGFloat = 5;
        let dismissImageViewSize = dismissButton.frame.height - 2*dismissImageViewVerticalPadding;
        
        dismissImageView.frame = CGRect(x: dismissImageViewHorizontalPadding, y: dismissImageViewVerticalPadding, width: dismissImageViewSize, height: dismissImageViewSize);
        
        dismissImageView.image = UIImage(systemName: "chevron.left");
        dismissImageView.contentMode = .scaleAspectFit;
        dismissImageView.tintColor = InverseBackgroundColor;
        
        dismissButton.addSubview(dismissImageView);
        
        //
        
        dismissButton.addTarget(self, action: #selector(self.handleBackButton), for: .touchUpInside);
        
        mainScrollView.addSubview(dismissButton);
        
        //
        
        loadCreditsList();
        
        //
        
        setupBackgroundGradient();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        animateBackgroundGradient();
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        backgroundGradient.frame = self.view.bounds;
    }
    
    //
    
    internal func loadCreditsList(){
        
        for subview in mainScrollView.subviews{
            if (subview.tag == 1){
                subview.removeFromSuperview();
            }
        }
        
        dataManager.getCreditsList(completion: { (creditList) in
            self.refreshControl.endRefreshing();
            self.renderCreditsList(creditList);
            print(creditList);
        });
    }
    
    internal func renderCreditsList(_ creditList: [creditData]){
        
    }
    
}
