//
//  notificationPageViewController.swift
//  AHS
//
//  Created by Richard Wei on 7/9/21.
//

import Foundation
import UIKit

class notificationPageViewController : presentableViewController{
    
    //
    
    internal let topBarView : UIView = UIView();
    
    internal let refreshControl : UIRefreshControl = UIRefreshControl();
    internal let mainScrollView : UIScrollView = UIScrollView();
    
    internal let topContentView : UIView = UIView();
    
    internal var nextY : CGFloat = 0;
    
    internal let horizontalPadding : CGFloat = 10;
    internal let verticalPadding : CGFloat = 5;
    
    //
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        setupPanGesture();
        
        self.view.backgroundColor = BackgroundColor;
        
        //
        
        renderTopBar();
        
        //
        
        mainScrollView.frame = CGRect(x: 0, y: topBarView.frame.maxY, width: self.view.frame.width, height: self.view.frame.height - topBarView.frame.maxY);
        mainScrollView.alwaysBounceVertical = true;
        self.view.addSubview(mainScrollView);
        
        //
        
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged);
        mainScrollView.addSubview(refreshControl);
        
        //
        
        renderTopContent();
        
        loadNotificationList();
    }
    
    internal func renderTopBar(){
        
        let topBarViewWidth = self.view.frame.width - 2*horizontalPadding;
        topBarView.frame = CGRect(x: horizontalPadding, y: AppUtility.safeAreaInset.top, width: topBarViewWidth, height: topBarViewWidth * 0.11);
        
        //
        
        let topBarButtonSize = topBarView.frame.height - 2*verticalPadding;
        let topBarButtonInset = topBarButtonSize / 8;
        let topBarButtonEdgeInsets = UIEdgeInsets(top: topBarButtonInset, left: topBarButtonInset, bottom: topBarButtonInset, right: topBarButtonInset);
        //
        
        let topBarBackButtonFrame = CGRect(x: 0, y: verticalPadding, width: topBarButtonSize, height: topBarButtonSize);
        let topBarBackButton = UIButton(frame: topBarBackButtonFrame);
        
        topBarBackButton.setImage(UIImage(systemName: "chevron.left"), for: .normal);
        
        topBarBackButton.imageView?.contentMode = .scaleAspectFit;
        topBarBackButton.contentVerticalAlignment = .fill;
        topBarBackButton.contentHorizontalAlignment = .fill;
        topBarBackButton.imageEdgeInsets = topBarButtonEdgeInsets;
        topBarBackButton.tintColor = BackgroundGrayColor;
        
        topBarBackButton.addTarget(self, action: #selector(self.exit), for: .touchUpInside);
        
        topBarView.addSubview(topBarBackButton);
        
        //

        let topBarTitleButtonFrame = CGRect(x: topBarBackButton.frame.width, y: verticalPadding, width: topBarView.frame.width - topBarBackButton.frame.width, height: topBarView.frame.height - 2*verticalPadding);
        let topBarTitleButton = UIButton(frame: topBarTitleButtonFrame);
        
        topBarTitleButton.setTitle("Notifications", for: .normal);
        topBarTitleButton.setTitleColor(UIColor.init(hex: "#c74534"), for: .normal);
        topBarTitleButton.contentHorizontalAlignment = .left;
        topBarTitleButton.titleLabel?.textAlignment = .left;
        topBarTitleButton.titleLabel?.font = UIFont(name: SFProDisplay_Bold, size: topBarTitleButton.frame.height * 0.8);
        
        topBarTitleButton.addTarget(self, action: #selector(self.exit), for: .touchUpInside);
        
        topBarView.addSubview(topBarTitleButton);
        
        //

        self.view.addSubview(topBarView);
        
    }
    
    internal func renderTopContent(){
        
        let topContentViewWidth = mainScrollView.frame.width;
        topContentView.frame = CGRect(x: 0, y: 0, width: topContentViewWidth, height: topContentViewWidth * 0.05);
        
        mainScrollView.addSubview(topContentView);
        
        //
        
        let sortButtonHeight = topContentView.frame.height;
    
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
        
        topContentView.addSubview(sortButton);
        
        //
        
        let clearAllButtonLabelHeight = topContentView.frame.height * 0.8;
        let clearAllButtonLabelText = "Clear All";
        let clearAllButtonLabelFont = UIFont(name: SFProDisplay_Medium, size: clearAllButtonLabelHeight)!;
        let clearAllButtonLabelWidth = clearAllButtonLabelText.width(withConstrainedHeight: clearAllButtonLabelHeight, font: clearAllButtonLabelFont) + 2*horizontalPadding;
        
        let clearAllButtonFrame = CGRect(x: topContentView.frame.width - (clearAllButtonLabelWidth + horizontalPadding), y: 0, width: clearAllButtonLabelWidth, height: topContentView.frame.height);
        let clearAllButton = UIButton(frame: clearAllButtonFrame);
        
        clearAllButton.layer.cornerRadius = clearAllButton.frame.height / 4;
        clearAllButton.clipsToBounds = true;
        
        let clearAllButtonGradientLayer = CAGradientLayer();
        clearAllButtonGradientLayer.frame = clearAllButton.bounds;
        clearAllButtonGradientLayer.colors = [UIColor.init(hex: "#c84c2f").cgColor, UIColor.init(hex: "#d06f35").cgColor];
        clearAllButtonGradientLayer.locations = [0.0, 1.0];
        clearAllButton.layer.insertSublayer(clearAllButtonGradientLayer, at: 0);
        
        clearAllButton.setTitle(clearAllButtonLabelText, for: .normal);
        clearAllButton.setTitleColor(.white, for: .normal);
        clearAllButton.titleLabel?.font = clearAllButtonLabelFont;
        clearAllButton.titleLabel?.textAlignment = .center;
        
        clearAllButton.addTarget(self, action: #selector(self.clearAll), for: .touchUpInside);
        topContentView.addSubview(clearAllButton);
        
    }
    
    internal func loadNotificationList(){
        renderContent([]);
    }
    
    internal func renderContent(_ notificationList: [notificationData]){
        
        for subview in mainScrollView.subviews{
            if subview.tag == 1{
                subview.removeFromSuperview();
            }
        }
        
        nextY = topContentView.frame.maxY + verticalPadding;
        
    }
    
}
