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
    
    internal let refreshControl : UIRefreshControl = UIRefreshControl();
    
    internal let mainScrollView : UIScrollView = UIScrollView();
    internal var nextY : CGFloat = 0;
    
    //
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        if (!self.hasBeenSetup){
            
            //
            
            mainScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height);
            mainScrollView.alwaysBounceVertical = true;
            self.view.addSubview(mainScrollView);
            
            //
            
            mainScrollView.addSubview(refreshControl);
            refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged);
            
            //
            
            renderTopBar();
            renderContent();
            
            self.hasBeenSetup = true;
        }
        
    }
    
    
    internal func renderContent(){
        
        let contentVerticalPadding = 3*verticalPadding;
        
        //
        
        for view in mainScrollView.subviews{
            if view.tag == 1{
                view.removeFromSuperview();
            }
        }
        
        //
        
        nextY = topBarView.frame.height + contentVerticalPadding;
        
        //
        
        let articleList = dataManager.getSavedArticleList();
        
        for article in articleList{
            
            let articleViewWidth = mainScrollView.frame.width - 2*horizontalPadding;
            let articleViewFrame = CGRect(x: horizontalPadding, y: nextY, width: articleViewWidth, height: articleViewWidth * 0.3);
            let articleView = ArticleButton(frame: articleViewFrame);
            
            articleView.layer.cornerRadius = articleView.frame.height / 8;
            articleView.clipsToBounds = true;
            
            articleView.backgroundColor = BackgroundSecondaryGrayColor;
            
            renderArticle(articleView, article);
            
            articleView.articleData = article;
            articleView.tag = 1;
            articleView.addTarget(self, action: #selector(self.openArticle), for: .touchUpInside);
            
            nextY += articleView.frame.height + contentVerticalPadding;
            mainScrollView.addSubview(articleView);
            
        }
        
        mainScrollView.contentSize = CGSize(width: mainScrollView.frame.width, height: nextY);
        
    }
    
    internal func renderTopBar(){
        
        let topBarViewWidth = mainScrollView.frame.width;
        let topBarViewHeight = topBarViewWidth * 0.05;
        topBarView.frame = CGRect(x: 0, y: 0, width: topBarViewWidth, height: topBarViewHeight);
        
        mainScrollView.addSubview(topBarView);
        
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
        clearAllButton.setTitleColor(.white, for: .normal);
        clearAllButton.titleLabel?.font = clearAllButtonLabelFont;
        clearAllButton.titleLabel?.textAlignment = .center;
        
        clearAllButton.addTarget(self, action: #selector(self.clearAll), for: .touchUpInside);
        topBarView.addSubview(clearAllButton);
        
    }
    
    internal func renderArticle(_ articleView: UIView, _ articleData: fullArticleData){
        
        let categoryColorViewHeight = articleView.frame.height;
        let categoryColorViewWidth = categoryColorViewHeight * 0.08;
        let categoryColorViewFrame = CGRect(x: 0, y: 0, width: categoryColorViewWidth, height: categoryColorViewHeight);
        let categoryColorView = UIView(frame: categoryColorViewFrame);
        
        categoryColorView.backgroundColor = articleData.baseData.color;
        
        articleView.addSubview(categoryColorView);
        
        //
        
        
        
        //
        
        dataManager.getCategoryData(articleData.baseData.categoryID, completion: { (categorydata) in
            
            categoryColorView.backgroundColor = categorydata.color;
        
        });
        
    }
    
}
