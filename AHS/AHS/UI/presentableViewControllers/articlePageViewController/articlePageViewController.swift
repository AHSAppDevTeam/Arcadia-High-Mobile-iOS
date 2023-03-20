//
//  articlePageViewController.swift
//  AHS
//
//  Created by Richard Wei on 5/25/21.
//

import Foundation
import UIKit
import UPCarouselFlowLayout
import AMPopTip

class articlePageViewController : presentableViewController, UIScrollViewDelegate{
    
    public var articleID : String = "";
    public var articledata: fullArticleData? = nil;
    
    internal var nextContentY : CGFloat = 0;
    internal var userInterfaceStyle : UIUserInterfaceStyle = .unspecified;
    
    internal let scrollView : UIScrollView = UIScrollView();
    internal let refreshControl : UIRefreshControl = UIRefreshControl();
    
    internal let topBarCategoryButtonLabel = UIButton();
    internal let topBarView : UIView = UIView();
    
    internal let fontSliderPopTip : PopTip = PopTip();
    internal var fontLabel : UILabel = UILabel();
    
    internal let mediaCollectionViewLayout = UPCarouselFlowLayout();
    internal var mediaCollectionView = UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewLayout());
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        setupPanGesture();
        
        self.articleID = articledata?.baseData.articleID ?? self.articleID;
    
        renderUI();
        
        if (articledata == nil){
            loadArticleData();
        }
        else{
            renderArticle(articledata!);
        }
        
        if (!articleID.isEmpty){
            dataManager.incrementArticleView(articleID);
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        
        AppUtility.currentUserInterfaceStyle = .unspecified;
        setNeedsStatusBarAppearanceUpdate();
    }
    
    internal func renderUI(){
        
        self.view.backgroundColor = BackgroundColor;
        
        //
        
        let topBarViewFrame = CGRect(x: 0, y: AppUtility.safeAreaInset.top, width: self.view.frame.width, height: self.view.frame.width * 0.11);
        //let topBarView = UIView(frame: topBarViewFrame);
        topBarView.frame = topBarViewFrame;
        
        //topBarView.backgroundColor = .systemBlue;
        
        let topBarVerticalPadding : CGFloat = topBarView.frame.height / 8;
        let topBarHorizontalPadding : CGFloat = 5;
        
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
        
        //
        
        let topBarBookmarkButtonFrame = CGRect(x: topBarView.frame.width - topBarButtonSize, y: topBarVerticalPadding, width: topBarButtonSize, height: topBarButtonSize);
        let topBarBookmarkButton = UIButton(frame: topBarBookmarkButtonFrame);
        
        topBarBookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal);
        topBarBookmarkButton.imageView?.contentMode = .scaleAspectFit;
        topBarBookmarkButton.contentVerticalAlignment = .fill;
        topBarBookmarkButton.contentHorizontalAlignment = .fill;
        topBarBookmarkButton.imageEdgeInsets = topBarButtonEdgeInsets;
        topBarBookmarkButton.tintColor = BackgroundGrayColor;
        
        topBarBookmarkButton.addTarget(self, action: #selector(self.toggleBookmark), for: .touchUpInside);
        
        self.updateBookmarkButtonAppearance(topBarBookmarkButton);
        
        topBarView.addSubview(topBarBookmarkButton);
        
        //
        
        let topBarColorButtonFrame = CGRect(x: topBarView.frame.width - 2*topBarButtonSize - topBarHorizontalPadding, y: topBarVerticalPadding, width: topBarButtonSize, height: topBarButtonSize);
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
        
        let topBarFontButtonFrame = CGRect(x: topBarView.frame.width - 3*topBarButtonSize - 2*topBarHorizontalPadding - topBarButtonInset, y: topBarVerticalPadding, width: topBarButtonSize, height: topBarButtonSize);
        let topBarFontButton = UIButton(frame: topBarFontButtonFrame);
        
        topBarFontButton.setImage(UIImage(systemName: "textformat"), for: .normal);
        topBarFontButton.imageView?.contentMode = .scaleAspectFit;
        topBarFontButton.contentVerticalAlignment = .fill;
        topBarFontButton.contentHorizontalAlignment = .fill;
        //topBarFontButton.imageEdgeInsets = topBarButtonEdgeInsets;
        topBarFontButton.tintColor = BackgroundGrayColor;
        
        topBarFontButton.addTarget(self, action: #selector(self.showFontPopup), for: .touchUpInside);
        
        topBarView.addSubview(topBarFontButton);
        
        //
        
        let topBarCategoryButtonLabelFrame = CGRect(x: topBarBackButton.frame.width + topBarHorizontalPadding, y: topBarVerticalPadding, width: topBarView.frame.width - (topBarBackButton.frame.width + 2*topBarHorizontalPadding + (topBarView.frame.width - topBarFontButton.frame.minX)), height: topBarView.frame.height - 2*topBarVerticalPadding);
        topBarCategoryButtonLabel.frame = topBarCategoryButtonLabelFrame;
        
        //topBarCategoryButtonLabel.titleLabel?.textAlignment = .left;
        topBarCategoryButtonLabel.contentHorizontalAlignment = .left;
        topBarCategoryButtonLabel.setTitleColor(UIColor.init(hex: "cc5454"), for: .normal);
        topBarCategoryButtonLabel.setAttributedTitle(self.generateTopBarTitleText(articledata?.baseData.categoryID ?? ""), for: .normal);
        
        topBarCategoryButtonLabel.addTarget(self, action: #selector(self.handleBackButton), for: .touchUpInside);
        
        topBarView.addSubview(topBarCategoryButtonLabel);
        
        //
        
        scrollView.frame = CGRect(x: 0, y: topBarView.frame.maxY, width: self.view.frame.width, height: self.view.frame.height - topBarView.frame.maxY);
        self.view.addSubview(scrollView);
        
        //scrollView.backgroundColor = InverseBackgroundColor;
        scrollView.alwaysBounceVertical = true;
        scrollView.showsVerticalScrollIndicator = true;
        
        scrollView.delegate = self;
        
        refreshControl.addTarget(self, action: #selector(self.handleRefresh), for: .valueChanged)
        scrollView.addSubview(refreshControl);
        
        //
        
        self.view.addSubview(topBarView);
        
    }
    
    internal func loadArticleData(){
        refreshControl.beginRefreshing();
        
        if (dataManager.getIsConnectedToInternet()){
            
            dataManager.getFullArticleData(articleID, completion: { (data) in
                self.refreshControl.endRefreshing();
                self.renderArticle(data);
            });
            
        }
        else{
            
            refreshControl.endRefreshing();
       
        }
    }
    
    internal func renderArticle(_ articleData: fullArticleData){
        
        articledata = articleData;
        
        let horizontalPadding = self.view.frame.width / 18;
        let verticalPadding : CGFloat = 10;
        let contentWidth = self.view.frame.width - 2*horizontalPadding;
        
        let fontSize = CGFloat(dataManager.preferencesStruct.fontSize);
        
        //
        
        if (articleData.imageURLs.count + articleData.videoIDs.count > 1){
            
            let mediaCollectionViewWidth = self.view.frame.width;
            let mediaCollectionViewHeight = mediaCollectionViewWidth * 0.65;
            
            let mediaCollectionViewFrame = CGRect(x: 0, y: nextContentY, width: self.view.frame.width, height: self.view.frame.width * 0.65);
            let mediaCollectionViewLayoutItemSizeVerticalPadding = mediaCollectionViewHeight / 12;
            mediaCollectionViewLayout.itemSize = CGSize(width: mediaCollectionViewWidth + 2*horizontalPadding, height: mediaCollectionViewHeight - mediaCollectionViewLayoutItemSizeVerticalPadding);
            mediaCollectionViewLayout.scrollDirection = .horizontal;
            mediaCollectionViewLayout.spacingMode = .overlap(visibleOffset: horizontalPadding / 2);
            
            mediaCollectionView = UICollectionView(frame: mediaCollectionViewFrame, collectionViewLayout: mediaCollectionViewLayout);
            
            mediaCollectionView.showsVerticalScrollIndicator = false;
            mediaCollectionView.showsHorizontalScrollIndicator = false;
            mediaCollectionView.delegate = self;
            mediaCollectionView.dataSource = self;
            mediaCollectionView.register(mediaCollectionViewCell.self, forCellWithReuseIdentifier: mediaCollectionViewCell.identifier);
            mediaCollectionView.backgroundColor = .clear;
            
            mediaCollectionView.tag = 1;
            scrollView.addSubview(mediaCollectionView);
            nextContentY += mediaCollectionView.frame.height;
            
        } else {
            let mediaCollectionViewWidth = self.view.frame.width;
            let mediaCollectionViewHeight = mediaCollectionViewWidth * 0.65;
            
            let mediaCollectionViewFrame = CGRect(x: 0, y: nextContentY, width: self.view.frame.width, height: self.view.frame.width * 0.65);
            let mediaCollectionViewLayoutItemSizeVerticalPadding = mediaCollectionViewHeight / 12;
            mediaCollectionViewLayout.itemSize = CGSize(width: mediaCollectionViewWidth - 2*horizontalPadding, height: mediaCollectionViewHeight - mediaCollectionViewLayoutItemSizeVerticalPadding);
            mediaCollectionViewLayout.scrollDirection = .horizontal;
            mediaCollectionViewLayout.spacingMode = .overlap(visibleOffset: horizontalPadding / 2);
            
            mediaCollectionView = UICollectionView(frame: mediaCollectionViewFrame, collectionViewLayout: mediaCollectionViewLayout);
            
            mediaCollectionView.showsVerticalScrollIndicator = false;
            mediaCollectionView.showsHorizontalScrollIndicator = false;
            mediaCollectionView.delegate = self;
            mediaCollectionView.dataSource = self;
            mediaCollectionView.register(mediaCollectionViewCell.self, forCellWithReuseIdentifier: mediaCollectionViewCell.identifier);
            mediaCollectionView.backgroundColor = .clear;
            
            mediaCollectionView.tag = 1;
            scrollView.addSubview(mediaCollectionView);
            nextContentY += mediaCollectionView.frame.height;
        }
        
        nextContentY += verticalPadding;
        
        //
        
        if (!articleData.baseData.title.isEmpty){
            
            let titleLabelText = articleData.baseData.title;
            let titleLabelFont = UIFont(name: SFProDisplay_Bold, size: fontSize + 10)!;
            let titleLabelHeight = titleLabelText.height(withConstrainedWidth: contentWidth, font: titleLabelFont);
            let titleLabelFrame = CGRect(x: horizontalPadding, y: nextContentY, width: contentWidth, height: titleLabelHeight);
            let titleLabel = UILabel(frame: titleLabelFrame);
            
            titleLabel.text = titleLabelText;
            titleLabel.font = titleLabelFont;
            titleLabel.textAlignment = .center;
            titleLabel.textColor = InverseBackgroundColor;
            titleLabel.numberOfLines = 0;
            
            titleLabel.tag = 1;
            scrollView.addSubview(titleLabel);
            nextContentY += titleLabel.frame.height + verticalPadding;
            
        }
        
        //
        
        if (!articleData.author.isEmpty){
            
            let authorLabelText = articleData.author;
            let authorLabelFont = UIFont(name: SFProDisplay_Regular, size: fontSize)!;
            let authorLabelHeight = authorLabelText.height(withConstrainedWidth: contentWidth, font: authorLabelFont);
            let authorLabelFrame = CGRect(x: horizontalPadding, y: nextContentY, width: contentWidth, height: authorLabelHeight);
            let authorLabel = UILabel(frame: authorLabelFrame);
            
            authorLabel.text = authorLabelText;
            authorLabel.font = authorLabelFont;
            authorLabel.textAlignment = .center;
            authorLabel.textColor = BackgroundGrayColor;
            authorLabel.numberOfLines = 0;
            
            authorLabel.tag = 1;
            scrollView.addSubview(authorLabel);
            nextContentY += authorLabel.frame.height + verticalPadding;
            
        }
        
        //
        
        if (!articleData.body.isEmpty){
            
            let bodyLabelFont = UIFont(name: SFProDisplay_Regular, size: fontSize)!;
            let bodyLabelText = htmlFunctions.parseHTML(articleData.body, bodyLabelFont);
            let bodyLabelHeight = bodyLabelText.height(containerWidth: contentWidth);
            let bodyLabelFrame = CGRect(x: horizontalPadding, y: nextContentY, width: contentWidth, height: bodyLabelHeight);
            let bodyLabel = UITextView(frame: bodyLabelFrame);
            
            bodyLabel.attributedText = bodyLabelText;
            bodyLabel.font = bodyLabelFont;
            bodyLabel.textAlignment = .left;
            bodyLabel.textColor = InverseBackgroundColor;
            bodyLabel.isEditable = false;
            bodyLabel.isScrollEnabled = false;
            bodyLabel.tintColor = .systemBlue;
            bodyLabel.backgroundColor = .clear;
            bodyLabel.textContainerInset = .zero;
            bodyLabel.textContainer.lineFragmentPadding = 0;
            
            bodyLabel.tag = 1;
            scrollView.addSubview(bodyLabel);
            nextContentY += bodyLabel.frame.height + verticalPadding;
            
        }
    
        //
        
        let categoryButtonHorizontalPadding = horizontalPadding * 2;
        let categoryButtonFrameWidth = self.view.frame.width - 2*categoryButtonHorizontalPadding;
        let categoryButtonFrame = CGRect(x: categoryButtonHorizontalPadding, y: nextContentY, width: categoryButtonFrameWidth, height: categoryButtonFrameWidth * 0.15);
        let categoryButton = CategoryButton(frame: categoryButtonFrame);
        let categoryButtonInnerButtonEdgeInsets : CGFloat = 4;
        
        categoryButton.backgroundColor = BackgroundSecondaryGrayColor;
        categoryButton.layer.cornerRadius = categoryButton.frame.height / 2;
        categoryButton.titleLabel?.textAlignment = .center;
        categoryButton.titleLabel?.lineBreakMode = .byTruncatingTail;
        categoryButton.setTitleColor(UIColor.init(hex: "cc5454"), for: .normal);
        categoryButton.setAttributedTitle(self.generateCategoryButtonTitle(articleData.baseData.categoryID, categoryButton.frame.height), for: .normal);
        categoryButton.titleEdgeInsets = UIEdgeInsets(top: categoryButtonInnerButtonEdgeInsets, left: categoryButtonInnerButtonEdgeInsets, bottom: categoryButtonInnerButtonEdgeInsets, right: categoryButtonInnerButtonEdgeInsets);
        
        categoryButton.tag = 1;
        categoryButton.categoryID = articleData.baseData.categoryID;
        categoryButton.addTarget(self, action: #selector(self.openCategoryPage), for: .touchUpInside);
        scrollView.addSubview(categoryButton);
        nextContentY += categoryButton.frame.height + 3*verticalPadding;
        
        //
        
        let articleViewLabelFrame = CGRect(x: horizontalPadding, y: nextContentY, width: contentWidth, height: contentWidth * 0.06);
        let articleViewLabel = UILabel(frame: articleViewLabelFrame);
        
        articleViewLabel.font = UIFont(name: SFProDisplay_Regular, size: articleViewLabel.frame.height * 0.8);
        articleViewLabel.textAlignment = .left;
        articleViewLabel.textColor = InverseBackgroundGrayColor;
        articleViewLabel.text = String(articleData.views) + " views";
        
        articleViewLabel.tag = 1;
        scrollView.addSubview(articleViewLabel);
        //nextContentY += articleViewLabel.frame.height + verticalPadding; -- accounted for at the end when setting scrollview content size
        
        //
        
        for relatedArticleID in articleData.relatedArticleIDs{
            
            let relatedArticleViewFrameWidth = self.view.frame.width - 2*horizontalPadding;
            let relatedArticleViewFrame = CGRect(x: horizontalPadding, y: nextContentY, width: relatedArticleViewFrameWidth, height: relatedArticleViewFrameWidth * 0.3);
            let relatedArticleView = ArticleButton(frame: relatedArticleViewFrame);
            
            relatedArticleView.backgroundColor = BackgroundSecondaryGrayColor;
            relatedArticleView.layer.cornerRadius = relatedArticleView.frame.height / 6;
            relatedArticleView.articleID = relatedArticleID;
            relatedArticleView.clipsToBounds = true;
            relatedArticleView.addTarget(self, action: #selector(self.openRelatedArticle), for: .touchUpInside);
            
            let relatedArticleContentHorizontalPadding : CGFloat = 8;
            let relatedArticleContentVerticalPadding : CGFloat = 3;
            
            let relatedArticleOuterHorizontalPadding : CGFloat = 10;
            let relatedArticleOuterVerticalPadding : CGFloat = 8;
            
            //
            
            let relatedArticleImageView = UIImageView();
            
            relatedArticleView.addSubview(relatedArticleImageView);
            
            relatedArticleImageView.translatesAutoresizingMaskIntoConstraints = false;
            
            let relatedArticleImageViewHeight = relatedArticleView.frame.height - 2*relatedArticleOuterVerticalPadding;
            relatedArticleImageView.leadingAnchor.constraint(equalTo: relatedArticleView.leadingAnchor, constant: relatedArticleOuterHorizontalPadding).isActive = true;
            relatedArticleImageView.topAnchor.constraint(equalTo: relatedArticleView.topAnchor, constant: relatedArticleOuterVerticalPadding).isActive = true;
            relatedArticleImageView.heightAnchor.constraint(equalToConstant: relatedArticleImageViewHeight).isActive = true;
            let relatedArticleImageViewWidthConstraint = relatedArticleImageView.widthAnchor.constraint(equalToConstant: 0);
            relatedArticleImageViewWidthConstraint.isActive = true;
            
            relatedArticleImageView.clipsToBounds = true;
            relatedArticleImageView.layer.cornerRadius = relatedArticleImageViewHeight / 8;
            relatedArticleImageView.backgroundColor = .systemRed;
            relatedArticleImageView.contentMode = .scaleAspectFill;
            
            //
            
            let relatedArticleLabel = UILabel();
            
            relatedArticleView.addSubview(relatedArticleLabel);
            
            relatedArticleLabel.translatesAutoresizingMaskIntoConstraints = false;
            
            let relatedArticleLabelHeight = relatedArticleView.frame.height * 0.7 - relatedArticleOuterVerticalPadding;
            relatedArticleLabel.leadingAnchor.constraint(equalTo: relatedArticleImageView.trailingAnchor, constant: relatedArticleContentHorizontalPadding).isActive = true;
            relatedArticleLabel.topAnchor.constraint(equalTo: relatedArticleView.topAnchor, constant: relatedArticleOuterVerticalPadding).isActive = true;
            relatedArticleLabel.trailingAnchor.constraint(equalTo: relatedArticleView.trailingAnchor, constant: relatedArticleOuterHorizontalPadding).isActive = true;
            relatedArticleLabel.heightAnchor.constraint(equalToConstant: relatedArticleLabelHeight).isActive = true;
            
            //relatedArticleLabel.backgroundColor = .systemGreen;
            relatedArticleLabel.textAlignment = .left;
            relatedArticleLabel.textColor = InverseBackgroundColor;
            relatedArticleLabel.font = UIFont(name: SFProDisplay_Bold, size: relatedArticleLabelHeight * 0.4);
            relatedArticleLabel.numberOfLines = 2;
            
            /*
            
            let relatedArticleImageViewFrame = CGRect(x: 0, y: 0, width: relatedArticleView.frame.width / 3, height: relatedArticleView.frame.height);
            let relatedArticleImageView = UIImageView(frame: relatedArticleImageViewFrame);
            
            relatedArticleImageView.layer.cornerRadius = relatedArticleImageView.frame.height / 4;
            relatedArticleImageView.backgroundColor = .systemRed;
            
            relatedArticleView.addSubview(relatedArticleImageView);
            
            //
            
            let relatedArticleLabelFrame = CGRect(x: relatedArticleImageView.frame.width + relatedArticleContentHorizontalPadding, y: 0, width: relatedArticleView.frame.width - relatedArticleContentHorizontalPadding - relatedArticleImageView.frame.width, height: relatedArticleView.frame.height * 0.7);
            let relatedArticleLabel = UILabel(frame: relatedArticleLabelFrame);
            
            relatedArticleLabel.backgroundColor = .systemGreen;
            relatedArticleLabel.textAlignment = .left;
            relatedArticleLabel.textColor = InverseBackgroundColor;
            relatedArticleLabel.font = UIFont(name: SFProDisplay_Bold, size: relatedArticleLabel.frame.height * 0.4);
            relatedArticleLabel.numberOfLines = 0;
            
            relatedArticleView.addSubview(relatedArticleLabel);
            
            */
            
            /*let relatedArticleAttributesViewFrame = CGRect(x: relatedArticleImageView.frame.width + relatedArticleContentHorizontalPadding, y: relatedArticleLabel.frame.height + relatedArticleContentVerticalPadding, width: relatedArticleLabel.frame.width, height: relatedArticleView.frame.height - relatedArticleLabel.frame.height - relatedArticleContentVerticalPadding);
            let relatedArticleAttributesView = UIView(frame: relatedArticleAttributesViewFrame);
            relatedArticleAttributesView.clipsToBounds = true;*/
            
            let relatedArticleAttributesView = UIView();
            
            relatedArticleView.addSubview(relatedArticleAttributesView);
            
            relatedArticleAttributesView.translatesAutoresizingMaskIntoConstraints = false;
            
            let relatedArticleViewAttributesHeight = relatedArticleView.frame.height - relatedArticleLabelHeight - 3*relatedArticleOuterVerticalPadding;
            relatedArticleAttributesView.leadingAnchor.constraint(equalTo: relatedArticleImageView.trailingAnchor, constant: relatedArticleContentHorizontalPadding).isActive = true;
            relatedArticleAttributesView.topAnchor.constraint(equalTo: relatedArticleLabel.bottomAnchor, constant: relatedArticleContentVerticalPadding).isActive = true;
            relatedArticleAttributesView.heightAnchor.constraint(equalToConstant: relatedArticleViewAttributesHeight).isActive = true;
            relatedArticleAttributesView.trailingAnchor.constraint(equalTo: relatedArticleView.trailingAnchor, constant: relatedArticleOuterHorizontalPadding).isActive = true;
            
            ///
            
            let relatedArticleCategoryView = UIView();
            
            relatedArticleAttributesView.addSubview(relatedArticleCategoryView);
            
            relatedArticleCategoryView.translatesAutoresizingMaskIntoConstraints = false;

            let relatedArticleCategoryViewHeight = relatedArticleViewAttributesHeight;
            relatedArticleCategoryView.topAnchor.constraint(equalTo: relatedArticleAttributesView.topAnchor).isActive = true;
            relatedArticleCategoryView.heightAnchor.constraint(equalToConstant: relatedArticleCategoryViewHeight).isActive = true;
            relatedArticleCategoryView.leadingAnchor.constraint(equalTo: relatedArticleAttributesView.leadingAnchor).isActive = true;
            relatedArticleCategoryView.widthAnchor.constraint(equalToConstant: relatedArticleCategoryViewHeight * 0.4).isActive = true;
            
            relatedArticleCategoryView.backgroundColor = .systemYellow;
            
            ///
            
            let relatedArticleCategoryLabel = UILabel();
            
            relatedArticleAttributesView.addSubview(relatedArticleCategoryLabel);
            
            relatedArticleCategoryLabel.translatesAutoresizingMaskIntoConstraints = false;
            
            let relatedArticleCategoryLabelHeight = relatedArticleViewAttributesHeight;
            relatedArticleCategoryLabel.leadingAnchor.constraint(equalTo: relatedArticleCategoryView.trailingAnchor, constant: relatedArticleContentHorizontalPadding).isActive = true;
            relatedArticleCategoryLabel.topAnchor.constraint(equalTo: relatedArticleAttributesView.topAnchor).isActive = true;
            relatedArticleCategoryLabel.heightAnchor.constraint(equalToConstant: relatedArticleCategoryLabelHeight).isActive = true;
            
            relatedArticleCategoryLabel.textAlignment = .left;
            relatedArticleCategoryLabel.font = UIFont(name: SFProDisplay_Semibold, size: relatedArticleCategoryLabelHeight * 0.8);
            relatedArticleCategoryLabel.numberOfLines = 1;
            
            ///
            
            let relatedArticleTimestampLabel = UILabel();
            
            relatedArticleAttributesView.addSubview(relatedArticleTimestampLabel);
            
            relatedArticleTimestampLabel.translatesAutoresizingMaskIntoConstraints = false;
            
            relatedArticleTimestampLabel.leadingAnchor.constraint(equalTo: relatedArticleCategoryLabel.trailingAnchor, constant: relatedArticleContentHorizontalPadding).isActive = true;
            relatedArticleTimestampLabel.topAnchor.constraint(equalTo: relatedArticleAttributesView.topAnchor).isActive = true;
            relatedArticleTimestampLabel.bottomAnchor.constraint(equalTo: relatedArticleAttributesView.bottomAnchor).isActive = true;
            
            let relatedArticleTimestampLabelTrailingConstraint = relatedArticleTimestampLabel.trailingAnchor.constraint(equalTo: relatedArticleAttributesView.trailingAnchor);
            relatedArticleTimestampLabelTrailingConstraint.isActive = true;
            relatedArticleTimestampLabelTrailingConstraint.priority = UILayoutPriority(250);
            
            relatedArticleTimestampLabel.textAlignment = .left;
            relatedArticleTimestampLabel.textColor = BackgroundGrayColor;
            relatedArticleTimestampLabel.numberOfLines = 1;
            relatedArticleTimestampLabel.font = UIFont(name: SFProDisplay_Regular, size: relatedArticleViewAttributesHeight * 0.8);
            
            ///
            
            dataManager.getBaseArticleData(relatedArticleID, completion: { [self] (relatedArticleData) in
                
                if (relatedArticleData.isValid){
                    
                    if (relatedArticleData.thumbURLs.count > 0){
                        relatedArticleImageViewWidthConstraint.constant = relatedArticleView.frame.width / 3;
                        relatedArticleImageView.setImageURL(relatedArticleData.thumbURLs[0]);
                    }
                    
                    relatedArticleLabel.text = relatedArticleData.title;
                    
                    relatedArticleTimestampLabel.text = timestampLabelTextPrefix + timeManager.epochToDiffString(relatedArticleData.timestamp);
                    
                    if (!relatedArticleData.categoryID.isEmpty){
                        
                        dataManager.getCategoryData(relatedArticleData.categoryID, completion: { (relatedArticleCategoryData) in
                            
                            relatedArticleCategoryView.backgroundColor = relatedArticleCategoryData.color;
                            
                            relatedArticleCategoryLabel.text = relatedArticleCategoryData.title;
                            relatedArticleCategoryLabel.textColor = relatedArticleCategoryData.color;
                            
                        });
                        
                    }
                    
                    
                    relatedArticleView.frame = CGRect(x: relatedArticleView.frame.minX, y: nextContentY, width: relatedArticleView.frame.width, height: relatedArticleView.frame.height);
                    
                    relatedArticleView.tag = 1;
                    self.nextContentY += relatedArticleView.frame.height + verticalPadding;
                    self.scrollView.addSubview(relatedArticleView);
                    
                    articleViewLabel.frame = CGRect(x: articleViewLabel.frame.minX, y: nextContentY + verticalPadding, width: articleViewLabel.frame.width, height: articleViewLabel.frame.height);
                    
                    scrollView.contentSize = CGSize(width: self.view.frame.width, height: nextContentY + 2*verticalPadding + articleViewLabel.frame.height);
                    
                }
                
            });
            
            //
            
        }
    
        //
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: nextContentY + 2*verticalPadding + articleViewLabel.frame.height);
        
        //
        
        dataManager.getCategoryData(articleData.baseData.categoryID, completion: { (categorydata) in
            
            self.topBarCategoryButtonLabel.setAttributedTitle(self.generateTopBarTitleText(categorydata.title), for: .normal);
            
            //
            
            categoryButton.setAttributedTitle(self.generateCategoryButtonTitle(categorydata.title, categoryButton.frame.height), for: .normal);
            
        });
        
    }
    
    
    
}

extension articlePageViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let articleData = articledata else {
            return 0;
        }
        
        return articleData.imageURLs.count + articleData.videoIDs.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let articleData = articledata else{
            return UICollectionViewCell();
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mediaCollectionViewCell.identifier, for: indexPath) as! mediaCollectionViewCell;
        let index = indexPath.row;
        
        if (index < articleData.imageURLs.count + articleData.videoIDs.count){
            if (index < articleData.videoIDs.count){
                cell.loadVideo(articleData.videoIDs[index]);
            }
            else{
                cell.loadImage(articleData.imageURLs[index - articleData.videoIDs.count]);
            }
        }
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let articleData = articledata else{
            return;
        }
        
        let index = indexPath.row;
        
        if (index < articleData.imageURLs.count + articleData.videoIDs.count && index >= articleData.videoIDs.count){

            let imageVC = zoomableImageViewController();
            
            let image : UIImage? = (collectionView.cellForItem(at: indexPath) as! mediaCollectionViewCell).imageView.image;
            if (image != nil){
                imageVC.image = image!;
                self.openChildPage(imageVC);
            }
            
        }
        
    }
    
}
