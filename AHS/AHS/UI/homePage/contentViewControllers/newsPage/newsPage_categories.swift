//
//  newsPage_categories.swift
//  AHS
//
//  Created by Richard Wei on 4/9/21.
//

import Foundation
import UIKit

extension newsPageController{
    internal func loadCategories(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: homePageBeginRefreshing), object: nil);
        dataManager.getHomepageLocationData(completion: { (location) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: homePageEndRefreshing), object: nil);
            for categoryID in location.categoryIDs{
                if (categoryID != "Featured"){
                    dataManager.getCategoryData(categoryID, completion: { (category) in
                        self.renderCategory(category);
                    });
                }
            }
        });
    }
    
    internal func reloadCategories(){
        for view in self.view.subviews{
            if (view.tag == 1){
                view.removeFromSuperview();
            }
        }
        
        categoryParentViews = [];
        categoryScrollViewPageControlViews = [];
        
        updateParentHeightConstraint();
        
        loadCategories();
    }
    
    internal func renderCategory(_ categorydata: categoryData){
        
        let categoryView = UIView();
        
        self.view.addSubview(categoryView);
        
        categoryView.tag = 1;
        categoryView.translatesAutoresizingMaskIntoConstraints = false;
        
        (categoryParentViews.count == 0 ? categoryView.topAnchor.constraint(equalTo: featuredParentView.bottomAnchor, constant: 2*verticalPadding) : categoryView.topAnchor.constraint(equalTo: categoryParentViews[categoryParentViews.count - 1].bottomAnchor, constant: verticalPadding)).isActive = true;
        
        categoryView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: homePageHorizontalPadding).isActive = true;
        categoryView.widthAnchor.constraint(equalToConstant: AppUtility.getCurrentScreenSize().width - 2*homePageHorizontalPadding).isActive = true;
        
        categoryParentViews.append(categoryView);
        categoryScrollViewPageControlViews.append(UIPageControl());
        
        renderCategoryContent(categorydata, categoryView, categoryParentViews.count - 1);
    }
    
    private func renderCategoryContent(_ categorydata: categoryData, _ categoryView: UIView, _ categoryIndex: Int){
        //categoryView.backgroundColor = .systemRed;
        
        let categoryViewWidth = AppUtility.getCurrentScreenSize().width - 2*homePageHorizontalPadding;
        
        let categoryTitleLabelFontSize = AppUtility.getCurrentScreenSize().width / 15;
        let categoryTitleLabelAttributedString = NSMutableAttributedString(string: categorydata.title, attributes: [.font : UIFont(name: SFProDisplay_Black, size: categoryTitleLabelFontSize)!]);
        categoryTitleLabelAttributedString.append(NSAttributedString(string: " News", attributes: [.font : UIFont(name: SFProDisplay_Bold, size: categoryTitleLabelFontSize)!]));
        
        let categoryTitleLabelWidth = categoryViewWidth;
        let categoryTitleLabelFrame = CGRect(x: 0, y: 0, width: categoryTitleLabelWidth, height: categoryTitleLabelAttributedString.height(containerWidth: categoryTitleLabelWidth));
        let categoryTitleLabel = UILabel(frame: categoryTitleLabelFrame);
        
        categoryTitleLabel.attributedText = categoryTitleLabelAttributedString;
        categoryTitleLabel.textColor = categorydata.color;
        categoryTitleLabel.textAlignment = .left;
        
        categoryView.addSubview(categoryTitleLabel);
        
        //
        
        var articleIDs = categorydata.articleIDs;
        var previousTopView : UIView = categoryView; // for constraining the next view under the previously rendered view
        var previousSecondaryTopView : UIView? = nil; // for the semifeatured section

        if (articleIDs.count > 0){ // top featured
            
            let articleID = articleIDs.removeFirst();
            
            let articleView = ArticleButton();
            
            articleView.articleID = articleID;
            articleView.addTarget(self, action: #selector(self.handleArticleClick), for: .touchUpInside);
            
            categoryView.addSubview(articleView);
            
            articleView.translatesAutoresizingMaskIntoConstraints = false;
            
            articleView.topAnchor.constraint(equalTo: categoryTitleLabel.bottomAnchor, constant: verticalPadding).isActive = true;
            articleView.leadingAnchor.constraint(equalTo: categoryView.leadingAnchor).isActive = true;
            articleView.trailingAnchor.constraint(equalTo: categoryView.trailingAnchor).isActive = true;
            
            //
            
            let articleTimeStampLabel = UILabel();
            
            articleView.addSubview(articleTimeStampLabel);
            
            articleTimeStampLabel.translatesAutoresizingMaskIntoConstraints = false;
            
            articleTimeStampLabel.topAnchor.constraint(equalTo: articleView.topAnchor).isActive = true;
            articleTimeStampLabel.leadingAnchor.constraint(equalTo: articleView.leadingAnchor).isActive = true;
            articleTimeStampLabel.trailingAnchor.constraint(equalTo: articleView.trailingAnchor).isActive = true;
            
            articleTimeStampLabel.font = UIFont(name: SFProDisplay_Semibold, size: categoryViewWidth / 30);
            articleTimeStampLabel.textAlignment = .left;
            articleTimeStampLabel.textColor = BackgroundGrayColor;
            articleTimeStampLabel.numberOfLines = 0;
            
            //
            
            let articleImageView = UIImageView();
            
            articleView.addSubview(articleImageView);
            
            articleImageView.translatesAutoresizingMaskIntoConstraints = false;
            
            let articleImageViewHeight = categoryViewWidth * 0.70;
            articleImageView.topAnchor.constraint(equalTo: articleTimeStampLabel.bottomAnchor, constant: verticalPadding / 2).isActive = true;
            articleImageView.leadingAnchor.constraint(equalTo: articleView.leadingAnchor).isActive = true;
            articleImageView.widthAnchor.constraint(equalToConstant: categoryViewWidth).isActive = true;
            articleImageView.heightAnchor.constraint(equalToConstant: articleImageViewHeight).isActive = true;
            
            articleImageView.backgroundColor = mainThemeColor;
            articleImageView.layer.cornerRadius = articleImageViewHeight / 12;
            articleImageView.contentMode = .scaleAspectFill;
            articleImageView.clipsToBounds = true;
            
            //
            
            let articleTitleLabel = UILabel();
            
            articleView.addSubview(articleTitleLabel);
            
            articleTitleLabel.translatesAutoresizingMaskIntoConstraints = false;
            
            articleTitleLabel.topAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: verticalPadding / 2).isActive = true;
            articleTitleLabel.leadingAnchor.constraint(equalTo: articleView.leadingAnchor).isActive = true;
            articleTitleLabel.trailingAnchor.constraint(equalTo: articleView.trailingAnchor).isActive = true;
            articleTitleLabel.bottomAnchor.constraint(equalTo: articleView.bottomAnchor).isActive = true;
            
            articleTitleLabel.font = UIFont(name: SFProDisplay_Bold, size: AppUtility.getCurrentScreenSize().width / 15);
            articleTitleLabel.textAlignment = .left;
            articleTitleLabel.textColor = InverseBackgroundColor;
            articleTitleLabel.numberOfLines = 0;
            
            dataManager.getBaseArticleData(articleID, completion: { (articledata) in // load article content
                articleTitleLabel.text = articledata.title;
                articleTimeStampLabel.text = timeManager.epochToDiffString(articledata.timestamp);
                if (articledata.thumbURLs.count > 0){
                    articleImageView.setImageURL(articledata.thumbURLs[0]);
                }
            });
            
            previousTopView = articleView;
        }

        let semiFeaturedArticleHorizontalPadding : CGFloat = categoryViewWidth / 15;
        let semiFeaturedArticleWidth = categoryViewWidth / 2 - semiFeaturedArticleHorizontalPadding / 2;
        
        if (articleIDs.count > 0){ // left under featured
            
            let articleID = articleIDs.removeFirst();
            
            let articleView = ArticleButton();
            
            articleView.articleID = articleID;
            articleView.addTarget(self, action: #selector(self.handleArticleClick), for: .touchUpInside);
            
            categoryView.addSubview(articleView);
            
            articleView.translatesAutoresizingMaskIntoConstraints = false;
            
            let articleViewWidth = semiFeaturedArticleWidth;
            articleView.topAnchor.constraint(equalTo: previousTopView.bottomAnchor, constant: verticalPadding).isActive = true;
            articleView.leadingAnchor.constraint(equalTo: categoryView.leadingAnchor).isActive = true;
            articleView.widthAnchor.constraint(equalToConstant: articleViewWidth).isActive = true;
            
            renderSemiFeaturedSection(articleView, articleViewWidth, articleID);
            
            previousTopView = articleView;
            
        }
        
        if (articleIDs.count > 0){ // right under featured
            
            let articleID = articleIDs.removeFirst();
            
            let articleView = ArticleButton();
            
            articleView.articleID = articleID;
            articleView.addTarget(self, action: #selector(self.handleArticleClick), for: .touchUpInside);
            
            categoryView.addSubview(articleView);
            
            articleView.translatesAutoresizingMaskIntoConstraints = false;
            
            let articleViewWidth = semiFeaturedArticleWidth;
            articleView.topAnchor.constraint(equalTo: previousTopView.topAnchor).isActive = true; // equal to the left articleview
            articleView.leadingAnchor.constraint(equalTo: previousTopView.trailingAnchor, constant: semiFeaturedArticleHorizontalPadding).isActive = true;
            articleView.widthAnchor.constraint(equalToConstant: articleViewWidth).isActive = true;
            
            renderSemiFeaturedSection(articleView, articleViewWidth, articleID);
            
            previousSecondaryTopView = articleView;
            
        }
        
        if (articleIDs.count > 0){ // rest of featured
            
            let carouselView = UIView();
            
            categoryView.addSubview(carouselView);
            
            carouselView.translatesAutoresizingMaskIntoConstraints = false;
            
            carouselView.topAnchor.constraint(greaterThanOrEqualTo: previousTopView.bottomAnchor, constant: verticalPadding).isActive = true;
            
            if let secondaryView = previousSecondaryTopView{
                let carouselViewSecondaryTopAnchor = carouselView.topAnchor.constraint(equalTo: secondaryView.bottomAnchor, constant: verticalPadding);
                carouselViewSecondaryTopAnchor.isActive = true;
                carouselViewSecondaryTopAnchor.priority = UILayoutPriority(rawValue: 999);
            }
            
            carouselView.leadingAnchor.constraint(equalTo: categoryView.leadingAnchor).isActive = true;
            carouselView.trailingAnchor.constraint(equalTo: categoryView.trailingAnchor).isActive = true;
            
            //
            
            let articleScrollView = UIButtonScrollView();
            
            carouselView.addSubview(articleScrollView);
            
            articleScrollView.translatesAutoresizingMaskIntoConstraints = false;
            
            let articleScrollViewHeight = CGFloat(Int(categoryViewWidth * 0.6));
            articleScrollView.topAnchor.constraint(equalTo: carouselView.topAnchor).isActive = true;
            articleScrollView.leadingAnchor.constraint(equalTo: carouselView.leadingAnchor).isActive = true;
            articleScrollView.widthAnchor.constraint(equalToConstant: categoryViewWidth).isActive = true;
            articleScrollView.heightAnchor.constraint(equalToConstant: articleScrollViewHeight).isActive = true;
            
            articleScrollView.isPagingEnabled = true;
            articleScrollView.showsVerticalScrollIndicator = false;
            articleScrollView.showsHorizontalScrollIndicator = false;
            articleScrollView.delegate = self;
            
            articleScrollView.tag = categoryIndex + 1;
            
            //
        
            let articleScrollViewPageControl = categoryScrollViewPageControlViews[categoryIndex];
            
            carouselView.addSubview(articleScrollViewPageControl);
            
            articleScrollViewPageControl.translatesAutoresizingMaskIntoConstraints = false;
            
            articleScrollViewPageControl.topAnchor.constraint(equalTo: articleScrollView.bottomAnchor, constant: 2*verticalPadding).isActive = true;
            articleScrollViewPageControl.leadingAnchor.constraint(equalTo: carouselView.leadingAnchor).isActive = true;
            articleScrollViewPageControl.trailingAnchor.constraint(equalTo: carouselView.trailingAnchor).isActive = true;
            articleScrollViewPageControl.bottomAnchor.constraint(equalTo: carouselView.bottomAnchor, constant: -verticalPadding).isActive = true;
            
            articleScrollViewPageControl.numberOfPages = 1;
            articleScrollViewPageControl.isUserInteractionEnabled = false;
            articleScrollViewPageControl.currentPageIndicatorTintColor = InverseBackgroundColor;
            articleScrollViewPageControl.pageIndicatorTintColor = BackgroundGrayColor;
            
            //
            
            renderScrollView(articleScrollView, categoryIndex, articleIDs, CGSize(width: categoryViewWidth, height: articleScrollViewHeight), categorydata);
            
            previousTopView = carouselView;
            
        }
        
        categoryView.bottomAnchor.constraint(greaterThanOrEqualTo: previousTopView.bottomAnchor, constant: verticalPadding).isActive = true;
        
        if let secondaryView = previousSecondaryTopView{
            let categoryViewSecondaryBottomAnchor = categoryView.bottomAnchor.constraint(equalTo: secondaryView.bottomAnchor, constant: verticalPadding);
            categoryViewSecondaryBottomAnchor.isActive = true;
            categoryViewSecondaryBottomAnchor.priority = UILayoutPriority(rawValue: 999);
        }
        
    }
    
    private func renderSemiFeaturedSection(_ articleView: ArticleButton, _ articleViewWidth: CGFloat, _ articleID: String){
        
        let articleVerticalPadding = CGFloat(5);
        
        //
        
        let articleTimeStampLabel = UILabel();
        
        articleView.addSubview(articleTimeStampLabel);
        
        articleTimeStampLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        articleTimeStampLabel.topAnchor.constraint(equalTo: articleView.topAnchor).isActive = true;
        articleTimeStampLabel.leadingAnchor.constraint(equalTo: articleView.leadingAnchor).isActive = true;
        articleTimeStampLabel.trailingAnchor.constraint(equalTo: articleView.trailingAnchor).isActive = true;
        
        articleTimeStampLabel.font = UIFont(name: SFProDisplay_Semibold, size: articleViewWidth / 20);
        articleTimeStampLabel.textAlignment = .left;
        articleTimeStampLabel.textColor = BackgroundGrayColor;
        articleTimeStampLabel.numberOfLines = 0;
        
        //
        
        let articleImageView = UIImageView();
        
        articleView.addSubview(articleImageView);
        
        articleImageView.translatesAutoresizingMaskIntoConstraints = false;
        
        let articleImageViewHeight = articleViewWidth * 0.65;
        articleImageView.topAnchor.constraint(equalTo: articleTimeStampLabel.bottomAnchor, constant: articleVerticalPadding).isActive = true;
        articleImageView.leadingAnchor.constraint(equalTo: articleView.leadingAnchor).isActive = true;
        articleImageView.widthAnchor.constraint(equalToConstant: articleViewWidth).isActive = true;
        articleImageView.heightAnchor.constraint(equalToConstant: articleImageViewHeight).isActive = true;
        
        articleImageView.backgroundColor = mainThemeColor;
        articleImageView.layer.cornerRadius = articleImageViewHeight / 12;
        articleImageView.contentMode = .scaleAspectFill;
        articleImageView.clipsToBounds = true;
        
        //
        
        let articleTitleLabel = UILabel();
        
        articleView.addSubview(articleTitleLabel);
        
        articleTitleLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        articleTitleLabel.topAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: articleVerticalPadding).isActive = true;
        articleTitleLabel.leadingAnchor.constraint(equalTo: articleView.leadingAnchor).isActive = true;
        articleTitleLabel.widthAnchor.constraint(equalToConstant: articleViewWidth).isActive = true;
        articleTitleLabel.bottomAnchor.constraint(equalTo: articleView.bottomAnchor).isActive = true;
        
        articleTitleLabel.font = UIFont(name: SFProDisplay_Bold, size: articleViewWidth / 10);
        articleTitleLabel.textAlignment = .left;
        articleTitleLabel.textColor = InverseBackgroundColor;
        articleTitleLabel.numberOfLines = 0;
        
        //
        
        dataManager.getBaseArticleData(articleID, completion: { (articledata) in
            articleTimeStampLabel.text = timeManager.epochToDiffString(articledata.timestamp);
            articleTitleLabel.text = articledata.title;
            if (articledata.thumbURLs.count > 0){
                articleImageView.setImageURL(articledata.thumbURLs[0]);
            }
        });
        
    }
    
    private func arrayToPairs(_ a: [String]) -> [(String, String?)]{
        var out : [(String, String?)] = [];
        var t : String? = nil;
        
        for i in a{
            guard let str = t else{
                t = i;
                continue;
            }
            out.append((str, i));
            t = nil;
        }
        
        if (t != nil){
            out.append((t!, nil));
        }
        
        return out;
    }
    
    private func renderScrollView(_ scrollView: UIButtonScrollView, _ categoryIndex: Int, _ articleIDs: [String], _ scrollViewSize: CGSize, _ categorydata: categoryData){
        //print(arrayToPairs(articleIDs));
        
        let articleIDPArray = arrayToPairs(articleIDs);
        
        var nextX = CGFloat(0);
        for i in 0..<articleIDPArray.count{
            
            let articleIDPair = articleIDPArray[i];
            
            //
            
            let outerStackViewFrame = CGRect(x: nextX, y: 0, width: scrollViewSize.width, height: scrollViewSize.height);
            let outerStackView = UIView(frame: outerStackViewFrame);
            
            let stackViewVerticalPadding = CGFloat(outerStackView.frame.height / 10);
            let stackViewHeight = (outerStackView.frame.height - stackViewVerticalPadding) / 2;
            
            //
            let topStackViewFrame = CGRect(x: 0, y: 0, width: outerStackView.frame.width, height: stackViewHeight);
            let topStackView = ArticleButton(frame: topStackViewFrame);
            
            renderStackView(topStackView, articleIDPair.0, categorydata);
            
            topStackView.articleID = articleIDPair.0;
            topStackView.addTarget(self, action: #selector(self.handleArticleClick), for: .touchUpInside);
            
            outerStackView.addSubview(topStackView);
            //
            if (articleIDPair.1 != nil){
                let articleID = articleIDPair.1!;
                
                let bottomStackViewFrame = CGRect(x: 0, y: stackViewHeight + stackViewVerticalPadding, width: outerStackView.frame.width, height: stackViewHeight);
                let bottomStackView = ArticleButton(frame: bottomStackViewFrame);
                
                renderStackView(bottomStackView, articleID, categorydata);
                
                bottomStackView.articleID = articleID;
                bottomStackView.addTarget(self, action: #selector(self.handleArticleClick), for: .touchUpInside);
                
                outerStackView.addSubview(bottomStackView);
            }
            
            scrollView.addSubview(outerStackView);
            
            nextX += outerStackView.frame.width + (outerStackView.frame.width - CGFloat(Int(outerStackView.frame.width))); // second part is due to a bug with constraints ignoring floating point decimals causing a bit of a content offset
        }
        
        scrollView.contentSize = CGSize(width: nextX, height: scrollViewSize.height);
        categoryScrollViewPageControlViews[categoryIndex].numberOfPages = articleIDPArray.count;
    }
    
    private func renderStackView(_ stackView: UIView, _ articleID: String, _ categorydata: categoryData){
        
        let stackViewHorizontalPadding = CGFloat(stackView.frame.width / 25);
        let stackViewVerticalPadding = CGFloat(stackView.frame.height / 30);
        
        //
        let imageViewFrame = CGRect(x: 0, y: 0, width: stackView.frame.width * 0.45, height: stackView.frame.height);
        let imageView = UIImageView(frame: imageViewFrame);
        
        imageView.backgroundColor = mainThemeColor;
        imageView.contentMode = .scaleAspectFill;
        imageView.clipsToBounds = true;
        imageView.layer.cornerRadius = imageView.frame.height / 12;
        
        stackView.addSubview(imageView);
        
        //
        let titleLabelFrame = CGRect(x: imageView.frame.width + stackViewHorizontalPadding, y: 0, width: stackView.frame.width - imageView.frame.width - stackViewHorizontalPadding, height: stackView.frame.height * 0.8);
        let titleLabel = UILabel(frame: titleLabelFrame);
        
        titleLabel.textAlignment = .left;
        titleLabel.textColor = InverseBackgroundColor;
        titleLabel.font = UIFont(name: SFProDisplay_Bold, size: titleLabel.frame.height * 0.25);
        titleLabel.numberOfLines = 0;
        
        stackView.addSubview(titleLabel);
        //
        
        let articleAttributesViewFrame = CGRect(x: imageView.frame.width + stackViewHorizontalPadding, y: titleLabel.frame.height + stackViewVerticalPadding, width: titleLabel.frame.width, height: stackView.frame.height - titleLabel.frame.height - stackViewVerticalPadding);
        let articleAttributesView = UIView(frame: articleAttributesViewFrame);
        
        //articleAttributesView.translatesAutoresizingMaskIntoConstraints = false;
        
        //
        
        let articleCategoryColorView = UIView();
        
        articleAttributesView.addSubview(articleCategoryColorView);
        
        articleCategoryColorView.translatesAutoresizingMaskIntoConstraints = false;
        
        articleCategoryColorView.leadingAnchor.constraint(equalTo: articleAttributesView.leadingAnchor).isActive = true;
        articleCategoryColorView.topAnchor.constraint(equalTo: articleAttributesView.topAnchor).isActive = true;
        articleCategoryColorView.widthAnchor.constraint(equalToConstant: articleAttributesView.frame.width / 30).isActive = true;
        articleCategoryColorView.heightAnchor.constraint(equalToConstant: articleAttributesView.frame.height).isActive = true;
        
        articleCategoryColorView.backgroundColor = mainThemeColor;
        articleCategoryColorView.isHidden = true;
        
        //
        
        let articleTimeStampLabel = UILabel();
        
        articleAttributesView.addSubview(articleTimeStampLabel);
        
        articleTimeStampLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        articleTimeStampLabel.leadingAnchor.constraint(equalTo: articleCategoryColorView.trailingAnchor, constant: 5).isActive = true;
        articleTimeStampLabel.topAnchor.constraint(equalTo: articleAttributesView.topAnchor).isActive = true;
        articleTimeStampLabel.heightAnchor.constraint(equalToConstant: articleAttributesView.frame.height).isActive = true;
        articleTimeStampLabel.trailingAnchor.constraint(equalTo: articleAttributesView.trailingAnchor).isActive = true;
        
        articleTimeStampLabel.font = UIFont(name: SFProDisplay_Regular, size: articleAttributesView.frame.height * 0.8);
        articleTimeStampLabel.textAlignment = .left;
        articleTimeStampLabel.textColor = BackgroundGrayColor;
        
        //
        
        stackView.addSubview(articleAttributesView);
        //
    
        dataManager.getBaseArticleData(articleID, completion: { (articledata) in
            if (articledata.thumbURLs.count > 0){
                imageView.setImageURL(articledata.thumbURLs[0]);
            }
            
            titleLabel.text = articledata.title;
            
            articleCategoryColorView.isHidden = false;
            articleCategoryColorView.backgroundColor = categorydata.color;
            
            articleTimeStampLabel.text = timeManager.epochToDiffString(articledata.timestamp);
        });
        
    }
    //
    
    @objc func handleArticleClick(_ sender: ArticleButton){
        let articleDataDict : [String : String] = ["articleID" : sender.articleID];
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: articlePageNotification), object: nil, userInfo: articleDataDict);
    }
}
