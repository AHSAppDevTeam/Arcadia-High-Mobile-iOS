//
//  bulletinPage.swift
//  AHS
//
//  Created by Richard Wei on 3/14/21.
//

import Foundation
import UIKit

class bulletinPageViewController : mainPageViewController{
    
    init(){
        super.init(nibName: nil, bundle: nil);
        self.pageName = "Student";
        self.secondaryPageName = "Bulletin";
        self.viewControllerIconName = "doc.plaintext.fill";
    }
    
    required init?(coder: NSCoder) { // required uiviewcontroller init
        super.init(coder: coder);
    }
    
    internal var mainScrollView : UIButtonScrollView = UIButtonScrollView();
    internal var announcementsCategoryView : UIView = UIView();
    public var announcementsCategoryViewHeightAnchor : NSLayoutConstraint = NSLayoutConstraint();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        if (!self.hasBeenSetup) {
            self.view.backgroundColor = BackgroundColor;
            
            mainScrollView = UIButtonScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height));
            mainScrollView.alwaysBounceVertical = true;
            
            self.view.addSubview(mainScrollView);
            
            mainScrollView.addSubview(announcementsCategoryView);
            setupAnnouncementsCategory()
            
            loadCategories()
            self.hasBeenSetup = true;
        }
    }
    
    private func setupAnnouncementsCategory() {
        announcementsCategoryView.translatesAutoresizingMaskIntoConstraints = false;
        announcementsCategoryView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor).isActive = true;
        announcementsCategoryView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor).isActive = true;
        let announcementsCategoryConstraint = announcementsCategoryView.topAnchor.constraint(equalTo: mainScrollView.topAnchor);
        announcementsCategoryConstraint.isActive = true;
        
        let verticalPadding = CGFloat(10);
        announcementsCategoryConstraint.constant = verticalPadding;
        
        announcementsCategoryViewHeightAnchor = announcementsCategoryView.heightAnchor.constraint(equalToConstant: 0);
        announcementsCategoryViewHeightAnchor.isActive = true;
        
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
    private func renderCategory(_ categorydata: categoryData, _ categoryid: String) {
        
        let categoryViewWidth = AppUtility.getCurrentScreenSize().width - 2*homePageHorizontalPadding;
        let categoryImagesViewHeight = categoryViewWidth * 0.75;
        let categoryImagesViewFrame = CGRect(x: 0, y: 0, width: announcementsCategoryView.frame.width, height: categoryImagesViewHeight);
        let categoryImagesView = UIView(frame: categoryImagesViewFrame);
        
        categoryImagesView.layer.cornerRadius = announcementsCategoryView.frame.height / 20;
        categoryImagesView.clipsToBounds = true;
        categoryImagesView.isUserInteractionEnabled = false;
        
        //categoryImagesView.backgroundColor = .systemRed;
        
        let categoryImageViewGridCount = 4; // must be sqrt able
        let categoryImageViewGridSize = Int(Double(categoryImageViewGridCount).squareRoot());
        announcementsCategoryView.addSubview(categoryImagesView);
        
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
            
            categoryImagesView.addSubview(categoryPrimaryImageView);
            
        }
        else{ // use solid color
            categoryImagesView.backgroundColor = categorydata.color;
        }
        
        categoryImagesView.layer.cornerRadius = categoryImagesView.frame.height / 20;
        //categoryContentView.clipsToBounds = true;
        categoryImagesView.backgroundColor = BackgroundColor;
        categoryImagesView.layer.shadowOffset = CGSize(width: 0, height: 1);
        categoryImagesView.layer.shadowColor = BackgroundGrayColor.cgColor;
        categoryImagesView.layer.shadowOpacity = 0.5;
        categoryImagesView.layer.shadowRadius = 0.8;
        
        announcementsCategoryView.addSubview(categoryImagesView)
    }
}

