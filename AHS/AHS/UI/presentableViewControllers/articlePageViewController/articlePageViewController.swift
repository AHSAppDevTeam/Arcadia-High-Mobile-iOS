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
    internal var nextContentY : CGFloat = 0;
    internal var userInterfaceStyle : UIUserInterfaceStyle = .unspecified;
    
    internal let scrollView : UIScrollView = UIScrollView();
    internal let refreshControl : UIRefreshControl = UIRefreshControl();
    
    internal let topBarCategoryLabel : UILabel = UILabel();
    
    override func viewDidLoad() {
        super.viewDidLoad();
    
        renderUI();
        loadArticleData();
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        
        AppUtility.currentUserInterfaceStyle = .unspecified;
        setNeedsStatusBarAppearanceUpdate();
    }
    
    internal func renderUI(){
        
        self.view.backgroundColor = BackgroundColor;
        setupPanGesture();
        
        //
        
        let topBarViewFrame = CGRect(x: 0, y: AppUtility.safeAreaInset.top, width: self.view.frame.width, height: self.view.frame.width * 0.085);
        let topBarView = UIView(frame: topBarViewFrame);
        
        let topBarHorizontalPadding : CGFloat = 5;
        
        let topBarButtonSize = topBarView.frame.height;
        let topBarButtonInset = topBarButtonSize / 8;
        let topBarButtonEdgeInsets = UIEdgeInsets(top: topBarButtonInset, left: topBarButtonInset, bottom: topBarButtonInset, right: topBarButtonInset);
        
        
        //
    
        let topBarBackButtonFrame = CGRect(x: 0, y: 0, width: topBarButtonSize, height: topBarButtonSize);
        let topBarBackButton = UIButton(frame: topBarBackButtonFrame);
        
        topBarBackButton.setImage(UIImage(systemName: "chevron.left"), for: .normal);
        topBarBackButton.imageView?.contentMode = .scaleAspectFit;
        topBarBackButton.contentVerticalAlignment = .fill;
        topBarBackButton.contentHorizontalAlignment = .fill;
        topBarBackButton.imageEdgeInsets = topBarButtonEdgeInsets;
        topBarBackButton.tintColor = BackgroundGrayColor;
        
        topBarView.addSubview(topBarBackButton);
        
        //
        
        let topBarBookmarkButtonFrame = CGRect(x: topBarView.frame.width - topBarButtonSize, y: 0, width: topBarButtonSize, height: topBarButtonSize);
        let topBarBookmarkButton = UIButton(frame: topBarBookmarkButtonFrame);
        
        topBarBookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal);
        topBarBookmarkButton.imageView?.contentMode = .scaleAspectFit;
        topBarBookmarkButton.contentVerticalAlignment = .fill;
        topBarBookmarkButton.contentHorizontalAlignment = .fill;
        topBarBookmarkButton.imageEdgeInsets = topBarButtonEdgeInsets;
        topBarBookmarkButton.tintColor = BackgroundGrayColor;
        
        topBarView.addSubview(topBarBookmarkButton);
        
        //
        
        let topBarColorButtonFrame = CGRect(x: topBarView.frame.width - 2*topBarButtonSize - topBarHorizontalPadding, y: 0, width: topBarButtonSize, height: topBarButtonSize);
        let topBarColorButton = UIButton(frame: topBarColorButtonFrame);
        
        topBarColorButton.setImage(UIImage(systemName: "moon.fill"), for: .normal);
        topBarColorButton.imageView?.contentMode = .scaleAspectFit;
        topBarColorButton.contentVerticalAlignment = .fill;
        topBarColorButton.contentHorizontalAlignment = .fill;
        topBarColorButton.imageEdgeInsets = topBarButtonEdgeInsets;
        topBarColorButton.tintColor = BackgroundGrayColor;
        
        topBarColorButton.addTarget(self, action: #selector(self.toggleUserInterface), for: .touchUpInside);
        
        topBarView.addSubview(topBarColorButton);
        
        // textformat
        
        let topBarFontButtonFrame = CGRect(x: topBarView.frame.width - 3*topBarButtonSize - 2*topBarHorizontalPadding - topBarButtonInset, y: 0, width: topBarButtonSize, height: topBarButtonSize);
        let topBarFontButton = UIButton(frame: topBarFontButtonFrame);
        
        topBarFontButton.setImage(UIImage(systemName: "textformat"), for: .normal);
        topBarFontButton.imageView?.contentMode = .scaleAspectFit;
        topBarFontButton.contentVerticalAlignment = .fill;
        topBarFontButton.contentHorizontalAlignment = .fill;
        //topBarFontButton.imageEdgeInsets = topBarButtonEdgeInsets;
        topBarFontButton.tintColor = BackgroundGrayColor;
        
        topBarView.addSubview(topBarFontButton);
        
        //
        
        let topBarCategoryLabelFrame = CGRect(x: topBarBackButton.frame.width + topBarHorizontalPadding, y: 0, width: topBarView.frame.width - (topBarBackButton.frame.width + 2*topBarHorizontalPadding + (topBarView.frame.width - topBarFontButton.frame.minX)), height: topBarView.frame.height);
        topBarCategoryLabel.frame = topBarCategoryLabelFrame;
        
        topBarCategoryLabel.isUserInteractionEnabled = false;
        topBarCategoryLabel.textAlignment = .left;
        topBarCategoryLabel.textColor = UIColor.init(hex: "#cc5454");
        
        topBarView.addSubview(topBarCategoryLabel);
        
        //
        
        self.view.addSubview(topBarView);
        
        //
        
        scrollView.frame = CGRect(x: 0, y: topBarView.frame.maxY, width: self.view.frame.width, height: self.view.frame.height - topBarView.frame.maxY);
        self.view.addSubview(scrollView);
        
        //scrollView.backgroundColor = InverseBackgroundColor;
        scrollView.alwaysBounceVertical = true;
        scrollView.showsVerticalScrollIndicator = true;
        
        refreshControl.addTarget(self, action: #selector(self.handleRefresh), for: .valueChanged)
        scrollView.addSubview(refreshControl);
        
    }
    
    internal func loadArticleData(){
        refreshControl.beginRefreshing();
        dataManager.getFullArticleData(articleID, completion: { (data) in
            self.refreshControl.endRefreshing();
            self.renderArticle(data);
        });
    }
    
    internal func renderArticle(_ articleData: fullArticleData){
        
        dataManager.getCategoryData(articleData.baseData.categoryID, completion: { (categorydata) in
            
            let topBarCategoryLabelFontSize = self.topBarCategoryLabel.frame.height * 0.7;
            let topBarCategoryLabelAttributedText = NSMutableAttributedString(string: categorydata.title, attributes: [NSAttributedString.Key.font : UIFont(name: SFProDisplay_Bold, size: topBarCategoryLabelFontSize)!]);
            topBarCategoryLabelAttributedText.append(NSAttributedString(string: " Section", attributes: [NSAttributedString.Key.font : UIFont(name: SFProDisplay_Regular, size: topBarCategoryLabelFontSize)!]));
            self.topBarCategoryLabel.attributedText = topBarCategoryLabelAttributedText;
            
        });
        
    }
    
    
    
}
