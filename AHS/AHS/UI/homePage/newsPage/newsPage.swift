//
//  newsPage.swift
//  AHS
//
//  Created by Richard Wei on 3/27/21.
//

import Foundation
import UIKit
import UPCarouselFlowLayout

class newsPageController : homeContentPageViewController, UIScrollViewDelegate{
    
    internal let verticalPadding : CGFloat = 10;
    internal let featuredVerticalPadding : CGFloat = 5;
    
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
    
    // Category views
    internal var categoryParentViews : [UIView] = [];
    internal var categoryScrollViewPageControlViews : [UIPageControl] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad();

        print("loaded news");
        
        renderFeatured();
        loadFeaturedArticles();
        
        loadCategories();
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        
        updateParentHeightConstraint();
        
    }
    
    internal func updateParentHeightConstraint(){
        guard let parentVC = self.parent as? homePageViewController else{
            return;
        }
        parentVC.contentViewHeightAnchor.constant = self.getSubviewsMaxY();
    }
    
    // UIScrollView Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (scrollView.tag == 0){ // must be from the featuredCollectionView
            // https://stackoverflow.com/a/38312063/
            
            let centerPoint = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2));
            guard let indexPath = featuredCollectionView.indexPathForItem(at: centerPoint) else {
                return;
            }
            
            // print("page - \(indexPath.row)");
            updateFeaturedArticleInfo(indexPath.row);
        }
        else{
            let index = scrollView.tag - 1;
            
            
            
        }
        
    }
    
}
