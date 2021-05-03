//
//  communityPage.swift
//  AHS
//
//  Created by Richard Wei on 3/27/21.
//

import Foundation
import UIKit

class communityPageController : homeContentPageViewController{

    internal let verticalPadding : CGFloat = 20;
    internal var nextY : CGFloat = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        print("loaded community");
        
        loadCategories();
        
    }
    
    internal func loadCategories(){
        dataManager.getCommunityLocationData(completion: { (locationdata) in
            for categoryID in locationdata.categoryIDs{
                dataManager.getCategoryData(categoryID, completion: { (categorydata) in
                    self.renderCategory(categorydata);
                });
            }
        });
    }
    
    internal func renderCategory(_ categorydata: categoryData){
        
        let categoryViewFrame = CGRect(x: homePageHorizontalPadding, y: nextY, width: AppUtility.getCurrentScreenSize().width - 2*homePageHorizontalPadding, height: AppUtility.getCurrentScreenSize().width * 1.4);
        let categoryView = UIView(frame: categoryViewFrame);
        
        //categoryView.backgroundColor = .systemRed;
        
        let categoryViewHorizontalPadding = homePageHorizontalPadding;
        
        //
        
        let categoryTitleLabelFrame = CGRect(x: categoryViewHorizontalPadding, y: 0, width: categoryView.frame.width - 2*categoryViewHorizontalPadding, height: categoryView.frame.height * 0.1);
        let categoryTitleLabel = UILabel(frame: categoryTitleLabelFrame);
        
        categoryTitleLabel.text = categorydata.title;
        categoryTitleLabel.textColor = categorydata.color;
        categoryTitleLabel.font = UIFont(name: SFProDisplay_Black, size: categoryTitleLabel.frame.height * 0.5);
        categoryTitleLabel.textAlignment = .left;
        
        categoryView.addSubview(categoryTitleLabel);
        
        //
        
        nextY += categoryView.frame.height + verticalPadding;
        self.view.addSubview(categoryView);
        updateParentHeightConstraint();
    }

}
