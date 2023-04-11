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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadCategories), name: NSNotification.Name(rawValue: homePageRefreshNotification), object: nil);
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: homePageRefreshNotification), object: nil);
    }
    
    internal func loadCategories(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: homePageBeginRefreshing), object: nil);
        dataManager.getCommunityLocationData(completion: { (locationdata) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: homePageEndRefreshing), object: nil);
            for categoryID in locationdata.categoryIDs{
                dataManager.getCategoryData(categoryID, completion: { (categorydata) in
                    self.renderCategory(categorydata, categoryID);
                });
            }
        });
    }
    
    internal func renderCategory(_ categorydata: categoryData, _ categoryID: String){
        
        // pre height calculations
        
        let categoryViewWidth = AppUtility.getCurrentScreenSize().width - 2*homePageHorizontalPadding;
        
        let categoryContentViewHorizontalPadding = categoryViewWidth / 25;
        let categoryContentViewVerticalPadding : CGFloat = 8;
        
        let categoryImagesViewHeight = categoryViewWidth * 0.75;
        
        let categoryDescriptionLabelText = categorydata.blurb;
        let categoryDescriptionLabelWidth = categoryViewWidth - 2*categoryContentViewHorizontalPadding;
        let categoryDescriptionLabelFont = UIFont(name: SFProDisplay_Semibold, size: self.view.frame.width * 0.05)!;
        let categoryDescriptionLabelHeight = categoryDescriptionLabelText.height(withConstrainedWidth: categoryDescriptionLabelWidth, font: categoryDescriptionLabelFont);
        
        let categoryFindViewWidth = (categoryViewWidth * 0.45) - 2*categoryContentViewHorizontalPadding;
        let categoryFindViewHeight = categoryFindViewWidth * 0.2;
        
        let categoryTitleLabelText = categorydata.title;
        let categoryTitleLabelFont = UIFont(name: SFProDisplay_Black, size: self.view.frame.width * 0.07)!;
        let categoryTitleLabelHeight = categoryTitleLabelText.height(withConstrainedWidth: categoryViewWidth, font: categoryTitleLabelFont) + categoryContentViewVerticalPadding;
        
        //
        
        let categoryViewFrame = CGRect(x: homePageHorizontalPadding, y: nextContentY, width: categoryViewWidth, height: categoryTitleLabelHeight + categoryImagesViewHeight + categoryDescriptionLabelHeight + categoryFindViewHeight + 3*categoryContentViewVerticalPadding);
        let categoryView = CategoryButton(frame: categoryViewFrame);
        categoryView.tag = 1;
        
        // content inside each category
        
        let categoryTitleLabelFrame = CGRect(x: 0, y: 0, width: categoryView.frame.width, height: categoryTitleLabelHeight);
        let categoryTitleLabel = UILabel(frame: categoryTitleLabelFrame);
        
        categoryTitleLabel.text = categoryTitleLabelText;
        categoryTitleLabel.textColor = categorydata.color;
        categoryTitleLabel.font = categoryTitleLabelFont;
        categoryTitleLabel.textAlignment = .left;
        categoryTitleLabel.isUserInteractionEnabled = false;
        
        categoryView.addSubview(categoryTitleLabel);
        
        //

        let categoryContentViewFrame = CGRect(x: 0, y: categoryTitleLabel.frame.height, width: categoryView.frame.width, height: categoryView.frame.height - categoryTitleLabel.frame.height);
        let categoryContentView = UIView(frame: categoryContentViewFrame);
        categoryContentView.isUserInteractionEnabled = false;
        
        // content inside content view ----
        
        let categoryFindViewFrame = CGRect(x: categoryContentViewHorizontalPadding, y: categoryContentView.frame.height - categoryFindViewHeight - categoryContentViewVerticalPadding, width: categoryFindViewWidth, height: categoryFindViewHeight);
        let categoryFindView = UIView(frame: categoryFindViewFrame);
        
        // ----
        
        let categoryFindImageViewHorizontalPadding = categoryFindView.frame.width / 30;
        let categoryFindImageViewHeight = categoryFindView.frame.height;
        let categoryFindImageViewWidth = categoryFindView.frame.height / 2;
        let categoryFindImageViewFrame = CGRect(x: categoryFindView.frame.width - categoryFindImageViewWidth - categoryFindImageViewHorizontalPadding, y: 0, width: categoryFindImageViewWidth, height: categoryFindImageViewHeight);
        let categoryFindImageView = UIImageView(frame: categoryFindImageViewFrame);
        
        categoryFindImageView.contentMode = .scaleAspectFit;
        categoryFindImageView.image = UIImage(systemName: "chevron.right");
        categoryFindImageView.tintColor = InverseBackgroundColor;
        
        categoryFindView.addSubview(categoryFindImageView);
        
        
        let categoryFindLabelHorizontalPadding = categoryFindView.frame.width / 15;
        let categoryFindLabelFrame = CGRect(x: categoryFindLabelHorizontalPadding, y: 0, width: categoryFindView.frame.width - 2*categoryFindLabelHorizontalPadding - categoryFindImageViewWidth - categoryFindImageViewHorizontalPadding, height: categoryFindView.frame.height);
        let categoryFindLabel = UILabel(frame: categoryFindLabelFrame);
        
        categoryFindLabel.text = "Find out more";
        categoryFindLabel.font = UIFont(name: SFProDisplay_Semibold, size: categoryFindLabel.font.pointSize);
        categoryFindLabel.numberOfLines = 1;
        categoryFindLabel.adjustsFontSizeToFitWidth = true;
        categoryFindLabel.textColor = InverseBackgroundColor;
        
        categoryFindView.addSubview(categoryFindLabel);
        
        // ----
        
        categoryFindView.layer.cornerRadius = categoryFindViewHeight / 4;
        categoryFindView.backgroundColor = UIColor{ _ in
            return UIColor.dynamicColor(light: UIColor.rgb(214, 214, 214), dark: UIColor.rgb(130, 130, 130))
        };
        
        categoryContentView.addSubview(categoryFindView);
        
        //
        
        let categoryDescriptionLabelFrame = CGRect(x: categoryContentViewHorizontalPadding, y: categoryContentView.frame.height - categoryFindView.frame.height - categoryDescriptionLabelHeight - 2*categoryContentViewVerticalPadding, width: categoryDescriptionLabelWidth, height: categoryDescriptionLabelHeight);
        let categoryDescriptionLabel = UILabel(frame: categoryDescriptionLabelFrame);
        
        categoryDescriptionLabel.textAlignment = .left;
        categoryDescriptionLabel.textColor = InverseBackgroundColor;
        categoryDescriptionLabel.text = categoryDescriptionLabelText;
        categoryDescriptionLabel.numberOfLines = 0;
        categoryDescriptionLabel.font = categoryDescriptionLabelFont;
        categoryDescriptionLabel.isUserInteractionEnabled = false;
        
        categoryContentView.addSubview(categoryDescriptionLabel);
        
        //
        
        let categoryImagesViewFrame = CGRect(x: 0, y: 0, width: categoryContentView.frame.width, height: categoryImagesViewHeight);
        let categoryImagesView = UIView(frame: categoryImagesViewFrame);
        
        categoryImagesView.layer.cornerRadius = categoryContentView.frame.height / 20;
        categoryImagesView.clipsToBounds = true;
        categoryImagesView.isUserInteractionEnabled = false;
        
        //categoryImagesView.backgroundColor = .systemRed;
        
        let categoryImageViewGridCount = 4; // must be sqrt able
        let categoryImageViewGridSize = Int(Double(categoryImageViewGridCount).squareRoot());
        
        if (categorydata.thumbURLs.count >= categoryImageViewGridCount){
            
            let categoryImagesViewVerticalStackView = UIStackView(frame: CGRect(x: 0, y: 0, width: categoryImagesView.frame.width, height: categoryImagesView.frame.height));
            categoryImagesViewVerticalStackView.axis = .vertical;
            categoryImagesViewVerticalStackView.spacing = 0;
            categoryImagesViewVerticalStackView.alignment = .fill;
            categoryImagesViewVerticalStackView.distribution = .fillEqually;
            
            for i in 0..<categoryImageViewGridSize{
            
                let categoryImagesViewHorizontalStackView = UIStackView();
                categoryImagesViewHorizontalStackView.axis = .horizontal;
                categoryImagesViewHorizontalStackView.spacing = 0;
                categoryImagesViewHorizontalStackView.alignment = .fill;
                categoryImagesViewHorizontalStackView.distribution = .fillEqually;
                
                for j in 0..<categoryImageViewGridSize{
                    
                    let gridCellIndex = (i * categoryImageViewGridSize) + j;
                    
                    let categoryGridCellImageView = UIImageView();
                    categoryGridCellImageView.setImageURL(categorydata.thumbURLs[gridCellIndex]);
                    categoryGridCellImageView.contentMode = .scaleAspectFill;
                    categoryGridCellImageView.backgroundColor = categorydata.color;
                    categoryGridCellImageView.clipsToBounds = true;
                    
                    categoryImagesViewHorizontalStackView.addArrangedSubview(categoryGridCellImageView);
                    
                }
                
                categoryImagesViewVerticalStackView.addArrangedSubview(categoryImagesViewHorizontalStackView);
                
            }
            
            categoryImagesView.addSubview(categoryImagesViewVerticalStackView);
            
        }
        else if (categorydata.thumbURLs.count > 0){
        
            let categoryPrimaryImageViewFrame = CGRect(x: 0, y: 0, width: categoryImagesView.frame.width, height: categoryImagesView.frame.height);
            let categoryPrimaryImageView = UIImageView(frame: categoryPrimaryImageViewFrame);
            
            categoryPrimaryImageView.setImageURL(categorydata.thumbURLs[0]);
            // TODO: Update with full res image
            
            categoryImagesView.addSubview(categoryPrimaryImageView);
            
        }
        else{ // use solid color
            categoryImagesView.backgroundColor = categorydata.color;
        }
        
        //
        
        categoryContentView.addSubview(categoryImagesView);
        
        
        // ---
        
        categoryContentView.layer.cornerRadius = categoryContentView.frame.height / 20;
        //categoryContentView.clipsToBounds = true;
        categoryContentView.backgroundColor = BackgroundColor;
        categoryContentView.layer.shadowOffset = CGSize(width: 0, height: 1);
        categoryContentView.layer.shadowColor = BackgroundGrayColor.cgColor;
        categoryContentView.layer.shadowOpacity = 0.5;
        categoryContentView.layer.shadowRadius = 0.8;
        
        categoryView.addSubview(categoryContentView);
        
        //
        
        nextContentY += categoryView.frame.height + verticalPadding;
        categoryView.categoryID = categoryID;
        categoryView.addTarget(self, action: #selector(self.openCategoryPage), for: .touchUpInside);
        self.view.addSubview(categoryView);
        updateParentHeightConstraint();
    }
    
    //
    
    @objc func reloadCategories(){
        for subview in self.view.subviews{
            if (subview.tag == 1){
                subview.removeFromSuperview();
            }
        }
        
        nextContentY = 0;
        self.updateParentHeightConstraint();
        
        self.loadCategories();
        
    }
    
    @objc func openCategoryPage(_ sender: CategoryButton){
        let categoryDataDict : [String : String] = ["categoryID" : sender.categoryID];
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: categoryPageNotification), object: nil, userInfo: categoryDataDict);
    }

}
