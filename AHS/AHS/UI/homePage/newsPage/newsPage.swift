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
    
    internal var nextY : CGFloat = 0;
    internal let verticalPadding : CGFloat = 5;
    
    // Featured vars
    internal var featuredCollectionView : UICollectionView = UICollectionView(frame: CGRect(), collectionViewLayout: UPCarouselFlowLayout());
    internal var featuredArticleArray : [baseArticleData] = [];
    internal var featuredArticleArrayCount = 1;
    
    override func viewDidLoad() {
        super.viewDidLoad();

        print("loaded news");
        
        renderFeatured();
    }
    
}
