//
//  newsPage.swift
//  AHS
//
//  Created by Richard Wei on 3/27/21.
//

import Foundation
import UIKit
import UPCarouselFlowLayout

class newsPageController : homeContentPageViewController{
    
    internal let verticalPadding : CGFloat = 5;
    
    // Featured vars
    internal let featuredParentView : UIView = UIView();
    
    internal let featuredCollectionViewLayout = UPCarouselFlowLayout();
    internal var featuredCollectionView : UICollectionView = UICollectionView(frame: CGRect(), collectionViewLayout: UPCarouselFlowLayout());
    internal var featuredArticleArray : [baseArticleData] = [];
    
    internal let featuredArticleLabel : UILabel = UILabel();
    internal let featuredArticleCategoryView : UIView = UIView();
    internal let featuredArticleCategoryLabel : UILabel = UILabel();
    internal let featuredArticleTimestampLabel : UILabel = UILabel();
    internal let featuredArticleTimestampLabelTextPrefix = " ∙ ";
    
    override func viewDidLoad() {
        super.viewDidLoad();

        print("loaded news");
        
        renderFeatured();
        loadFeaturedArticles();
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        
        updateParentHeightConstraint();
        
    }
    
}
