//
//  newsPage_featured.swift
//  AHS
//
//  Created by Richard Wei on 4/7/21.
//

import Foundation
import UIKit
import UPCarouselFlowLayout

extension newsPageController: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate{
    
    internal func renderFeatured(){
        
        self.view.addSubview(featuredParentView);
        
        featuredParentView.translatesAutoresizingMaskIntoConstraints = false;
        
        featuredParentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true;
        featuredParentView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true;
        featuredParentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true;
        
        //
        
        let featuredLabelFrame = CGRect(x: 0, y: 0, width: AppUtility.getCurrentScreenSize().width, height: AppUtility.getCurrentScreenSize().width / 10);
        let featuredLabel = UITextView(frame: featuredLabelFrame);
        
        featuredLabel.isUserInteractionEnabled = false;
        featuredLabel.isEditable = false;
        featuredLabel.isSelectable = false;
        featuredLabel.textAlignment = .left;
        featuredLabel.backgroundColor = .clear;
        
        let featuredLabelText = NSMutableAttributedString(string: "Featured", attributes: [NSAttributedString.Key.font : UIFont(name: SFProDisplay_Bold, size: featuredLabel.frame.height * 0.7)!]);
        featuredLabelText.append(NSAttributedString(string: " Articles", attributes: [NSAttributedString.Key.font : UIFont(name: SFProDisplay_Light, size: featuredLabel.frame.height * 0.7)!]));
        
        featuredLabel.attributedText = featuredLabelText;
        featuredLabel.textColor = UIColor.init(hex: "#c22b2b");
        featuredLabel.textContainerInset = UIEdgeInsets(top: 2, left: homePageHorizontalPadding, bottom: 0, right: homePageHorizontalPadding);
        featuredLabel.textContainer.lineFragmentPadding = .zero;
        
        featuredParentView.addSubview(featuredLabel);
        
        //
        
        let featuredCollectionViewHeight = AppUtility.getCurrentScreenSize().width * 0.65;
        let featuredCollectionViewWidth = AppUtility.getCurrentScreenSize().width;
        
        let featuredCollectionViewLayoutItemSizeVerticalPadding = featuredCollectionViewHeight / 12;
        featuredCollectionViewLayout.itemSize = CGSize(width: featuredCollectionViewWidth - 2*homePageHorizontalPadding, height: featuredCollectionViewHeight - featuredCollectionViewLayoutItemSizeVerticalPadding);
        featuredCollectionViewLayout.scrollDirection = .horizontal;
        featuredCollectionViewLayout.spacingMode = .overlap(visibleOffset: homePageHorizontalPadding / 2);
        
        featuredCollectionView = UICollectionView(frame: CGRect(x: 0, y: featuredLabel.frame.height, width: featuredCollectionViewWidth, height: featuredCollectionViewHeight), collectionViewLayout: featuredCollectionViewLayout);
        
        featuredCollectionView.showsVerticalScrollIndicator = false;
        featuredCollectionView.showsHorizontalScrollIndicator = false;
        featuredCollectionView.delegate = self;
        featuredCollectionView.dataSource = self;
        featuredCollectionView.register(featuredCollectionViewCell.self, forCellWithReuseIdentifier: featuredCollectionViewCell.identifier);
        featuredCollectionView.backgroundColor = .clear;
        
        featuredParentView.addSubview(featuredCollectionView);
        
        //
        
        //featuredArticleLabel.frame = CGRect(x: homePageHorizontalPadding, y: nextY, width: AppUtility.getCurrentScreenSize().width - 2*homePageHorizontalPadding, height: AppUtility.getCurrentScreenSize().width / 5);
        
        featuredParentView.addSubview(featuredArticleLabel);
        
        featuredArticleLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        featuredArticleLabel.leadingAnchor.constraint(equalTo: featuredParentView.leadingAnchor, constant: homePageHorizontalPadding).isActive = true;
        featuredArticleLabel.topAnchor.constraint(equalTo: featuredCollectionView.bottomAnchor).isActive = true;
        featuredArticleLabel.widthAnchor.constraint(equalToConstant: AppUtility.getCurrentScreenSize().width - 2*homePageHorizontalPadding).isActive = true;
        
        //featuredArticleLabel.text = "test test t test test test test test test test test"
        featuredArticleLabel.font = UIFont(name: SFProDisplay_Bold, size: AppUtility.getCurrentScreenSize().width / 15);
        featuredArticleLabel.textColor = InverseBackgroundColor;
        //featuredArticleLabel.lineBreakMode = .byWordWrapping;
        featuredArticleLabel.textAlignment = .left;
        featuredArticleLabel.numberOfLines = 3;
        //
        
        featuredParentView.addSubview(featuredArticleCategoryView);
        
        featuredArticleCategoryView.translatesAutoresizingMaskIntoConstraints = false;
        
        let featuredArticleCategoryViewHeight = AppUtility.getCurrentScreenSize().width / 20;
        let featuredArticleCategoryViewWidth = featuredArticleCategoryViewHeight * 0.4;
        
        featuredArticleCategoryView.leadingAnchor.constraint(equalTo: featuredParentView.leadingAnchor, constant: homePageHorizontalPadding).isActive = true;
        featuredArticleCategoryView.topAnchor.constraint(equalTo: featuredArticleLabel.bottomAnchor, constant: featuredVerticalPadding).isActive = true;
        featuredArticleCategoryView.widthAnchor.constraint(equalToConstant: featuredArticleCategoryViewWidth).isActive = true;
        featuredArticleCategoryView.heightAnchor.constraint(equalToConstant: featuredArticleCategoryViewHeight).isActive = true;
        featuredArticleCategoryView.bottomAnchor.constraint(equalTo: featuredParentView.bottomAnchor).isActive = true;

        featuredArticleCategoryView.backgroundColor = mainThemeColor;
        featuredArticleCategoryView.isHidden = true;
        
        //
        
        featuredParentView.addSubview(featuredArticleCategoryLabel);
        
        featuredArticleCategoryLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        let featuredArticleCategoryLabelHorizontalPadding = CGFloat(5);
        
        featuredArticleCategoryLabel.leadingAnchor.constraint(equalTo: featuredArticleCategoryView.trailingAnchor, constant: featuredArticleCategoryLabelHorizontalPadding).isActive = true;
        featuredArticleCategoryLabel.topAnchor.constraint(equalTo: featuredArticleLabel.bottomAnchor, constant: featuredVerticalPadding).isActive = true;
        let featuredArticleCategoryLabelHeightAnchor = featuredArticleCategoryLabel.heightAnchor.constraint(equalToConstant: featuredArticleCategoryViewHeight);
        featuredArticleCategoryLabelHeightAnchor.isActive = true;
        
        //featuredArticleCategoryLabel.text = "Athletics";
        featuredArticleCategoryLabel.font = UIFont(name: SFProDisplay_Semibold, size: featuredArticleCategoryLabelHeightAnchor.constant);
        featuredArticleCategoryLabel.textAlignment = .center;
        //featuredArticleCategoryLabel.textColor = UIColor.init(hex: "#C22B2B");
        
        //
        
        featuredParentView.addSubview(featuredArticleTimestampLabel);
        
        featuredArticleTimestampLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        featuredArticleTimestampLabel.leadingAnchor.constraint(equalTo: featuredArticleCategoryLabel.trailingAnchor).isActive = true;
        featuredArticleTimestampLabel.topAnchor.constraint(equalTo: featuredArticleLabel.bottomAnchor, constant: featuredVerticalPadding).isActive = true;
        let featuredArticleTimestampLabelHeightAnchor = featuredArticleTimestampLabel.heightAnchor.constraint(equalToConstant: featuredArticleCategoryViewHeight);
        featuredArticleTimestampLabelHeightAnchor.isActive = true;
        featuredArticleTimestampLabel.widthAnchor.constraint(equalToConstant: AppUtility.getCurrentScreenSize().width - 2*homePageHorizontalPadding).isActive = true;
        
        //featuredArticleTimestampLabel.text = featuredArticleTimestampLabelTextPrefix + "00m ago";
        featuredArticleTimestampLabel.font = UIFont(name: SFProDisplay_Regular, size: featuredArticleTimestampLabelHeightAnchor.constant * 0.8);
        featuredArticleTimestampLabel.textAlignment = .left;
        featuredArticleTimestampLabel.textColor = BackgroundGrayColor;
        
        //
        
    }
    
    internal func loadFeaturedArticles(){
        featuredArticleArray = [];
        featuredCollectionView.reloadData();
        updateFeaturedArticleInfo(-1);
        
        //
        
        dataManager.getCategoryData("Featured", completion: { (category) in
            for articleID in category.articleIDs{
                dataManager.getBaseArticleData(articleID, completion: { (article) in
                    self.featuredArticleArray.append(article);
                    self.featuredArticleCallback(self.featuredArticleArray.count - 1);
                });
            }
        });
    }
    
    internal func featuredArticleCallback(_ index: Int){
        //print("article callback - \(featuredArticleArray[index])")
        featuredCollectionView.reloadData();
        if (featuredArticleArray.count == 1){ // first time being called
            updateFeaturedArticleInfo(index);
        }
    }
    
    internal func updateFeaturedArticleInfo(_ index: Int){
        if (index < featuredArticleArray.count && index != -1){
            let articleData = featuredArticleArray[index];
            
            featuredArticleCategoryView.isHidden = false;
            
            featuredArticleLabel.text = articleData.title;
            
            featuredArticleTimestampLabel.text = featuredArticleTimestampLabelTextPrefix + timeManager.epochToDiffString(articleData.timestamp);
            
            dataManager.getCategoryData(articleData.categoryID, completion: { (data) in
                
                self.featuredArticleCategoryView.backgroundColor = UIColor{ _ in
                    return UIColor.dynamicColor(light: data.colorLightMode, dark: data.colorDarkMode);
                }
                
                self.featuredArticleCategoryLabel.text = data.title;
                
            });
            
            updateParentHeightConstraint();
        }
        else{
            featuredArticleCategoryView.isHidden = true;
            featuredArticleLabel.text = "";
            featuredArticleTimestampLabel.text = "";
            featuredArticleCategoryLabel.text = "";
            //updateParentHeightConstraint();
        }
    }
    
    // UICollectionView Functions
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return featuredArticleArray.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: featuredCollectionViewCell.identifier, for: indexPath) as! featuredCollectionViewCell;
        let index = indexPath.row;
        if (index < featuredArticleArray.count){
            let thumbURLs = featuredArticleArray[index].thumbURLs;
            if (thumbURLs.count > 0){
                cell.updateImage(thumbURLs[0]);
            }
        }
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected item at \(indexPath.row)");
    }
    
    // UIScrollView Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // https://stackoverflow.com/a/38312063/
        
        let centerPoint = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2));
        guard let indexPath = featuredCollectionView.indexPathForItem(at: centerPoint) else {
            return;
        }
        
       // print("page - \(indexPath.row)");
        updateFeaturedArticleInfo(indexPath.row);
    }
    
}
