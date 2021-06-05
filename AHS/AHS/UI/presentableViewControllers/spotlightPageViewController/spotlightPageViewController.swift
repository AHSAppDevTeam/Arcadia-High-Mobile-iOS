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
    
    internal let mainScrollView = UIScrollView();
    internal let refreshControl = UIRefreshControl();
    
    internal let contentHorizontalPadding : CGFloat = AppUtility.getCurrentScreenSize().width / 20;
    internal let contentVerticalPadding : CGFloat = 8;
    internal var nextContentY : CGFloat = 0;
    
    internal let pageAccentColor : UIColor = .white;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        setupPanGesture();
        
        //
        
        mainScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height);
        
        mainScrollView.alwaysBounceVertical = true;
        mainScrollView.showsVerticalScrollIndicator = true;
        mainScrollView.contentInsetAdjustmentBehavior = .never;
        
        self.view.addSubview(mainScrollView);
        
        //
        
        refreshControl.tintColor = InverseBackgroundColor;
        refreshControl.addTarget(self, action: #selector(self.handleRefresh), for: .valueChanged);
        mainScrollView.addSubview(refreshControl);
        
        //
        
        let topMainScrollViewGradientColor = UIColor(hex: "5fa4a9");
        let bottomMainScrollViewGradientColor = pageAccentColor;
        let mainScrollViewGradientLayer = CAGradientLayer();
        
        mainScrollViewGradientLayer.colors = [topMainScrollViewGradientColor.cgColor, bottomMainScrollViewGradientColor.cgColor];
        mainScrollViewGradientLayer.locations = [0, 1];
        mainScrollViewGradientLayer.frame = mainScrollView.bounds;
        mainScrollView.layer.insertSublayer(mainScrollViewGradientLayer, at: 0);
        self.view.layer.insertSublayer(mainScrollViewGradientLayer, at: 0);
        
        //
        
        renderContent();
    }
    
    internal func renderContent(){
        
        for subview in mainScrollView.subviews{
            subview.removeFromSuperview();
        }
        
        //
        
        nextContentY = AppUtility.safeAreaInset.top;
        
        //
        
        let dismissButtonFrameWidth = mainScrollView.frame.width - 2*contentHorizontalPadding;
        let dismissButtonFrame = CGRect(x: contentHorizontalPadding, y: nextContentY, width: dismissButtonFrameWidth, height: dismissButtonFrameWidth * 0.08);
        let dismissButton = UIButton(frame: dismissButtonFrame);
        
        let dismissButtonContentHorizontalPadding : CGFloat = 5;
        
        //
        
        let dismissImageViewSize = dismissButton.frame.height;
        let dismissImageViewFrame = CGRect(x: 0, y: 0, width: dismissImageViewSize, height: dismissImageViewSize);
        let dismissImageView = UIImageView(frame: dismissImageViewFrame);
        
        dismissImageView.contentMode = .scaleAspectFit;
        dismissImageView.image = UIImage(systemName: "chevron.left");
        dismissImageView.backgroundColor = .clear;
        dismissImageView.tintColor = InverseBackgroundColor;
        
        dismissButton.addSubview(dismissImageView);
        
        //
        
        let categoryLabelFrame = CGRect(x: dismissImageView.frame.width + dismissButtonContentHorizontalPadding, y: 0, width: dismissButton.frame.width - dismissImageView.frame.width - 2*dismissButtonContentHorizontalPadding, height: dismissButton.frame.height);
        let categoryLabel = UILabel(frame: categoryLabelFrame);
        
        categoryLabel.textAlignment = .left;
        categoryLabel.textColor = pageAccentColor;
        categoryLabel.isUserInteractionEnabled = false;
        
        dismissButton.addSubview(categoryLabel);
        
        //
        
        dismissButton.addTarget(self, action: #selector(self.dismissHandler), for: .touchUpInside);
        
        nextContentY += dismissButton.frame.height + contentVerticalPadding;
        mainScrollView.addSubview(dismissButton);
        
        //
        
        let locationViewFrameWidth = mainScrollView.frame.width - 2*contentHorizontalPadding;
        let locationViewFrame = CGRect(x: contentHorizontalPadding, y: nextContentY, width: locationViewFrameWidth, height: locationViewFrameWidth * 0.1);
        let locationView = UIView(frame: locationViewFrame);
        
        let locationViewContentHorizontalPadding : CGFloat = 5;
        
        //
        
        let locationImageViewSize = locationView.frame.height;
        let locationImageViewFrame = CGRect(x: 0, y: 0, width: locationImageViewSize, height: locationImageViewSize);
        let locationImageView = UIImageView(frame: locationImageViewFrame);
        
        locationImageView.contentMode = .scaleAspectFit;
        locationImageView.tintColor = pageAccentColor;
        locationImageView.image = UIImage(named: "location-on-icon");
        
        locationView.addSubview(locationImageView);
        
        //
        
        let locationLabelFrame = CGRect(x: locationImageView.frame.width + locationViewContentHorizontalPadding, y: 0, width: locationView.frame.width - 2*locationViewContentHorizontalPadding - locationImageView.frame.width, height: locationView.frame.height);
        let locationLabel = UILabel(frame: locationLabelFrame);
        
        locationLabel.font = UIFont(name: SFProDisplay_Bold, size: locationLabel.frame.height * 0.9);
        locationLabel.text = "Arcadia, CA";
        locationLabel.textAlignment = .left;
        locationLabel.textColor = pageAccentColor;
        
        locationView.addSubview(locationLabel);
        
        //
        
        nextContentY += locationView.frame.height + contentVerticalPadding;
        mainScrollView.addSubview(locationView);
        
        //
        
        let dateLabelWidth = mainScrollView.frame.width - 2*contentHorizontalPadding;
        let dateLabelFrame = CGRect(x: contentHorizontalPadding, y: nextContentY, width: dateLabelWidth, height: dateLabelWidth * 0.06);
        let dateLabel = UILabel(frame: dateLabelFrame);
        
        dateLabel.font = UIFont(name: SFProDisplay_Regular, size: dateLabel.frame.height * 0.9);
        dateLabel.text = timeManager.epochToFormattedDateString(timeManager.getCurrentEpoch());
        dateLabel.textAlignment = .left;
        dateLabel.textColor = pageAccentColor;
        
        nextContentY += dateLabel.frame.height + contentVerticalPadding;
        mainScrollView.addSubview(dateLabel);
        
        //
        
        refreshControl.beginRefreshing();
        dataManager.getCategoryData(categoryID, completion: { (categorydata) in
            self.refreshControl.endRefreshing();
            
            let categoryLabelFontSize = categoryLabel.frame.height * 0.7;
            let categoryLabelAttributedText = NSMutableAttributedString(string: categorydata.title, attributes: [NSAttributedString.Key.font : UIFont(name: SFProDisplay_Bold, size: categoryLabelFontSize)!]);
            categoryLabelAttributedText.append(NSAttributedString(string: " News", attributes: [NSAttributedString.Key.font : UIFont(name: SFProDisplay_Regular, size: categoryLabelFontSize)!]));
            
            categoryLabel.attributedText = categoryLabelAttributedText;
            
        });
        
    }
    
}
