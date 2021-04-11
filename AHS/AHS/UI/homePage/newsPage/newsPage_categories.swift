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
        print(categorydata.title);
        
        let categoryView = UIView();
        
        self.view.addSubview(categoryView);
        
        categoryView.translatesAutoresizingMaskIntoConstraints = false;
        
        (categoryParentViews.count == 0 ? categoryView.topAnchor.constraint(equalTo: featuredParentView.bottomAnchor, constant: 2*verticalPadding) : categoryView.topAnchor.constraint(equalTo: categoryParentViews[categoryParentViews.count - 1].bottomAnchor, constant: verticalPadding)).isActive = true;
        
        categoryView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: homePageHorizontalPadding).isActive = true;
        categoryView.widthAnchor.constraint(equalToConstant: AppUtility.getCurrentScreenSize().width - 2*homePageHorizontalPadding).isActive = true;
        
        //
        categoryView.heightAnchor.constraint(equalToConstant: AppUtility.getCurrentScreenSize().height).isActive = true;
        
        renderCategoryContent(categorydata, categoryView);
        
        categoryParentViews.append(categoryView);
    }
    
    private func renderCategoryContent(_ categorydata: categoryData, _ categoryView: UIView){
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
            
            let articleImageView = UIImageView();
            
            articleView.addSubview(articleImageView);
            
            articleImageView.translatesAutoresizingMaskIntoConstraints = false;
            
            let articleImageViewHeight = categoryViewWidth * 0.70;
            articleImageView.topAnchor.constraint(equalTo: articleView.topAnchor).isActive = true;
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
            
            articleTitleLabel.topAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: verticalPadding).isActive = true;
            articleTitleLabel.leadingAnchor.constraint(equalTo: articleView.leadingAnchor).isActive = true;
            articleTitleLabel.trailingAnchor.constraint(equalTo: articleView.trailingAnchor).isActive = true;
            articleTitleLabel.bottomAnchor.constraint(equalTo: articleView.bottomAnchor).isActive = true;
            
            articleTitleLabel.font = UIFont(name: SFProDisplay_Bold, size: AppUtility.getCurrentScreenSize().width / 15);
            articleTitleLabel.textAlignment = .left;
            articleTitleLabel.textColor = InverseBackgroundColor;
            articleTitleLabel.numberOfLines = 0;
            
            dataManager.getBaseArticleData(articleID, completion: { (articledata) in // load article content
                articleTitleLabel.text = articledata.title;
                if (articledata.thumbURLs.count > 0){
                    articleImageView.sd_setImage(with: URL(string: articledata.thumbURLs[0]));
                }
            });
            
            previousTopView = articleView;
        }

        if (articleIDs.count > 0){ // left under featured
            
            let articleID = articleIDs.removeFirst();
            
            let articleView = ArticleButton();
            
            categoryView.addSubview(articleView);
            
            articleView.translatesAutoresizingMaskIntoConstraints = false;
            
            
        }
        
    }
    
    
    @objc func handleArticleClick(_ sender: ArticleButton){
        print(sender.articleID);
    }
}
