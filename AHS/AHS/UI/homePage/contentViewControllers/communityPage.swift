//
//  communityPage.swift
//  AHS
//
//  Created by Richard Wei on 3/27/21.
//

import Foundation
import UIKit

class communityPageController : homeContentPageViewController{

    internal let verticalPadding : CGFloat = 10;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
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
        
        let categoryViewFrame = CGRect(x: homePageHorizontalPadding, y: nextContentY, width: AppUtility.getCurrentScreenSize().width - 2*homePageHorizontalPadding, height: AppUtility.getCurrentScreenSize().width);
        let categoryView = UIView(frame: categoryViewFrame);
    
        // content inside each category
        
        let categoryTitleLabelFrame = CGRect(x: 0, y: 0, width: categoryView.frame.width, height: categoryView.frame.height * 0.15);
        let categoryTitleLabel = UILabel(frame: categoryTitleLabelFrame);
        
        categoryTitleLabel.text = categorydata.title;
        categoryTitleLabel.textColor = categorydata.color;
        categoryTitleLabel.font = UIFont(name: SFProDisplay_Black, size: categoryTitleLabel.frame.height * 0.5);
        categoryTitleLabel.textAlignment = .left;
        
        categoryView.addSubview(categoryTitleLabel);
        
        //

        let categoryContentViewFrame = CGRect(x: 0, y: categoryTitleLabel.frame.height, width: categoryView.frame.width, height: categoryView.frame.height - categoryTitleLabel.frame.height);
        let categoryContentView = UIView(frame: categoryContentViewFrame);
        
        categoryContentView.layer.cornerRadius = categoryContentView.frame.height / 20;
        categoryContentView.backgroundColor = BackgroundColor;
        categoryContentView.layer.shadowOffset = CGSize(width: 0, height: 1);
        categoryContentView.layer.shadowColor = BackgroundGrayColor.cgColor;
        categoryContentView.layer.shadowOpacity = 0.5;
        categoryContentView.layer.shadowRadius = 0.8;
        
        categoryView.addSubview(categoryContentView);
        
        //
        
        nextContentY += categoryView.frame.height + verticalPadding;
        self.view.addSubview(categoryView);
        updateParentHeightConstraint();
    }

}
