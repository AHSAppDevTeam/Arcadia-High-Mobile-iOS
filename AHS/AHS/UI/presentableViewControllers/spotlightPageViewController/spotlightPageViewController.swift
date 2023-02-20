//
//  opportunitiesPageViewController.swift
//  AHS
//
//  Created by Kaitlyn Kwan on 2/5/2023
//

import Foundation
import UIKit


class spotlightPageViewController : presentableViewController{
    
    public var categoryID : String = "";
    
    internal let mainScrollView = UIButtonScrollView();
    internal let refreshControl = UIRefreshControl();
    internal let topView = UIButton();
    
    internal let contentHorizontalPadding : CGFloat = AppUtility.getCurrentScreenSize().width / 20;
    internal let headerVerticalPadding : CGFloat = 8;
    internal let contentVerticalPadding : CGFloat = 14;
    internal var nextContentY : CGFloat = 0;
    
    internal let pageAccentColor : UIColor = .white;
    internal let secondaryPageAccentColor : UIColor = UIColor.init(hex: "5fa4a9");
    internal let inversePageAccentColor : UIColor = .black;
    
    internal var hasRenderedLargeArticle : Bool = false;
    internal var subArticleRenderRowCount : Int = 2;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        setupPanGesture();
        
        let image = UIImage(named: "chevron.left")
        topView.setBackgroundImage(image, for: UIControl.State.normal);
        topView.addTarget(self, action: #selector(self.topViewTapped), for: .touchUpInside);
        self.view.addSubview(topView);
        
        
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
    @objc func topViewTapped(_sender:UIButton!){
        print("");
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
        
        //
        
        let topViewButtonFrameWidth = mainScrollView.frame.width - contentHorizontalPadding;
        let topViewButtonFrame = CGRect(x: contentHorizontalPadding / 2 + 20, y: nextContentY + 50, width: topViewButtonFrameWidth, height: topViewButtonFrameWidth * 0.08);
        let topViewButton = UIButton(frame: topViewButtonFrame);
        
        let topViewButtonContentHorizontalPadding : CGFloat = 5;
        
        //
        
        let topViewImageViewSize = topViewButton.frame.height;
        let topViewImageViewFrame = CGRect(x: 0, y: 0, width: topViewImageViewSize, height: topViewImageViewSize);
        let topViewImageView = UIImageView(frame: topViewImageViewFrame);
        
        topViewImageView.contentMode = .scaleAspectFit;
        topViewImageView.image = UIImage(systemName: "chevron.left");
        topViewImageView.backgroundColor = .clear;
        topViewImageView.tintColor = .gray;
        
        topViewButton.addSubview(topViewImageView);
        
        //
        
        let topViewLabelFrame = CGRect(x: topViewImageView.frame.width + topViewButtonContentHorizontalPadding, y: 0, width: topViewButton.frame.width - topViewImageView.frame.width - 2*topViewButtonContentHorizontalPadding, height: topViewButton.frame.height);
        let topViewLabel = UILabel(frame: topViewLabelFrame);
        
        topViewLabel.textAlignment = .left;
        topViewLabel.textColor = secondaryPageAccentColor;
        topViewLabel.isUserInteractionEnabled = false;
        
        
        topViewButton.addSubview(topViewLabel);
        
        //
        
        topViewButton.addTarget(self, action: #selector(self.dismissHandler), for: .touchUpInside);
        
        topViewButton.tag = 1;
        nextContentY += topViewButton.frame.height + headerVerticalPadding;
        self.view.addSubview(topViewButton);
        
        //
        
        refreshControl.beginRefreshing();
        dataManager.getCategoryData(categoryID, completion: { (categorydata) in
            self.refreshControl.endRefreshing();
            
            let topViewLabelFontSize = topViewLabel.frame.height * 1;
            let topViewLabelAttributedText = NSMutableAttributedString(string: "Opportunities", attributes: [NSAttributedString.Key.font : UIFont(name: SFProDisplay_Bold, size: topViewLabelFontSize)!]);
            topViewLabel.attributedText = topViewLabelAttributedText;
            
            //
            
            for articleID in categorydata.articleIDs{
                
            let articleViewWidth = self.mainScrollView.frame.width - 2*self.contentHorizontalPadding;
            let articleViewFrame = CGRect(x: self.contentHorizontalPadding, y: self.nextContentY, width: articleViewWidth, height: articleViewWidth * 0.3);
            let articleView = ArticleButton(frame: articleViewFrame);

            self.renderArticle(articleView, articleID, false);

            self.nextContentY += articleView.frame.height + self.contentVerticalPadding;
            self.mainScrollView.addSubview(articleView);

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
            
            let articleTitleLabelText = articledata.title;
            let articleTitleLabelWidth = articleView.frame.width - 2*horizontalPadding;
            let articleTitleLabelFont = UIFont(name: SFProDisplay_Semibold, size: articleTitleLabelWidth * 0.1)!;
            let articleTitleLabelHeight = min(articleTitleLabelText.height(withConstrainedWidth: articleTitleLabelWidth, font: articleTitleLabelFont), articleView.frame.height * 0.3);
            let articleTitleLabelFrame = CGRect(x: horizontalPadding, y: articleTimestampLabel.frame.minY - verticalPadding - articleTitleLabelHeight, width: articleTitleLabelWidth, height: articleTitleLabelHeight);
            let articleTitleLabel = UILabel(frame: articleTitleLabelFrame);
            
            articleTitleLabel.text = articleTitleLabelText;
            articleTitleLabel.textAlignment = .left;
            articleTitleLabel.textColor = self.inversePageAccentColor;
            articleTitleLabel.font = articleTitleLabelFont;
            articleTitleLabel.numberOfLines = 0;
            
            articleView.addSubview(articleTitleLabel);
            
            //
            
            let articleImageViewFrame = CGRect(x: 0, y: 0, width: articleView.frame.width, height: articleView.frame.height - 3*verticalPadding - articleTitleLabel.frame.height - articleTimestampLabel.frame.height);
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
