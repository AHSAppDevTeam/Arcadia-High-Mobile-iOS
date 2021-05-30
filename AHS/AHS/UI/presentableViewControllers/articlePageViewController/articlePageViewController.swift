//
//  articlePageViewController.swift
//  AHS
//
//  Created by Richard Wei on 5/25/21.
//

import Foundation
import UIKit
import UPCarouselFlowLayout

class articlePageViewController : presentableViewController{
    
    public var articleID : String = "";
    internal var articledata: fullArticleData = fullArticleData();
    
    internal var nextContentY : CGFloat = 0;
    internal var userInterfaceStyle : UIUserInterfaceStyle = .unspecified;
    
    internal let scrollView : UIScrollView = UIScrollView();
    internal let refreshControl : UIRefreshControl = UIRefreshControl();
    
    internal let topBarCategoryLabel : UILabel = UILabel();
    
    internal let mediaCollectionViewLayout = UPCarouselFlowLayout();
    internal var mediaCollectionView = UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewLayout());
    
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
        
        topBarBackButton.addTarget(self, action: #selector(self.handleBackButton), for: .touchUpInside);
        
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
        
        topBarBookmarkButton.addTarget(self, action: #selector(self.toggleBookmark), for: .touchUpInside);
        
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
        
        let topBarCategoryLabelFrame = CGRect(x: topBarBackButton.frame	.width + topBarHorizontalPadding, y: 0, width: topBarView.frame.width - (topBarBackButton.frame.width + 2*topBarHorizontalPadding + (topBarView.frame.width - topBarFontButton.frame.minX)), height: topBarView.frame.height);
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
        
        articledata = articleData;
        
        dataManager.getCategoryData(articleData.baseData.categoryID, completion: { (categorydata) in
            
            let topBarCategoryLabelFontSize = self.topBarCategoryLabel.frame.height * 0.7;
            let topBarCategoryLabelAttributedText = NSMutableAttributedString(string: categorydata.title, attributes: [NSAttributedString.Key.font : UIFont(name: SFProDisplay_Bold, size: topBarCategoryLabelFontSize)!]);
            topBarCategoryLabelAttributedText.append(NSAttributedString(string: " Section", attributes: [NSAttributedString.Key.font : UIFont(name: SFProDisplay_Regular, size: topBarCategoryLabelFontSize)!]));
            self.topBarCategoryLabel.attributedText = topBarCategoryLabelAttributedText;
            
        });
        
        let horizontalPadding = self.view.frame.width / 20;
        let verticalPadding : CGFloat = 10;
        let contentWidth = self.view.frame.width - 2*horizontalPadding;
        
        nextContentY = verticalPadding;
        
        //
        
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
        mediaCollectionView.backgroundColor = .systemGreen;
        
        mediaCollectionView.tag = 1;
        scrollView.addSubview(mediaCollectionView);
        nextContentY += mediaCollectionView.frame.height + verticalPadding;
        
        //
        
        let titleLabelText = articleData.baseData.title;
        let titleLabelFont = UIFont(name: SFProDisplay_Bold, size: UIScreen.main.scale * 10)!;
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
        
        //
        
        let authorLabelText = articleData.author;
        let authorLabelFont = UIFont(name: SFProDisplay_Regular, size: UIScreen.main.scale * 6)!;
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
        
        //
        
        let bodyLabelFont = UIFont(name: SFProDisplay_Regular, size: UIScreen.main.scale * 6)!;
        let bodyLabelText = htmlFunctions.parseHTML(articleData.body, bodyLabelFont);
        let bodyLabelHeight = bodyLabelText.height(containerWidth: contentWidth);
        let bodyLabelFrame = CGRect(x: horizontalPadding, y: nextContentY, width: contentWidth, height: bodyLabelHeight);
        let bodyLabel = UITextView(frame: bodyLabelFrame);
        
        bodyLabel.attributedText = bodyLabelText;
        bodyLabel.font = bodyLabelFont;
        bodyLabel.textAlignment = .left;
        bodyLabel.textColor = BackgroundGrayColor;
        bodyLabel.isEditable = false;
        bodyLabel.isScrollEnabled = false;
        bodyLabel.tintColor = .systemBlue;
        bodyLabel.backgroundColor = .clear;
        
        bodyLabel.tag = 1;
        scrollView.addSubview(bodyLabel);
        nextContentY += bodyLabel.frame.height + verticalPadding;
        
        //
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: nextContentY);
        
    }
    
    
    
}

extension articlePageViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell();
    }
    
    
}
