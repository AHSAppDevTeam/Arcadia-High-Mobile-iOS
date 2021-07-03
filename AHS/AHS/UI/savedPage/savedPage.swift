//
//  savedPage.swift
//  AHS
//
//  Created by Richard Wei on 3/14/21.
//

import Foundation
import UIKit

class savedPageViewController : mainPageViewController{
    
    init(){
        super.init(nibName: nil, bundle: nil);
        self.pageName = "Your";
        self.secondaryPageName = "Saved";
        self.viewControllerIconName = "bookmark.fill";
    }
    
    required init?(coder: NSCoder) { // required uiviewcontroller init
        super.init(coder: coder);
    }
    
    //
    
    internal let horizontalPadding : CGFloat = 10;
    internal let verticalPadding : CGFloat = 5;
    
    internal let topBarView : UIView = UIView();
    
    internal let mainScrollView : UIScrollView = UIScrollView();
    internal let refreshControl : UIRefreshControl = UIRefreshControl();
    
    //
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        if (!self.hasBeenSetup){
            
            //
            
            let topBarViewWidth = self.view.frame.width;
            let topBarViewHeight = topBarViewWidth * 0.06;
            topBarView.frame = CGRect(x: 0, y: 0, width: topBarViewWidth, height: topBarViewHeight);
            
            renderTopBar();
            
            self.view.addSubview(topBarView);
            
            //
            
            mainScrollView.frame = CGRect(x: 0, y: topBarView.frame.height, width: self.view.frame.width, height: self.view.frame.height);
            mainScrollView.alwaysBounceVertical = true;
            self.view.addSubview(mainScrollView);
            
            //
            
            mainScrollView.addSubview(refreshControl);
            refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged);
            
            //
            
            self.hasBeenSetup = true;
        }
        
    }
    
    internal func renderTopBar(){
        
        // -- calculate size of sortButton content first before creating sortButtonFrame
        let sortButtonHeight = topBarView.frame.height;
        
        ///
        
        
        
        /*
        
        let sortButtonImageViewSize = sortButtonHeight;
        let sortButtonImageViewFrame = CGRect(x: sortButton.frame.width - sortButtonImageViewSize, y: 0, width: sortButtonImageViewSize, height: sortButtonImageViewSize);
        let sortButtonImageView = UIImageView(frame: sortButtonImageViewFrame);
        
        sortButtonImageView.image = UIImage(systemName: "chevron.down");
        sortButtonImageView.contentMode = .scaleAspectFit;
        sortButtonImageView.tintColor = InverseBackgroundColor;
        
        */
        
        
        let sortButtonFrame = CGRect(x: horizontalPadding, y: 0, width: topBarView.frame.width * 0.2, height: topBarView.frame.height);
        let sortButton = UIButton(frame: sortButtonFrame);
        
        sortButton.addSubview(sortButtonImageView);
        
        topBarView.addSubview(sortButton);
        
        
    }
    
}
