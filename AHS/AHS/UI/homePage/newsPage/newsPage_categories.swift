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
        dataManager.getHomepageLocationData(completion: { (location) in
            for categoryID in location.categoryIDs{
                dataManager.getCategoryData(categoryID, completion: { (category) in
                    self.renderCategory(category);
                });
            }
        });
    }
    
    internal func renderCategory(_ categorydata: categoryData){
        
        let categoryView = UIView();
        
        self.view.addSubview(categoryView);
        
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
        categoryTitleLabel.textColor = UIColor{ _ in
            return UIColor.dynamicColor(light: categorydata.colorLightMode, dark: categorydata.colorDarkMode);
        }
        categoryTitleLabel.textAlignment = .left;
        
        categoryView.addSubview(categoryTitleLabel);
        
        //
        
        var articleIDs = categorydata.articleIDs;
        var previousTopView : UIView = UIView(); // for constraining the next view under the previously rendered view
        var previousSecondaryTopView : UIView = UIView(); // for the semifeatured section

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
                    articleImageView.sd_setImage(with: URL(string: articledata.thumbURLs[0]));
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
            let carouselViewSecondaryTopAnchor = carouselView.topAnchor.constraint(equalTo: previousSecondaryTopView.bottomAnchor, constant: verticalPadding);
            carouselViewSecondaryTopAnchor.isActive = true;
            carouselViewSecondaryTopAnchor.priority = UILayoutPriority(rawValue: 999);
            
            carouselView.leadingAnchor.constraint(equalTo: categoryView.leadingAnchor).isActive = true;
            carouselView.trailingAnchor.constraint(equalTo: categoryView.trailingAnchor).isActive = true;
            
            //
            
            let articleScrollView = UIScrollView();
            
            carouselView.addSubview(articleScrollView);
            
            articleScrollView.translatesAutoresizingMaskIntoConstraints = false;
            
            articleScrollView.topAnchor.constraint(equalTo: carouselView.topAnchor).isActive = true;
            articleScrollView.leadingAnchor.constraint(equalTo: carouselView.leadingAnchor).isActive = true;
            articleScrollView.widthAnchor.constraint(equalToConstant: categoryViewWidth).isActive = true;
            articleScrollView.heightAnchor.constraint(equalToConstant: categoryViewWidth * 0.5).isActive = true;
            
            articleScrollView.delegate = self;
            
            articleScrollView.backgroundColor = .systemRed;
            articleScrollView.tag = categoryIndex + 1;
            
            //
        
            let articleScrollViewPageControl = categoryScrollViewPageControlViews[categoryIndex];
            
            carouselView.addSubview(articleScrollViewPageControl);
            
            articleScrollViewPageControl.translatesAutoresizingMaskIntoConstraints = false;
            
            articleScrollViewPageControl.topAnchor.constraint(equalTo: articleScrollView.bottomAnchor, constant: 2*verticalPadding).isActive = true;
            articleScrollViewPageControl.leadingAnchor.constraint(equalTo: carouselView.leadingAnchor).isActive = true;
            articleScrollViewPageControl.trailingAnchor.constraint(equalTo: carouselView.trailingAnchor).isActive = true;
            articleScrollViewPageControl.bottomAnchor.constraint(equalTo: carouselView.bottomAnchor).isActive = true;
            
            articleScrollViewPageControl.numberOfPages = 1;
            
            //
            
            previousTopView = carouselView;
            
        }
        
        categoryView.bottomAnchor.constraint(greaterThanOrEqualTo: previousTopView.bottomAnchor, constant: verticalPadding).isActive = true;
        let categoryViewSecondaryBottomAnchor = categoryView.bottomAnchor.constraint(equalTo: previousSecondaryTopView.bottomAnchor, constant: verticalPadding);
        categoryViewSecondaryBottomAnchor.isActive = true;
        categoryViewSecondaryBottomAnchor.priority = UILayoutPriority(rawValue: 999);
        
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
                articleImageView.sd_setImage(with: URL(string: articledata.thumbURLs[0]));
            }
        });
        
    }
    
    private func renderScrollView(_ scrollView: UIScrollView, _ categoryIndex: Int){
        
    }
    //
    
    @objc func handleArticleClick(_ sender: ArticleButton){
        print(sender.articleID);
    }
}
