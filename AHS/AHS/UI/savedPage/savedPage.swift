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
    
    internal let horizontalPadding : CGFloat = 20;
    internal let verticalPadding : CGFloat = 5;
    
    internal let topBarView : UIView = UIView();
    
    internal let mainScrollView : UIScrollView = UIScrollView();
    
    //
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        if (!self.hasBeenSetup){
            
            //
            
            let topBarViewWidth = self.view.frame.width;
            let topBarViewHeight = topBarViewWidth * 0.05;
            topBarView.frame = CGRect(x: 0, y: 0, width: topBarViewWidth, height: topBarViewHeight);
            
            renderTopBar();
            
            self.view.addSubview(topBarView);
            
            //
            
            mainScrollView.frame = CGRect(x: 0, y: topBarView.frame.height, width: self.view.frame.width, height: self.view.frame.height);
            mainScrollView.alwaysBounceVertical = true;
            self.view.addSubview(mainScrollView);
            
            //
            
            self.hasBeenSetup = true;
        }
        
    }
    
    internal func renderTopBar(){
        
        // -- calculate size of sortButton content first before creating sortButtonFrame
    
        let sortButtonHeight = topBarView.frame.height;
    
        let sortButtonLabelText = "Sort By";
        let sortButtonLabelFont = UIFont(name: SFProDisplay_Medium, size: sortButtonHeight * 0.8)!;
        let sortButtonLabelWidth = sortButtonLabelText.width(withConstrainedHeight: sortButtonHeight, font: sortButtonLabelFont);
        
        let sortButtonImageViewPadding = sortButtonHeight * 0.15;
        let sortButtonImageViewSize = sortButtonHeight - 2*sortButtonImageViewPadding;
        
        let sortButtonWidth = sortButtonLabelWidth + sortButtonImageViewSize + sortButtonImageViewPadding;
        
        let sortButtonFrame = CGRect(x: horizontalPadding, y: 0, width: sortButtonWidth, height: sortButtonHeight);
        let sortButton = UIButton(frame: sortButtonFrame);
    
        ///
        
        let sortButtonImageViewFrame = CGRect(x: sortButtonLabelWidth + sortButtonImageViewPadding, y: sortButtonImageViewPadding, width: sortButtonImageViewSize, height: sortButtonImageViewSize);
        let sortButtonImageView = UIImageView(frame: sortButtonImageViewFrame);
        
        sortButtonImageView.image = UIImage(systemName: "chevron.down");
        sortButtonImageView.contentMode = .scaleAspectFit;
        sortButtonImageView.tintColor = BackgroundGrayColor;
        
        sortButton.addSubview(sortButtonImageView);
        
        ///
        
        let sortButtonLabelFrame = CGRect(x: 0, y: 0, width: sortButtonLabelWidth, height: sortButtonHeight);
        let sortButtonLabel = UILabel(frame: sortButtonLabelFrame);
        
        sortButtonLabel.text = sortButtonLabelText;
        sortButtonLabel.font = sortButtonLabelFont;
        sortButtonLabel.textAlignment = .left;
        sortButtonLabel.textColor = BackgroundGrayColor;
        
        sortButton.addSubview(sortButtonLabel);
        
        ///
        
        sortButton.addTarget(self, action: #selector(self.sortBy), for: .touchUpInside);
        topBarView.addSubview(sortButton);
        
        //
        
        let clearAllButtonLabelHeight = topBarView.frame.height * 0.8;
        let clearAllButtonLabelText = "Clear All";
        let clearAllButtonLabelFont = UIFont(name: SFProDisplay_Medium, size: clearAllButtonLabelHeight)!;
        let clearAllButtonLabelWidth = clearAllButtonLabelText.width(withConstrainedHeight: clearAllButtonLabelHeight, font: clearAllButtonLabelFont) + 1.5*horizontalPadding;
        
        let clearAllButtonFrame = CGRect(x: topBarView.frame.width - (clearAllButtonLabelWidth + horizontalPadding), y: 0, width: clearAllButtonLabelWidth, height: topBarView.frame.height);
        let clearAllButton = UIButton(frame: clearAllButtonFrame);
        
        clearAllButton.layer.cornerRadius = clearAllButton.frame.height / 4;
        clearAllButton.clipsToBounds = true;
        
        let clearAllButtonGradientLayer = CAGradientLayer();
        clearAllButtonGradientLayer.frame = clearAllButton.bounds;
        clearAllButtonGradientLayer.colors = [UIColor.init(hex: "#c84c2f").cgColor, UIColor.init(hex: "#d06f35").cgColor];
        clearAllButtonGradientLayer.locations = [0.0, 1.0];
        clearAllButton.layer.insertSublayer(clearAllButtonGradientLayer, at: 0);
        
        clearAllButton.setTitle(clearAllButtonLabelText, for: .normal);
        clearAllButton.setTitleColor(InverseBackgroundColor, for: .normal);
        clearAllButton.titleLabel?.font = clearAllButtonLabelFont;
        clearAllButton.titleLabel?.textAlignment = .center;
        
        clearAllButton.addTarget(self, action: #selector(self.clearAll), for: .touchUpInside);
        topBarView.addSubview(clearAllButton);
        
    }
    
}
