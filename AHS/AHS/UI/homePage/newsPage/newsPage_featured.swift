//
//  newsPage_featured.swift
//  AHS
//
//  Created by Richard Wei on 4/7/21.
//

import Foundation
import UIKit
import UPCarouselFlowLayout

extension newsPageController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    internal func renderFeatured(){
        
        let featuredLabelFrame = CGRect(x: 0, y: nextY, width: AppUtility.getCurrentScreenSize().width, height: AppUtility.getCurrentScreenSize().width / 10);
        let featuredLabel = UITextView(frame: featuredLabelFrame);
        
        featuredLabel.isUserInteractionEnabled = false;
        featuredLabel.isEditable = false;
        featuredLabel.isSelectable = false;
        featuredLabel.textAlignment = .left;
        
        let featuredLabelText = NSMutableAttributedString(string: "Featured", attributes: [NSAttributedString.Key.font : UIFont(name: SFProDisplay_Bold, size: featuredLabel.frame.height * 0.7)!]);
        featuredLabelText.append(NSAttributedString(string: " Articles", attributes: [NSAttributedString.Key.font : UIFont(name: SFProDisplay_Light, size: featuredLabel.frame.height * 0.7)!]));
        
        featuredLabel.attributedText = featuredLabelText;
        featuredLabel.textColor = UIColor.init(hex: "#c22b2b");
        featuredLabel.textContainerInset = UIEdgeInsets(top: 2, left: homePageHorizontalPadding, bottom: 0, right: homePageHorizontalPadding);
        featuredLabel.textContainer.lineFragmentPadding = .zero;
        
        nextY += featuredLabel.frame.height;
        
        self.view.addSubview(featuredLabel);
        
        //
        
        let featuredCollectionViewHeight = AppUtility.getCurrentScreenSize().width * 0.65;
        let featuredCollectionViewWidth = AppUtility.getCurrentScreenSize().width;
        
        let featuredCollectionViewLayout = UPCarouselFlowLayout();
        let featuredCollectionViewLayoutItemSizeVerticalPadding = featuredCollectionViewHeight / 12;
        featuredCollectionViewLayout.itemSize = CGSize(width: featuredCollectionViewWidth - 2*homePageHorizontalPadding, height: featuredCollectionViewHeight - featuredCollectionViewLayoutItemSizeVerticalPadding);
        featuredCollectionViewLayout.scrollDirection = .horizontal;
        featuredCollectionViewLayout.spacingMode = .overlap(visibleOffset: homePageHorizontalPadding / 2);
        
        featuredCollectionView = UICollectionView(frame: CGRect(x: 0, y: nextY, width: featuredCollectionViewWidth, height: featuredCollectionViewHeight), collectionViewLayout: featuredCollectionViewLayout);
        
        featuredCollectionView.showsVerticalScrollIndicator = false;
        featuredCollectionView.showsHorizontalScrollIndicator = false;
        featuredCollectionView.delegate = self;
        featuredCollectionView.dataSource = self;
        featuredCollectionView.register(featuredCollectionViewCell.self, forCellWithReuseIdentifier: featuredCollectionViewCell.identifier);
        
        nextY += featuredCollectionView.frame.height;
        
        self.view.addSubview(featuredCollectionView);
        
        //
        
        featuredArticleLabel.frame = CGRect(x: homePageHorizontalPadding, y: nextY, width: AppUtility.getCurrentScreenSize().width - 2*homePageHorizontalPadding, height: AppUtility.getCurrentScreenSize().width / 5);
        
        featuredArticleLabel.backgroundColor = .systemRed;
        featuredArticleLabel.numberOfLines = 2;
        featuredArticleLabel.font = UIFont(name: SFProDisplay_Bold, size: featuredArticleLabel.frame.height / 2);
        featuredArticleLabel.textColor = InverseBackgroundColor;
        
        nextY += featuredArticleLabel.frame.height + verticalPadding;
        
        self.view.addSubview(featuredArticleLabel);
        
        //
        
        
        
    }
    
    // UICollectionView Functions
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return featuredArticleArray.count;
        return 2;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: featuredCollectionViewCell.identifier, for: indexPath) as! featuredCollectionViewCell;
        cell.update(indexPath.row);
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected item at \(indexPath.row)");
    }
    
}
