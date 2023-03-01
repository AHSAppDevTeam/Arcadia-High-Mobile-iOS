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
    internal let topViewButton = UIButton();
    
    internal let contentHorizontalPadding : CGFloat = AppUtility.getCurrentScreenSize().width / 20;
    internal let headerVerticalPadding : CGFloat = 14;
    internal let contentVerticalPadding : CGFloat = 14;
    internal var nextContentY : CGFloat = 0;
    
    internal let pageAccentColor : UIColor = .white;
    internal let secondaryPageAccentColor : UIColor = UIColor.init(hex: "5fa4a9");
    internal let inversePageAccentColor : UIColor = .black;
    
    internal var hasRenderedLargeArticle : Bool = false;
    internal var subArticleRenderRowCount : Int = 2;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.view.backgroundColor = BackgroundColor;
        
        //
        
        setupPanGesture();
        
        renderTopView();
        
        //

        let mainScrollViewFrameY = topViewButton.frame.maxY + headerVerticalPadding;
        mainScrollView.frame = CGRect(x: 0, y: mainScrollViewFrameY, width: self.view.frame.width, height: self.view.frame.height - mainScrollViewFrameY);
        
        mainScrollView.alwaysBounceVertical = true;
        mainScrollView.showsVerticalScrollIndicator = true;
        
        self.view.addSubview(mainScrollView);
        
        //
        
        refreshControl.tintColor = pageAccentColor;
        refreshControl.addTarget(self, action: #selector(self.handleRefresh), for: .valueChanged);
        mainScrollView.addSubview(refreshControl);
    
        
        //
        
        renderContent();
    }
    
    internal func renderTopView(){
        let topViewButtonWidth = self.view.frame.width;
        let topViewButtonFrame = CGRect(x: 0, y: AppUtility.safeAreaInset.top, width: topViewButtonWidth, height: topViewButtonWidth * 0.08);
        topViewButton.frame = topViewButtonFrame;
        
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
        let topViewLabelFontSize = topViewLabelFrame.height * 1;
        let topViewLabelAttributedText = NSMutableAttributedString(string: "Opportunities", attributes: [NSAttributedString.Key.font : UIFont(name: SFProDisplay_Bold, size: topViewLabelFontSize)!]);
        let topViewLabel = UILabel(frame: topViewLabelFrame);
        
        topViewLabel.textAlignment = .left;
        topViewLabel.textColor = secondaryPageAccentColor;
        topViewLabel.isUserInteractionEnabled = false;
        topViewLabel.attributedText = topViewLabelAttributedText;
        
        
        topViewButton.addSubview(topViewLabel);
        
        //
        
        topViewButton.addTarget(self, action: #selector(self.dismissHandler), for: .touchUpInside);
        
        topViewButton.tag = 1;
        self.view.addSubview(topViewButton);
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
        
        refreshControl.beginRefreshing();
        
        
        dataManager.getCategoryData(categoryID, completion: { (categorydata) in
            self.refreshControl.endRefreshing();
            
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
        
        renderImageArticle(articleView, articleID, articleViewCornerRadius);
        
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
            let articleTitleLabelWidth = articleView.frame.width - 2*horizontalPadding - (2/7)*articleView.frame.width;
            let articleTitleLabelFont = UIFont(name: SFProDisplay_Semibold, size: articleTitleLabelWidth*0.1)!;
            let articleTitleLabelHeight = min(articleTitleLabelText.height(withConstrainedWidth: articleTitleLabelWidth, font: articleTitleLabelFont), articleView.frame.height * 0.3);
            let articleTitleLabelFrame = CGRect(x: 2*horizontalPadding + (1/4)*articleView.frame.width, y: articleTimestampLabel.frame.minY - 3*articleTitleLabelHeight + verticalPadding, width: articleTitleLabelWidth, height: articleTitleLabelHeight);
            let articleTitleLabel = UILabel(frame: articleTitleLabelFrame);
            
            articleTitleLabel.adjustsFontSizeToFitWidth = true;
            articleTitleLabel.minimumScaleFactor = 0.7;
            articleTitleLabel.text = articleTitleLabelText;
            articleTitleLabel.textAlignment = .left;
            articleTitleLabel.textColor = self.inversePageAccentColor;
            articleTitleLabel.font = articleTitleLabelFont;
            articleTitleLabel.numberOfLines = 0;
            
            articleView.addSubview(articleTitleLabel);
            
            //
            
            let articleDescLabelText = "description here";
            let articleDescLabelWidth = articleView.frame.width - 2*horizontalPadding - (2/7)*articleView.frame.width;
            let articleDescLabelFont = UIFont(name: SFProDisplay_Semibold, size: articleDescLabelWidth*0.05)!;
            let articleDescLabelHeight = min(articleTitleLabelText.height(withConstrainedWidth: articleDescLabelWidth, font: articleDescLabelFont), articleView.frame.height * 0.3);
            let articleDescLabelFrame = CGRect(x: 2*horizontalPadding + (1/4)*articleView.frame.width, y: articleTimestampLabel.frame.minY - 4*articleDescLabelHeight + verticalPadding, width: articleDescLabelWidth, height: articleDescLabelHeight);
            let articleDescLabel = UILabel(frame: articleDescLabelFrame);
            
            articleDescLabel.adjustsFontSizeToFitWidth = true;
            articleDescLabel.minimumScaleFactor = 0.5;
            articleDescLabel.text = articleDescLabelText;
            articleDescLabel.textAlignment = .left;
            articleDescLabel.textColor = self.inversePageAccentColor;
            articleDescLabel.font = articleDescLabelFont;
            articleDescLabel.numberOfLines = 0;
            
            articleView.addSubview(articleDescLabel);
            //
            
            let articleImageViewFrame = CGRect(x: horizontalPadding, y: verticalPadding, width: (1/4)*articleView.frame.width, height: articleView.frame.height - 2*verticalPadding);
            let articleImageView = UIImageView(frame: articleImageViewFrame);
            
            articleImageView.backgroundColor = self.pageAccentColor;
            articleImageView.layer.cornerRadius = articleViewCornerRadius;
            articleImageView.clipsToBounds = true;
            
            if (articledata.thumbURLs.count > 0){
            
                articleImageView.contentMode = .scaleAspectFill;
                
                articleImageView.setImageURL(articledata.thumbURLs[0]);
                
            }
            
            articleView.addSubview(articleImageView);
            
        });
        
    }
    
}
