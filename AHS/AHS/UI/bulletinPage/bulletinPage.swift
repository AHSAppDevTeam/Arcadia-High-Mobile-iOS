//
//  bulletinPage.swift
//  AHS
//
//  Created by Richard Wei on 3/14/21.
//

import Foundation
import UIKit

class bulletinPageViewController : mainPageViewController{
    
    init(){
        super.init(nibName: nil, bundle: nil);
        self.pageName = "Student";
        self.secondaryPageName = "Bulletin";
        self.viewControllerIconName = "doc.plaintext.fill";
    }
    
    required init?(coder: NSCoder) { // required uiviewcontroller init
        super.init(coder: coder);
    }
    
    //
    
    internal let comingUpMaxArticleCount : Int = 4;
    
    internal let mainScrollView : UIButtonScrollView = UIButtonScrollView();
    internal let verticalPadding : CGFloat = 5;
    internal let horizontalPadding : CGFloat = 10;
    
    internal let refreshControl : UIRefreshControl = UIRefreshControl();

    internal let categoryScrollView : UIButtonScrollView  = UIButtonScrollView();
    internal var categoryScrollViewNextContentX : CGFloat = 0;
    
    internal var contentViewWidth : CGFloat = 0;
    
    internal let comingUpLabelColor : UIColor = UIColor.init(hex: "#d8853d");
    internal let comingUpLabel : UILabel = UILabel();
    internal let comingUpContentView : UIView = UIView();
    
    internal let bulletinContentView : UIView = UIView();
    
    internal var bulletinCategoryDictionary : [String : Bool] = [:];
    internal var bulletinArticleIDList : [String] = [];
    
    //
    
    override func viewDidLoad() {
        super.viewDidLoad();
        contentViewWidth = AppUtility.getCurrentScreenSize().width - 2*horizontalPadding;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        if (!self.hasBeenSetup){
            self.view.backgroundColor = BackgroundColor;
            
            //
            
            mainScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height);
            mainScrollView.alwaysBounceVertical = true;
            self.view.addSubview(mainScrollView);
            
            mainScrollView.addSubview(refreshControl);
            refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged);
            
            renderLayout();
            reset();
            loadBulletinData();
            
            self.hasBeenSetup = true;
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.resetContentOffset), name: NSNotification.Name(rawValue: setScrollViewZeroContentOffset), object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.endRefreshing) ,name: NSNotification.Name(rawValue: endDataManagerRefreshing), object: nil);
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: setScrollViewZeroContentOffset), object: nil);
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: endDataManagerRefreshing), object: nil);
    }
    
    internal func renderLayout(){
        
        //
        
        let categoryScrollViewWidth = mainScrollView.frame.width;
        let categoryScrollViewHeight = categoryScrollViewWidth * 0.26;
    
        mainScrollView.addSubview(categoryScrollView);
        categoryScrollView.translatesAutoresizingMaskIntoConstraints = false;
        
        categoryScrollView.topAnchor.constraint(equalTo: mainScrollView.topAnchor).isActive = true;
        categoryScrollView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor).isActive = true;
        categoryScrollView.widthAnchor.constraint(equalToConstant: categoryScrollViewWidth).isActive = true;
        categoryScrollView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor).isActive = true;
        categoryScrollView.heightAnchor.constraint(equalToConstant: categoryScrollViewHeight).isActive = true;
        
        //categoryScrollView.backgroundColor = .systemRed;
        categoryScrollView.showsHorizontalScrollIndicator = false;
        categoryScrollView.canCancelContentTouches = true;
        
        //
        
        mainScrollView.addSubview(comingUpLabel);
        comingUpLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        let comingUpLabelWidth = mainScrollView.frame.width;
        let comingUpLabelHeight = comingUpLabelWidth * 0.13;
        
        comingUpLabel.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor, constant: horizontalPadding).isActive = true;
        comingUpLabel.topAnchor.constraint(equalTo: categoryScrollView.bottomAnchor, constant: verticalPadding).isActive = true;
        comingUpLabel.trailingAnchor.constraint(equalTo: categoryScrollView.trailingAnchor, constant: -horizontalPadding).isActive = true;
        comingUpLabel.heightAnchor.constraint(equalToConstant: comingUpLabelHeight).isActive = true;
        
        
        let comingUpAttributedText = NSMutableAttributedString(string: "Coming ", attributes: [NSAttributedString.Key.font : UIFont(name: SFProDisplay_Bold, size: comingUpLabelHeight * 0.5)!]);
        comingUpAttributedText.append(NSAttributedString(string: "Up", attributes: [NSAttributedString.Key.font : UIFont(name: SFProDisplay_Regular, size: comingUpLabelHeight * 0.5)!]));
        
        comingUpLabel.attributedText = comingUpAttributedText;
        comingUpLabel.textColor = comingUpLabelColor;
        comingUpLabel.textAlignment = .left;
    
        //comingUpLabel.backgroundColor = .systemBlue;
        
        //
        
        mainScrollView.addSubview(comingUpContentView);
        comingUpContentView.translatesAutoresizingMaskIntoConstraints = false;
        
        comingUpContentView.topAnchor.constraint(equalTo: comingUpLabel.bottomAnchor, constant: verticalPadding).isActive = true;
        comingUpContentView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor, constant: horizontalPadding).isActive = true;
        comingUpContentView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor, constant: -horizontalPadding).isActive = true;
        
        //comingUpContentViewHeightConstraint = comingUpContentView.heightAnchor.constraint(equalToConstant: 0);
        //comingUpContentViewHeightConstraint.isActive = true;
        
        //
        
        mainScrollView.addSubview(bulletinContentView);
        bulletinContentView.translatesAutoresizingMaskIntoConstraints = false;
        
        bulletinContentView.topAnchor.constraint(equalTo: comingUpContentView.bottomAnchor, constant: verticalPadding).isActive = true;
        bulletinContentView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor, constant: horizontalPadding).isActive = true;
        bulletinContentView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor, constant: -horizontalPadding).isActive = true;
        
        bulletinContentView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor, constant: -verticalPadding).isActive = true;
        
        
    }
    
    internal func reset(){
        
        resetArticleParser();
        
        categoryScrollViewNextContentX = horizontalPadding;
        
        for subview in categoryScrollView.subviews{
            subview.removeFromSuperview();
        }
        
        //
        
        for subview in comingUpContentView.subviews{
            subview.removeFromSuperview();
        }
        
        //
        
        for subview in bulletinContentView.subviews{
            subview.removeFromSuperview();
        }
        
    }
    
    internal func loadBulletinData(){
        
        self.refreshControl.beginRefreshing();
        
        dataManager.getBulletinLocationData(completion: { (locationdata) in
            
            DispatchQueue.global(qos: .background).async {
                
                let dispatchGroup = DispatchGroup();
                
                for categoryID in locationdata.categoryIDs{
                    
                    dispatchGroup.enter();
                    
                    DispatchQueue.main.async {
                        
                        dataManager.getCategoryData(categoryID, completion: { (categorydata) in
                            
                            self.renderCategory(categorydata);
                            self.appendCategory(categorydata.categoryID, categorydata.articleIDs);
                            
                            dispatchGroup.leave();
                            
                        });
                        
                    }
                    
                }
                
                dispatchGroup.wait();
                
                DispatchQueue.main.async {
                    
                    dataManager.loadBulletinArticleList(self.bulletinArticleIDList, completion: { () in
                        
                        self.refreshControl.endRefreshing();
                        self.updateArticleList();
                        
                    });
                    
                }
                
            }
            
        });
        
    }
    
    internal func renderCategory(_ categorydata: categoryData){
        
        let categoryViewFrame = CGRect(x: categoryScrollViewNextContentX, y: 0, width: categoryScrollView.frame.height * 0.78, height: categoryScrollView.frame.height);
        let categoryView = CategoryButton(frame: categoryViewFrame);
        
        categoryView.categoryID = categorydata.categoryID;
        categoryView.categoryAccentColor = categorydata.color;
        
        let isCategoryViewSelected = bulletinCategoryDictionary[categorydata.categoryID] ?? false;
        let primaryColor : UIColor = isCategoryViewSelected ? BackgroundColor : categoryView.categoryAccentColor;
        let secondaryColor : UIColor = isCategoryViewSelected ? categoryView.categoryAccentColor : BackgroundColor;
        
        categoryView.layer.cornerRadius = categoryView.frame.height / 10;
        categoryView.layer.borderColor = categorydata.color.cgColor;
        categoryView.layer.borderWidth = 3;
        //categoryView.isUserInteractionEnabled = false;
        categoryView.backgroundColor = secondaryColor;
        
        //
        
        let categoryImageViewPadding = categoryView.frame.width / 5;
        let categoryImageViewSize = categoryView.frame.width - 2*categoryImageViewPadding;
        let categoryImageViewFrame = CGRect(x: categoryImageViewPadding, y: categoryImageViewPadding, width: categoryImageViewSize, height: categoryImageViewSize);
        let categoryImageView = UIImageView(frame: categoryImageViewFrame);
        
        categoryImageView.isUserInteractionEnabled = false;
        categoryImageView.contentMode = .scaleAspectFit;
        categoryImageView.sd_setImage(with: URL(string: categorydata.iconURL), completed: { (image, error, type, url) in
            if error == nil {
                categoryImageView.image = image?.withRenderingMode(.alwaysTemplate);
                categoryImageView.tintColor = primaryColor;
            }
        });
        
        categoryImageView.tag = -1;
        categoryView.addSubview(categoryImageView);
        
        //
        
        let categoryLabelHorizontalPadding : CGFloat = categoryView.frame.width / 10;
        let categoryLabelFrame = CGRect(x: categoryLabelHorizontalPadding, y: categoryImageView.frame.maxY + categoryImageViewPadding, width: categoryView.frame.width - 2*categoryLabelHorizontalPadding, height: categoryView.frame.height - (categoryImageView.frame.maxY + categoryImageViewPadding + (categoryImageViewPadding / 2)));
        let categoryLabel = UILabel(frame: categoryLabelFrame);
        
        //categoryLabel.backgroundColor = .systemRed;
        categoryLabel.isUserInteractionEnabled = false;
        categoryLabel.textColor = primaryColor;
        categoryLabel.text = categorydata.title;
        categoryLabel.textAlignment = .center;
        categoryLabel.font = UIFont(name: SFProDisplay_Semibold, size: categoryLabel.frame.height * 0.8);
        categoryLabel.adjustsFontSizeToFitWidth = true;
        
        categoryLabel.tag = 1;
        categoryView.addSubview(categoryLabel);
        
        //
        
        categoryView.addTarget(self, action: #selector(self.handleCategoryButton), for: .touchUpInside);
        categoryView.isSelected = bulletinCategoryDictionary[categorydata.categoryID] ?? false;
        
        //updateCategoryButton(categoryView);
        
        categoryScrollView.addSubview(categoryView);
        categoryScrollViewNextContentX += categoryView.frame.width + horizontalPadding;
        
        categoryScrollView.contentSize = CGSize(width: categoryScrollViewNextContentX, height: categoryScrollView.frame.height);
        
    }
    
    // these functions will be called by the article parser

    internal func renderComingUp(_ articleIDs: [String]){
        for subview in comingUpContentView.subviews{
            subview.removeFromSuperview();
        }
        
        //
        
        let comingUpContentVerticalPadding = verticalPadding * 2;
        var nextVerticalPadding : CGFloat = 0;
        //comingUpContentView.backgroundColor = .systemRed;
        
        var nextTopAnchorConstraint = comingUpContentView.topAnchor;
        
        for i in 0..<articleIDs.count{
            
            let articleView = ArticleButton();
            
            articleView.articleID = articleIDs[i];
            articleView.addTarget(self, action: #selector(self.handleArticleClick), for: .touchUpInside);
            
            articleView.translatesAutoresizingMaskIntoConstraints = false;
            
            comingUpContentView.addSubview(articleView);
            
            articleView.leadingAnchor.constraint(equalTo: comingUpContentView.leadingAnchor).isActive = true;
            articleView.trailingAnchor.constraint(equalTo: comingUpContentView.trailingAnchor).isActive = true;
            articleView.widthAnchor.constraint(equalToConstant: contentViewWidth).isActive = true;
            articleView.topAnchor.constraint(equalTo: nextTopAnchorConstraint, constant: nextVerticalPadding).isActive = true;
            
            let articleViewHeight = contentViewWidth * 0.26;
            articleView.heightAnchor.constraint(equalToConstant: articleViewHeight).isActive = true;
            
            //
            
            //articleView.backgroundColor = .systemBlue;
            renderComingUpArticleView(articleView, CGSize(width: contentViewWidth, height: articleViewHeight), articleIDs[i], i+1);
            
            //
            
            nextTopAnchorConstraint = articleView.bottomAnchor;
            nextVerticalPadding = comingUpContentVerticalPadding;
        }

        nextTopAnchorConstraint.constraint(equalTo: comingUpContentView.bottomAnchor, constant: -verticalPadding).isActive = true;
        
    }
    
    internal func renderComingUpArticleView(_ articleView: UIView, _ articleViewSize: CGSize, _ articleID: String, _ articleNumber: Int){
        
        let articleContentHorizontalPadding : CGFloat = 1.5*horizontalPadding;
        let articleContentVerticalPadding : CGFloat = verticalPadding;
        
        //
        
        let categoryColorViewHeight = articleViewSize.height;
        let categoryColorViewWidth = categoryColorViewHeight * 0.06;
        let categoryColorViewFrame = CGRect(x: articleViewSize.width - categoryColorViewWidth, y: 0, width: categoryColorViewWidth, height: categoryColorViewHeight);
        let categoryColorView = UIView(frame: categoryColorViewFrame);
        
        categoryColorView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner];
        categoryColorView.layer.cornerRadius = categoryColorViewWidth;
        
        categoryColorView.backgroundColor = BackgroundGrayColor;
        
        articleView.addSubview(categoryColorView);
        
        //
        let articleNumberLabelVerticalPadding = 4*articleContentVerticalPadding;
        let articleNumberLabelSize = articleViewSize.height - 2*articleNumberLabelVerticalPadding;
        
        let articleNumberLabelFrame = CGRect(x: 0, y: articleNumberLabelVerticalPadding, width: articleNumberLabelSize, height: articleNumberLabelSize);
        let articleNumberLabel = UILabel(frame: articleNumberLabelFrame);
        
        articleNumberLabel.layer.cornerRadius = articleNumberLabelSize / 2;
        articleNumberLabel.clipsToBounds = true;
        articleNumberLabel.layer.borderWidth = 1;
        articleNumberLabel.layer.borderColor = comingUpLabelColor.cgColor;
        
        articleNumberLabel.text = String(articleNumber);
        articleNumberLabel.textAlignment = .center;
        articleNumberLabel.font = UIFont(name: SFProDisplay_Bold, size: articleNumberLabelSize * 0.7);
        articleNumberLabel.textColor = comingUpLabelColor;
        
        //articleNumberLabel.backgroundColor = .systemRed;
        
        articleView.addSubview(articleNumberLabel);
        
        //
        
        let articleContentWidth = articleViewSize.width - 2*articleContentHorizontalPadding - articleNumberLabelSize - categoryColorView.frame.width;
        
        //
        
        let articleMiscViewHeight = articleViewSize.height * 0.18;
        let articleMiscViewFrame = CGRect(x: articleNumberLabelSize + articleContentHorizontalPadding, y: articleViewSize.height - articleContentVerticalPadding - articleMiscViewHeight, width: articleContentWidth, height: articleMiscViewHeight);
        let articleMiscView = UIView(frame: articleMiscViewFrame);
        
        articleMiscView.isUserInteractionEnabled = false;
        
        ///
        
        let articleCategoryInnerViewHeight = articleMiscView.frame.height;
        let articleCategoryInnerViewWidth = articleCategoryInnerViewHeight * 0.45;
        let articleCategoryInnerViewFrame = CGRect(x: 0, y: 0, width: articleCategoryInnerViewWidth, height: articleCategoryInnerViewHeight);
        let articleCategoryInnerView = UIView(frame: articleCategoryInnerViewFrame);
        
        articleCategoryInnerView.backgroundColor = BackgroundGrayColor;
        
        articleMiscView.addSubview(articleCategoryInnerView);
        
        ///
        
        let articleTimestampLabelHorizontalPadding : CGFloat = horizontalPadding;
        let articleTimestampLabelFrame = CGRect(x: articleCategoryInnerView.frame.width + articleTimestampLabelHorizontalPadding, y: 0, width: articleMiscView.frame.width - articleCategoryInnerView.frame.width - articleTimestampLabelHorizontalPadding, height: articleMiscView.frame.height);
        let articleTimestampLabel = UILabel(frame: articleTimestampLabelFrame);
        
        articleTimestampLabel.textAlignment = .left;
        articleTimestampLabel.textColor = BackgroundGrayColor;
        articleTimestampLabel.numberOfLines = 1;
        articleTimestampLabel.font = UIFont(name: SFProDisplay_Regular, size: articleTimestampLabel.frame.height * 0.7);
        
        articleMiscView.addSubview(articleTimestampLabel);
        
        ///
        
        articleView.addSubview(articleMiscView);
        
        //
        
        let articleTitleLabelFrame = CGRect(x: articleNumberLabelSize + articleContentHorizontalPadding, y: articleContentVerticalPadding, width: articleContentWidth, height: articleViewSize.height - 3*articleContentVerticalPadding - articleMiscView.frame.height);
        let articleTitleLabel = UILabel(frame: articleTitleLabelFrame);
        
        articleTitleLabel.textAlignment = .left;
        articleTitleLabel.textColor = InverseBackgroundColor;
        articleTitleLabel.numberOfLines = 2;
        articleTitleLabel.font = UIFont(name: SFProDisplay_Semibold, size: articleTitleLabel.frame.height * 0.35);
        
        articleView.addSubview(articleTitleLabel);
        
        //
        
        dataManager.getBaseArticleData(articleID, completion: { (articledata) in
            
            dataManager.getCategoryData(articledata.categoryID, completion: { (categorydata) in
                
                categoryColorView.backgroundColor = categorydata.color;
                articleCategoryInnerView.backgroundColor = categorydata.color;
                
            });
            
            articleTitleLabel.text = articledata.title;
            
            //
            
            articleTimestampLabel.text = timeManager.epochToDiffString(articledata.timestamp);
            
        });
    }
    
    //
    
    internal func renderArticleList(_ articleIDs: [String]){
        for subview in bulletinContentView.subviews{
            subview.removeFromSuperview();
        }
        
        let articleListVerticalPadding = verticalPadding * 2;
        
        if (articleIDs.count > 0){
            
            var nextTopAnchorConstraint = bulletinContentView.topAnchor;
            
            for articleID in articleIDs{
                
                let articleView = ArticleButton();
                
                articleView.articleID = articleID;
                articleView.addTarget(self, action: #selector(self.handleArticleClick), for: .touchUpInside);
                
                articleView.translatesAutoresizingMaskIntoConstraints = false;
                
                bulletinContentView.addSubview(articleView);
                
                articleView.leadingAnchor.constraint(equalTo: bulletinContentView.leadingAnchor).isActive = true;
                articleView.trailingAnchor.constraint(equalTo: bulletinContentView.trailingAnchor).isActive = true;
                articleView.widthAnchor.constraint(equalToConstant: contentViewWidth).isActive = true;
                articleView.topAnchor.constraint(equalTo: nextTopAnchorConstraint, constant: articleListVerticalPadding).isActive = true;
                
                let articleViewHeight = contentViewWidth * 0.26;
                articleView.heightAnchor.constraint(equalToConstant: articleViewHeight).isActive = true;
                
                //
                
                articleView.layer.cornerRadius = articleViewHeight * 0.06;
                //articleView.backgroundColor = .systemRed;
                articleView.clipsToBounds = true;
                
                renderBulletinArticle(articleView, CGSize(width: contentViewWidth, height: articleViewHeight), articleID);
                
                //
                
                nextTopAnchorConstraint = articleView.bottomAnchor;
                
            }
            
            nextTopAnchorConstraint.constraint(equalTo: bulletinContentView.bottomAnchor, constant: -articleListVerticalPadding).isActive = true;
            
        }
        
    }
    
    internal func renderBulletinArticle(_ articleView: UIView, _ articleViewSize: CGSize, _ articleID: String){
        
        let articleContentHorizontalPadding : CGFloat = horizontalPadding;
        let articleContentVerticalPadding : CGFloat = verticalPadding;
        
        //
        
        let categoryColorViewHeight = articleViewSize.height;
        let categoryColorViewWidth = categoryColorViewHeight * 0.06;
        let categoryColorViewFrame = CGRect(x: 0, y: 0, width: categoryColorViewWidth, height: categoryColorViewHeight);
        let categoryColorView = UIView(frame: categoryColorViewFrame);
        
        categoryColorView.backgroundColor = BackgroundGrayColor;
        
        articleView.addSubview(categoryColorView);
        
        //
        
        let articleMiscDataViewHeight = articleViewSize.height * 0.18;
        let articleMiscDataViewFrame = CGRect(x: categoryColorViewWidth + articleContentHorizontalPadding, y: articleViewSize.height - articleContentVerticalPadding - articleMiscDataViewHeight, width: articleViewSize.width - (categoryColorViewWidth + 2*articleContentHorizontalPadding), height: articleMiscDataViewHeight);
        let articleMiscDataView = UIView(frame: articleMiscDataViewFrame);
        
        articleMiscDataView.isUserInteractionEnabled = false;
        
        //articleMiscDataView.backgroundColor = .systemPink;
        
        ///
        
        let articleCategoryLabel = UILabel();
        
        articleMiscDataView.addSubview(articleCategoryLabel);
        
        articleCategoryLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        articleCategoryLabel.leadingAnchor.constraint(equalTo: articleMiscDataView.leadingAnchor).isActive = true;
        articleCategoryLabel.topAnchor.constraint(equalTo: articleMiscDataView.topAnchor).isActive = true;
        articleCategoryLabel.bottomAnchor.constraint(equalTo: articleMiscDataView.bottomAnchor).isActive = true;
        
        articleCategoryLabel.textAlignment = .left;
        articleCategoryLabel.numberOfLines = 1;
        
        //
        
        let articleCategoryInnerColorView = UIView();
        
        articleMiscDataView.addSubview(articleCategoryInnerColorView);
        
        articleCategoryInnerColorView.translatesAutoresizingMaskIntoConstraints = false;
        
        let articleCategoryInnerColorHeight = articleMiscDataView.frame.height;
        let articleCategoryInnerColorWidth = articleCategoryInnerColorHeight * 0.45;
        
        articleCategoryInnerColorView.leadingAnchor.constraint(equalTo: articleCategoryLabel.trailingAnchor, constant: articleContentHorizontalPadding).isActive = true;
        articleCategoryInnerColorView.topAnchor.constraint(equalTo: articleMiscDataView.topAnchor).isActive = true;
        articleCategoryInnerColorView.bottomAnchor.constraint(equalTo: articleMiscDataView.bottomAnchor).isActive = true;
        articleCategoryInnerColorView.heightAnchor.constraint(equalToConstant: articleCategoryInnerColorHeight).isActive = true;
        articleCategoryInnerColorView.widthAnchor.constraint(equalToConstant: articleCategoryInnerColorWidth).isActive = true;
        
        articleCategoryInnerColorView.backgroundColor = BackgroundGrayColor;
        
        //
        
        let articleTimestampLabel = UILabel();
        
        articleTimestampLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        articleMiscDataView.addSubview(articleTimestampLabel);
        
        articleTimestampLabel.leadingAnchor.constraint(equalTo: articleCategoryInnerColorView.trailingAnchor, constant: articleContentHorizontalPadding).isActive = true;
        articleTimestampLabel.topAnchor.constraint(equalTo: articleMiscDataView.topAnchor).isActive = true;
        articleTimestampLabel.bottomAnchor.constraint(equalTo: articleMiscDataView.bottomAnchor).isActive = true;
        articleTimestampLabel.trailingAnchor.constraint(lessThanOrEqualTo: articleMiscDataView.trailingAnchor, constant: articleContentHorizontalPadding).isActive = true;
        
        articleTimestampLabel.textAlignment = .left;
        articleTimestampLabel.numberOfLines = 1;
        articleTimestampLabel.font = UIFont(name: SFProDisplay_Regular, size: articleMiscDataView.frame.height * 0.7);
        articleTimestampLabel.textColor = BackgroundGrayColor;
        
        ///
        
        articleView.addSubview(articleMiscDataView);
        
        //
        
        let articleTitleLabelFrame = CGRect(x: categoryColorViewWidth + articleContentHorizontalPadding, y: articleContentVerticalPadding, width: articleViewSize.width - (categoryColorViewWidth + 2*articleContentHorizontalPadding), height: articleViewSize.height - articleMiscDataView.frame.height - 2*verticalPadding);
        let articleTitleLabel = UILabel(frame: articleTitleLabelFrame);
        
        articleTitleLabel.font = UIFont(name: SFProDisplay_Semibold, size: articleTitleLabel.frame.height * 0.35);
        articleTitleLabel.textAlignment = .left;
        articleTitleLabel.textColor = InverseBackgroundColor;
        articleTitleLabel.numberOfLines = 2;
        
        articleView.addSubview(articleTitleLabel);
        
        //
        
        dataManager.getBaseArticleData(articleID, completion: { (articledata) in
            
            dataManager.getCategoryData(articledata.categoryID, completion: { (categorydata) in
                
                categoryColorView.backgroundColor = categorydata.color;
                articleCategoryInnerColorView.backgroundColor = categorydata.color;
                
                let categoryMutableAttributedStringFontSize = articleMiscDataView.frame.height * 0.7;
                let categoryMutableAttributedString = NSMutableAttributedString(string: categorydata.title, attributes: [NSAttributedString.Key.font : UIFont(name: SFProDisplay_Bold, size: categoryMutableAttributedStringFontSize)!]);
                categoryMutableAttributedString.append(NSAttributedString(string: " Section", attributes: [NSAttributedString.Key.font : UIFont(name: SFProDisplay_Regular, size: categoryMutableAttributedStringFontSize)!]));
                
                articleCategoryLabel.attributedText = categoryMutableAttributedString;
                
            });
            
            //
            
            articleTitleLabel.text = articledata.title;
            
            articleTimestampLabel.text = timeManager.epochToDiffString(articledata.timestamp);
            
        });
        
    }
    
}

