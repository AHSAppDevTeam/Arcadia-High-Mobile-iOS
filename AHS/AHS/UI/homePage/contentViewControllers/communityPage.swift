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
                    self.renderCategory(categorydata);
                });
            }
        });
    }
    
    internal func renderCategory(_ categorydata: categoryData){
        
        let categoryViewFrame = CGRect(x: homePageHorizontalPadding, y: nextContentY, width: AppUtility.getCurrentScreenSize().width - 2*homePageHorizontalPadding, height: AppUtility.getCurrentScreenSize().width * 1.2);
        let categoryView = CategoryButton(frame: categoryViewFrame);
        categoryView.tag = 1;
        
        // content inside each category
        
        let categoryTitleLabelFrame = CGRect(x: 0, y: 0, width: categoryView.frame.width, height: categoryView.frame.height * 0.15);
        let categoryTitleLabel = UILabel(frame: categoryTitleLabelFrame);
        
        categoryTitleLabel.text = categorydata.title;
        categoryTitleLabel.textColor = categorydata.color;
        categoryTitleLabel.font = UIFont(name: SFProDisplay_Black, size: categoryTitleLabel.frame.height * 0.5);
        categoryTitleLabel.textAlignment = .left;
        categoryTitleLabel.isUserInteractionEnabled = false;
        
        categoryView.addSubview(categoryTitleLabel);
        
        //

        let categoryContentViewFrame = CGRect(x: 0, y: categoryTitleLabel.frame.height, width: categoryView.frame.width, height: categoryView.frame.height - categoryTitleLabel.frame.height);
        let categoryContentView = UIView(frame: categoryContentViewFrame);
        categoryContentView.isUserInteractionEnabled = false;
        
        let categoryContentViewHorizontalPadding = categoryContentView.frame.width / 25;
        let categoryContentViewVerticalPadding = categoryContentView.frame.height / 35;
        
        // content inside content view ----
        
        let categoryFindViewWidth = (categoryContentView.frame.width * 0.45) - 2*categoryContentViewHorizontalPadding;
        let categoryFindViewHeight = categoryFindViewWidth * 0.2;
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
        
        let categoryDescriptionLabelText = categorydata.blurb;
        let categoryDescriptionLabelWidth = categoryContentView.frame.width - 2*categoryContentViewHorizontalPadding;
        let categoryDescriptionLabelFont = UIFont(name: SFProDisplay_Semibold, size: UIScreen.main.scale * 8)!;
        let categoryDescriptionLabelHeight = categoryDescriptionLabelText.height(withConstrainedWidth: categoryDescriptionLabelWidth, font: categoryDescriptionLabelFont)
        
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
        
        let categoryImagesViewFrame = CGRect(x: 0, y: 0, width: categoryContentView.frame.width, height: categoryContentView.frame.height - categoryFindView.frame.height - categoryDescriptionLabel.frame.height - 3*categoryContentViewVerticalPadding);
        let categoryImagesView = UIView(frame: categoryImagesViewFrame);
        
        categoryImagesView.layer.cornerRadius = categoryContentView.frame.height / 20;
        categoryImagesView.clipsToBounds = true;
        categoryImagesView.isUserInteractionEnabled = false;
        
        categoryImagesView.backgroundColor = .systemRed;
        
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
        categoryView.CategoryData = categorydata;
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
        print("category page - \(sender.CategoryData.title)");
    }

}
