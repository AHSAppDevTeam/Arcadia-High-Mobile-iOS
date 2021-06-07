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
    internal let headerVerticalPadding : CGFloat = 8;
    internal let contentVerticalPadding : CGFloat = 14;
    internal var nextContentY : CGFloat = 0;
    
    internal let pageAccentColor : UIColor = .white;
    internal let secondaryPageAccentColor : UIColor = UIColor.init(hex: "5fa4a9");
    internal let inversePageAccentColor : UIColor = .black;
    
    internal var hasRenderedLargeArticle : Bool = false;
    internal var subArticleRenderRowCount : Int = 2;
    internal var subArticleSecondaryRenderY : CGFloat = -1;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        setupPanGesture();
        
        //
        
        mainScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height);
        
        mainScrollView.alwaysBounceVertical = true;
        mainScrollView.showsVerticalScrollIndicator = true;
        
        self.view.addSubview(mainScrollView);
        
        //
        
        refreshControl.tintColor = pageAccentColor;
        refreshControl.addTarget(self, action: #selector(self.handleRefresh), for: .valueChanged);
        mainScrollView.addSubview(refreshControl);
        
        //
        
        let topMainScrollViewGradientColor = secondaryPageAccentColor;
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
        
        dismissButton.tag = 1;
        nextContentY += dismissButton.frame.height + headerVerticalPadding;
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
        
        locationView.tag = 1;
        nextContentY += locationView.frame.height + headerVerticalPadding;
        mainScrollView.addSubview(locationView);
        
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
            
            let categoryLabelFontSize = categoryLabel.frame.height * 0.7;
            let categoryLabelAttributedText = NSMutableAttributedString(string: categorydata.title, attributes: [NSAttributedString.Key.font : UIFont(name: SFProDisplay_Bold, size: categoryLabelFontSize)!]);
            categoryLabelAttributedText.append(NSAttributedString(string: " News", attributes: [NSAttributedString.Key.font : UIFont(name: SFProDisplay_Regular, size: categoryLabelFontSize)!]));
            categoryLabel.attributedText = categoryLabelAttributedText;
            
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
        
        var nextY : CGFloat = 0;
        
        let horizontalPadding : CGFloat = 10;
        let verticalPadding : CGFloat = 5;
        
        //
        
        articleView.backgroundColor = pageAccentColor;
        articleView.layer.cornerRadius = 5;
        
        articleView.layer.shadowOffset = CGSize(width: 0, height: 2);
        articleView.layer.shadowColor = inversePageAccentColor.cgColor;
        articleView.layer.shadowRadius = 0.8;
        articleView.layer.shadowOpacity = 0.5;
        
        articleView.tag = 1;
        articleView.articleID = articleID;
        articleView.addTarget(self, action: #selector(self.openArticle), for: .touchUpInside);
        //
        
        dataManager.getFullArticleData(articleID, completion: { (articledata) in
            
            if (hasImage){
                
                let imageViewWidth = articleView.frame.width;
                let imageViewFrame = CGRect(x: 0, y: 0, width: imageViewWidth, height: imageViewWidth * 0.55);
                let imageView = UIImageView(frame: imageViewFrame);
                
                imageView.backgroundColor = self.secondaryPageAccentColor;
                imageView.clipsToBounds = true;
                
                if (articledata.imageURLs.count > 0){
                
                    imageView.contentMode = .scaleAspectFill;
                    
                    imageView.setImageURL(articledata.imageURLs[0]);
                    
                }
                
                nextY += imageView.frame.height;
                articleView.addSubview(imageView);
            }
            nextY += verticalPadding;
            
            //
            
            let articleTimestampLabelHeight = articleView.frame.height * (hasImage ? 0.05 : 0.11);
            
            //
            
            let articleTitleLabelFrame = CGRect(x: horizontalPadding, y: nextY, width: articleView.frame.width - 2*horizontalPadding, height: articleView.frame.height - nextY - 2*verticalPadding - articleTimestampLabelHeight);
            let articleTitleLabel = UILabel(frame: articleTitleLabelFrame);
            
            //articleTitleLabel.backgroundColor = .systemRed;
            articleTitleLabel.text = articledata.baseData.title;
            articleTitleLabel.textAlignment = .left;
            articleTitleLabel.textColor = self.inversePageAccentColor;
            articleTitleLabel.font = UIFont(name: SFProDisplay_Semibold, size: articleTitleLabel.frame.width * 0.1);
            articleTitleLabel.numberOfLines = 0;
            
            nextY += articleTitleLabel.frame.height + verticalPadding;
            articleView.addSubview(articleTitleLabel);
            
            //
            
            let articleTimestampLabelFrame = CGRect(x: horizontalPadding, y: nextY, width: articleView.frame.width - 2*horizontalPadding, height: articleTimestampLabelHeight);
            let articleTimestampLabel = UILabel(frame: articleTimestampLabelFrame);
        
            //articleTimestampLabel.backgroundColor = .systemBlue;
            articleTimestampLabel.text = timeManager.epochToDiffString(articledata.baseData.timestamp);
            articleTimestampLabel.textAlignment = .left;
            articleTimestampLabel.textColor = .systemGray;
            articleTimestampLabel.font = UIFont(name: SFProDisplay_Regular, size: articleTimestampLabel.frame.height * 0.8);
            
            nextY += articleTimestampLabel.frame.height + verticalPadding;
            articleView.addSubview(articleTimestampLabel);
            
        });
        
        
    }
    
}
