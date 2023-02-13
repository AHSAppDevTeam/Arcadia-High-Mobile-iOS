//
//  spotlightPageViewController.swift
//  AHS
//
//  Created by Richard Wei on 6/4/21.
//

import Foundation
import UIKit


class spotlightPageViewController : presentableViewController, UIScrollViewDelegate {
    
    public var categoryID : String = "";
    
    internal let mainScrollView = UIButtonScrollView();
    internal let refreshControl = UIRefreshControl();
    
    internal let contentHorizontalPadding : CGFloat = AppUtility.getCurrentScreenSize().width / 20;
    internal let headerVerticalPadding : CGFloat = 8;
    internal let contentVerticalPadding : CGFloat = 14;
    internal var nextContentY : CGFloat = 0;
    
    internal let topBarCategoryButtonLabel = UIButton();
    internal let topBarView : UIView = UIView();
    
    internal let pageAccentColor : UIColor = .white;
    internal let secondaryPageAccentColor : UIColor = UIColor.init(hex: "5fa4a9");
    internal let inversePageAccentColor : UIColor = .black;
    
    internal var hasRenderedLargeArticle : Bool = false;
    internal var subArticleRenderRowCount : Int = 2;
    internal var subArticleSecondaryRenderY : CGFloat = -1;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        //
        
        let topBarViewFrame = CGRect(x: 0, y: AppUtility.safeAreaInset.top, width: self.view.frame.width, height: self.view.frame.width * 0.11);
        let topBarView = UIView(frame: topBarViewFrame);
        topBarView.frame = topBarViewFrame;
                
        let topBarVerticalPadding : CGFloat = topBarView.frame.height / 8;
        
        let topBarButtonSize = topBarView.frame.height - 2*topBarVerticalPadding;
        let topBarButtonInset = topBarButtonSize / 8;
        let topBarButtonEdgeInsets = UIEdgeInsets(top: topBarButtonInset, left: topBarButtonInset, bottom: topBarButtonInset, right: topBarButtonInset);
        
        
        //
    
        let topBarBackButtonFrame = CGRect(x: 0, y: topBarVerticalPadding, width: topBarButtonSize, height: topBarButtonSize);
        let topBarBackButton = UIButton(frame: topBarBackButtonFrame);
        
        topBarBackButton.setImage(UIImage(systemName: "chevron.left"), for: .normal);
        topBarBackButton.imageView?.contentMode = .scaleAspectFit;
        topBarBackButton.contentVerticalAlignment = .fill;
        topBarBackButton.contentHorizontalAlignment = .fill;
        topBarBackButton.imageEdgeInsets = topBarButtonEdgeInsets;
        topBarBackButton.tintColor = BackgroundGrayColor;
        
        topBarBackButton.addTarget(self, action: #selector(self.handleBackButton), for: .touchUpInside);
        
        topBarView.addSubview(topBarBackButton);
                
        //topBarCategoryButtonLabel.titleLabel?.textAlignment = .left;
        topBarCategoryButtonLabel.contentHorizontalAlignment = .left;
        topBarCategoryButtonLabel.setTitleColor(UIColor.init(hex: "cc5454"), for: .normal);
        topBarCategoryButtonLabel.setAttributedTitle(self.generateTopBarTitleText("Opportunities"), for: .normal);
        
        topBarCategoryButtonLabel.addTarget(self, action: #selector(self.handleBackButton), for: .touchUpInside);
        
        topBarView.addSubview(topBarCategoryButtonLabel);
        
        //
        
        mainScrollView.frame = CGRect(x: 0, y: topBarView.frame.maxY, width: self.view.frame.width, height: self.view.frame.height - topBarView.frame.maxY);
        self.view.addSubview(mainScrollView);
        
        //scrollView.backgroundColor = InverseBackgroundColor;
        mainScrollView.alwaysBounceVertical = true;
        mainScrollView.showsVerticalScrollIndicator = true;
        
        mainScrollView.delegate = self;
        
        refreshControl.addTarget(self, action: #selector(self.handleRefresh), for: .valueChanged)
        mainScrollView.addSubview(refreshControl);
        
        //
        
        self.view.addSubview(topBarView);
        //
        
        setupPanGesture();
        
        mainScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height);
        
        mainScrollView.alwaysBounceVertical = true;
        mainScrollView.showsVerticalScrollIndicator = true;
        
        self.view.addSubview(mainScrollView);
        
        //
        
        refreshControl.tintColor = pageAccentColor;
        refreshControl.addTarget(self, action: #selector(self.handleRefresh), for: .valueChanged);
        mainScrollView.addSubview(refreshControl);
        
        //
        
        let topMainScrollViewGradientColor = pageAccentColor;
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
    
        
        //
        for subview in mainScrollView.subviews{
            if (subview.tag == 1){
                subview.removeFromSuperview();
            }
        }
        
        //
        nextContentY = 0;
        hasRenderedLargeArticle = false;
        subArticleRenderRowCount = 2;
        subArticleSecondaryRenderY = -1;
        
        //
        
//        let categoryLabelFrame = CGRect(x: dismissImageView.frame.width + dismissButtonContentHorizontalPadding, y: 0, width: dismissButton.frame.width - dismissImageView.frame.width - 2*dismissButtonContentHorizontalPadding, height: dismissButton.frame.height);
//        let categoryLabel = UILabel(frame: categoryLabelFrame);
//
//        categoryLabel.textAlignment = .left;
//        categoryLabel.textColor = secondaryPageAccentColor;
//        categoryLabel.isUserInteractionEnabled = false;
//
//        dismissButton.addSubview(categoryLabel);
//
//        //
//
//        dismissButton.addTarget(self, action: #selector(self.dismissHandler), for: .touchUpInside);
//
//        dismissButton.tag = 1;
//        nextContentY += dismissButton.frame.height + headerVerticalPadding;
//        mainScrollView.addSubview(dismissButton);
        
        //
        
        
        let dateLabelWidth = mainScrollView.frame.width - 2*contentHorizontalPadding;
        let dateLabelFrame = CGRect(x: contentHorizontalPadding, y: nextContentY, width: dateLabelWidth, height: dateLabelWidth * 0.06);
        let dateLabel = UILabel(frame: dateLabelFrame);
        
        dateLabel.font = UIFont(name: SFProDisplay_Regular, size: dateLabel.frame.height * 0.9);
        dateLabel.text = timeManager.epochToFormattedDateString(timeManager.getCurrentEpoch());
        dateLabel.textAlignment = .left;
        dateLabel.textColor = pageAccentColor;
        
        dateLabel.tag = 1;
        nextContentY += dateLabel.frame.height + headerVerticalPadding;
        mainScrollView.addSubview(dateLabel);
        
        //
        
        refreshControl.beginRefreshing();
        dataManager.getCategoryData(categoryID, completion: { (categorydata) in
            self.refreshControl.endRefreshing();
            
//            let categoryLabelFontSize = categoryLabel.frame.height * 0.7;
//            let categoryLabelAttributedText = NSMutableAttributedString(string: "Opportunities", attributes: [NSAttributedString.Key.font : UIFont(name: SFProDisplay_Bold, size: categoryLabelFontSize)!]);
//            categoryLabel.attributedText = categoryLabelAttributedText;
            
            //
            
            if (categorydata.layout != .row){
                self.hasRenderedLargeArticle = true;
                self.subArticleRenderRowCount = 0;
            }
            
            //
            
            for articleID in categorydata.articleIDs{
                
                if (!self.hasRenderedLargeArticle){
                    
                    let articleViewWidth = self.mainScrollView.frame.width - 2*self.contentHorizontalPadding;
                    let articleViewFrame = CGRect(x: self.contentHorizontalPadding, y: self.nextContentY, width: articleViewWidth, height: articleViewWidth * 0.8);
                    let articleView = ArticleButton(frame: articleViewFrame);
                    
                    self.renderArticle(articleView, articleID, true);
                    
                    self.nextContentY += articleView.frame.height + self.contentVerticalPadding;
                    self.mainScrollView.addSubview(articleView);
                    
                    self.hasRenderedLargeArticle = true;
                }
                else if (self.subArticleRenderRowCount > 0){
                    
                    let subArticleSecondaryRenderFlag = self.subArticleSecondaryRenderY != -1; // if true, render secondary article
                    
                    let articleViewWidth = (self.mainScrollView.frame.width - 3*self.contentHorizontalPadding) / 2;
                    let articleViewFrame = CGRect(x: (subArticleSecondaryRenderFlag ? self.contentHorizontalPadding + articleViewWidth : 0 ) + self.contentHorizontalPadding, y: subArticleSecondaryRenderFlag ? self.subArticleSecondaryRenderY : self.nextContentY, width: articleViewWidth, height: articleViewWidth * 1.4);
                    let articleView = ArticleButton(frame: articleViewFrame);
                    
                    self.renderArticle(articleView, articleID, true);
                    
                    self.nextContentY += subArticleSecondaryRenderFlag ? 0 : articleView.frame.height + self.contentVerticalPadding;
                    self.mainScrollView.addSubview(articleView);
                    
                    if (!subArticleSecondaryRenderFlag){
                        self.subArticleSecondaryRenderY = articleView.frame.minY;
                    }
                    else{
                        self.subArticleRenderRowCount -= 1;
                        self.subArticleSecondaryRenderY = -1;
                    }
                    
                }
                else{
                    
                    let articleViewWidth = self.mainScrollView.frame.width - 2*self.contentHorizontalPadding;
                    let articleViewFrame = CGRect(x: self.contentHorizontalPadding, y: self.nextContentY, width: articleViewWidth, height: articleViewWidth * 0.3);
                    let articleView = ArticleButton(frame: articleViewFrame);
                    
                    self.renderArticle(articleView, articleID, false);
                    
                    self.nextContentY += articleView.frame.height + self.contentVerticalPadding;
                    self.mainScrollView.addSubview(articleView);
                    
                }
                
            }
            
            self.mainScrollView.contentSize = CGSize(width: self.view.frame.width, height: self.nextContentY);
            
        });
        
    }
    
    internal func renderArticle(_ articleView: ArticleButton, _ articleID: String, _ hasImage: Bool){
          
        let articleViewCornerRadius : CGFloat = 7;
        
        //
        
        articleView.backgroundColor = pageAccentColor;
        articleView.layer.cornerRadius = articleViewCornerRadius;
        
        articleView.layer.shadowOffset = CGSize(width: 0, height: 2);
        articleView.layer.shadowColor = inversePageAccentColor.cgColor;
        articleView.layer.shadowRadius = 1;
        articleView.layer.shadowOpacity = 0.3;
        //articleView.layer.masksToBounds = false;
        //articleView.clipsToBounds = true;
        
        articleView.tag = 1;
        articleView.articleID = articleID;
        articleView.addTarget(self, action: #selector(self.openArticle), for: .touchUpInside);
        
        //
        
        if (hasImage){
            renderImageArticle(articleView, articleID, articleViewCornerRadius);
        }
        else{
            renderListArticle(articleView, articleID, articleViewCornerRadius);
        }
        
    }
    
    internal func renderImageArticle(_ articleView: ArticleButton, _ articleID: String, _ articleViewCornerRadius: CGFloat){
        
        dataManager.getBaseArticleData(articleID, completion: { (articledata) in
            
            let horizontalPadding : CGFloat = 10;
            let verticalPadding : CGFloat = 5;
            
            //
            
            let articleTimestampLabelHeight = articleView.frame.height * 0.05;
            let articleTimestampLabelFrame = CGRect(x: horizontalPadding, y: articleView.frame.height - verticalPadding - articleTimestampLabelHeight, width: articleView.frame.width - 2*horizontalPadding, height: articleTimestampLabelHeight);
            let articleTimestampLabel = UILabel(frame: articleTimestampLabelFrame);
            
            articleTimestampLabel.text = timeManager.epochToDiffString(articledata.timestamp);
            articleTimestampLabel.textAlignment = .left;
            articleTimestampLabel.textColor = .systemGray;
            articleTimestampLabel.font = UIFont(name: SFProDisplay_Regular, size: articleTimestampLabel.frame.height * 0.8);
            
            articleView.addSubview(articleTimestampLabel);
            
            //
            
            let topViewWidth = articleView.frame.width - 2*horizontalPadding;
            let topViewFont = UIFont(name: SFProDisplay_Semibold, size: topViewWidth * 0.1)!;
            let topViewHeight = min(articleView.frame.height, articleView.frame.height * 0.3);
            let topViewFrame = CGRect(x: horizontalPadding, y: articleTimestampLabel.frame.minY - verticalPadding - topViewHeight, width: topViewWidth, height: topViewHeight);
            let topViewLabel = UIButton(frame: topViewFrame);
            
            topViewLabel.setTitle("Opportunities", for: .normal);
            topViewLabel.setTitleColor(self.pageAccentColor, for: .normal);
            topViewLabel.titleLabel?.font = topViewFont;
            
            articleView.addSubview(topViewLabel);
            
            //
            
            let articleImageViewFrame = CGRect(x: 0, y: 0, width: articleView.frame.width, height: articleView.frame.height - 3*verticalPadding - topViewLabel.frame.height - articleTimestampLabel.frame.height);
            let articleImageView = UIImageView(frame: articleImageViewFrame);
            
            articleImageView.backgroundColor = self.pageAccentColor;
            articleImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner];
            articleImageView.layer.cornerRadius = articleViewCornerRadius;
            articleImageView.layer.masksToBounds = true;
            articleImageView.clipsToBounds = true;
            
            if (articledata.thumbURLs.count > 0){
            
                articleImageView.contentMode = .scaleAspectFill;
                
                articleImageView.setImageURL(articledata.thumbURLs[0]);
                
            }
            
            articleView.addSubview(articleImageView);
            
        });
        
        
    }
    
    internal func renderListArticle(_ articleView: ArticleButton, _ articleID: String, _ articleViewCornerRadius: CGFloat){
        
        dataManager.getBaseArticleData(articleID, completion: { (articledata) in
            
            let horizontalPadding : CGFloat = 10;
            let verticalPadding : CGFloat = 5;
        
            //
            
            let colorStripViewFrame = CGRect(x: 0, y: 0, width: articleView.frame.width * 0.02, height: articleView.frame.height);
            let colorStripView = UIView(frame: colorStripViewFrame);
            
            colorStripView.backgroundColor = articledata.color != nil ? articledata.color : dataManager.getCachedCategoryData(articledata.categoryID).color;
            
            colorStripView.layer.cornerRadius = articleViewCornerRadius / 2;
            colorStripView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner];
            colorStripView.layer.masksToBounds = true;
            
            articleView.addSubview(colorStripView);
            
            //
            
            let articleTimestampLabelHeight = articleView.frame.height * 0.11;
            let articleTimestampLabelFrame = CGRect(x: horizontalPadding + colorStripView.frame.width, y: articleView.frame.height - articleTimestampLabelHeight - verticalPadding, width: articleView.frame.width - 2*horizontalPadding - colorStripView.frame.width, height: articleTimestampLabelHeight);
            let articleTimestampLabel = UILabel(frame: articleTimestampLabelFrame);
            
            articleTimestampLabel.text = timeManager.epochToDiffString(articledata.timestamp);
            articleTimestampLabel.textAlignment = .left;
            articleTimestampLabel.textColor = .systemGray;
            articleTimestampLabel.font = UIFont(name: SFProDisplay_Regular, size: articleTimestampLabel.frame.height * 0.8);
            
            articleView.addSubview(articleTimestampLabel);
            
            //
            
            let articleTitleLabelFrame = CGRect(x: horizontalPadding + colorStripView.frame.width, y: verticalPadding, width: articleView.frame.width - 2*horizontalPadding - colorStripView.frame.width, height: articleView.frame.height - 3*verticalPadding - articleTimestampLabel.frame.height);
            let articleTitleLabel = UILabel(frame: articleTitleLabelFrame);
            
            articleTitleLabel.text = articledata.title;
            articleTitleLabel.textAlignment = .left;
            articleTitleLabel.textColor = self.inversePageAccentColor;
            articleTitleLabel.font = UIFont(name: SFProDisplay_Semibold, size: articleTitleLabel.frame.width * 0.08);
            articleTitleLabel.numberOfLines = 0;
            
            articleView.addSubview(articleTitleLabel);
            
        });
        
    }
    
}
