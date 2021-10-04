//
//  notificationSettingsPageViewController.swift
//  AHS
//
//  Created by Richard Wei on 8/29/21.
//

import Foundation
import UIKit
import SwiftUI

class notificationSettingsPageViewController : presentableViewController{
    
    internal let dismissButton : UIButton = UIButton();
    
    internal let mainScrollView : UIScrollView = UIScrollView();
    internal let refreshControl : UIRefreshControl = UIRefreshControl();
    
    internal let verticalPadding : CGFloat = 10;
    internal let horizontalPadding : CGFloat = 10;
    
    internal var defaultNextY : CGFloat = 0;
    internal var nextY : CGFloat = 0;
    
    internal var categorySectionWidth : CGFloat = 0;
    internal var categorySectionHeight : CGFloat = 0;
    
    internal let allCategorySwitch : NotificationUISwitch = NotificationUISwitch();
    
    //
    
    override func viewDidLoad(){
        super.viewDidLoad();
        
        self.setupPanGesture();
        
        self.view.backgroundColor = BackgroundColor;
        
        //
        
        renderDismissView();
        
        //
        
        mainScrollView.frame = CGRect(x: 0, y: dismissButton.frame.maxY, width: self.view.frame.width, height: self.view.frame.height - dismissButton.frame.maxY);
        mainScrollView.alwaysBounceVertical = true;
        self.view.addSubview(mainScrollView);
        
        //
        
        mainScrollView.addSubview(refreshControl);
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged);
        
        //
        
        categorySectionWidth = mainScrollView.frame.width - 2*horizontalPadding;
        categorySectionHeight = categorySectionWidth * 0.08;
        
        //
        
        renderStaticContent(); // sets defaultNextY
        
        //
        
        nextY = defaultNextY;
        
        self.refreshControl.beginRefreshing();
        
        loadCategories();
        
    }
    
    //
    
    @objc internal func handleBackButton(_ button: UIButton){
        self.dismiss(animated: true);
    }
    
    @objc internal func refresh(){
        
        for subview in mainScrollView.subviews{
            if subview.tag == 1{
                subview.removeFromSuperview();
            }
        }
        
        nextY = defaultNextY;
        
        //
        
        updateAllCategorySwitchState();
        
        //
        
        self.loadCategories();
    }
    
    @objc internal func updateSwitchState(_ notificationSwitch: NotificationUISwitch){
        
        guard let categoryID = notificationSwitch.categoryID else{
            
            dataManager.setAllCategorySubscriptions(notificationSwitch.isOn);
            
            refresh();
            
            return;
        }
        
        dataManager.setUserSubscriptionToCategory(categoryID, notificationSwitch.isOn);
        updateAllCategorySwitchState();
        
    }
    
    internal func updateAllCategorySwitchState(){
        allCategorySwitch.setOn(dataManager.isUserSubscribedToAllCategories(), animated: true);
    }
    
    //
    
    private func renderDismissView(){
        
        let dismissViewWidth = self.view.frame.width;
        let dismissViewFrame = CGRect(x: 0, y: AppUtility.safeAreaInset.top, width: dismissViewWidth, height: dismissViewWidth * 0.09);
        dismissButton.frame = dismissViewFrame;
        
        //
        
        let dismissButtonHorizontalPadding : CGFloat = 10;
        let dismissButtonVerticalPadding : CGFloat = 5;
        
        //
        
        let dismissImageViewSize = dismissButton.frame.height - 2*dismissButtonVerticalPadding;
        
        let dismissImageViewFrame = CGRect(x: dismissButtonHorizontalPadding, y: dismissButtonVerticalPadding, width: dismissImageViewSize, height: dismissImageViewSize);
        let dismissImageView = UIImageView(frame: dismissImageViewFrame);
        
        dismissImageView.image = UIImage(systemName: "chevron.left");
        dismissImageView.contentMode = .scaleAspectFit;
        dismissImageView.tintColor = InverseBackgroundColor;
        
        dismissButton.addSubview(dismissImageView);
        
        //
        
        let dismissTitleLabelFrame = CGRect(x: dismissImageView.frame.maxX + dismissButtonHorizontalPadding, y: dismissButtonVerticalPadding, width: dismissButton.frame.width - 2*(dismissImageView.frame.maxX + dismissButtonHorizontalPadding), height: dismissButton.frame.height - 2*dismissButtonVerticalPadding);
        let dismissTitleLabel = UILabel(frame: dismissTitleLabelFrame);
        
        dismissTitleLabel.text = "Notification Settings";
        dismissTitleLabel.textAlignment = .left;
        dismissTitleLabel.textColor = UIColor.init(hex: "#c74534");
        dismissTitleLabel.font = UIFont(name: SFProDisplay_Bold, size: dismissTitleLabel.frame.height * 0.9);
        
        dismissButton.addSubview(dismissTitleLabel);
        
        //
        
        //dismissButton.backgroundColor = .systemRed;
        dismissButton.addTarget(self, action: #selector(self.handleBackButton), for: .touchUpInside);
        
        //
        
        self.view.addSubview(dismissButton);
        
    }
    
    private func renderStaticContent(){
        
        nextY = 2 * verticalPadding;
        
        //
        
        let allCategoryViewFrame = CGRect(x: horizontalPadding, y: nextY, width: categorySectionWidth, height: categorySectionHeight);
        let allCategoryView = UIView(frame: allCategoryViewFrame);
        
        //
        
        let categorySectionLabel = UILabel();
        
        categorySectionLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        allCategoryView.addSubview(categorySectionLabel);
        
        categorySectionLabel.leadingAnchor.constraint(equalTo: allCategoryView.leadingAnchor, constant: horizontalPadding).isActive = true;
        categorySectionLabel.topAnchor.constraint(equalTo: allCategoryView.topAnchor).isActive = true;
        categorySectionLabel.bottomAnchor.constraint(equalTo: allCategoryView.bottomAnchor).isActive = true;
        
        categorySectionLabel.text = "All Categories";
        categorySectionLabel.textColor = InverseBackgroundColor;
        categorySectionLabel.font = UIFont(name: SFProDisplay_Semibold, size: categorySectionHeight * 0.7);
        
        //
                
        allCategorySwitch.translatesAutoresizingMaskIntoConstraints = false;
        
        allCategoryView.addSubview(allCategorySwitch);
        
        allCategorySwitch.trailingAnchor.constraint(equalTo: allCategoryView.trailingAnchor, constant: -horizontalPadding).isActive = true;
        allCategorySwitch.topAnchor.constraint(equalTo: allCategoryView.topAnchor).isActive = true;
        allCategorySwitch.bottomAnchor.constraint(equalTo: allCategoryView.bottomAnchor).isActive = true;
        
        allCategorySwitch.categoryID = nil;
        allCategorySwitch.isOn = dataManager.isUserSubscribedToAllCategories();
        
        allCategorySwitch.addTarget(self, action: #selector(self.updateSwitchState), for: .valueChanged);
        
        //
        
        mainScrollView.addSubview(allCategoryView);
        nextY += allCategoryView.frame.height + verticalPadding;
        
        //
        
        let seperatorViewFrame = CGRect(x: 0, y: nextY, width: mainScrollView.frame.width, height: 0.1);
        let seperatorView = UIView(frame: seperatorViewFrame);
        
        seperatorView.backgroundColor = UIColor{ theme in
            return theme.userInterfaceStyle == .dark ? UIColor.darkGray : UIColor.lightGray;
        };
        
        mainScrollView.addSubview(seperatorView);
        nextY += seperatorView.frame.height + verticalPadding;
        
        //
        
        defaultNextY = nextY;
        
    }
    
    internal func loadCategories(){
        
        dataManager.getCategoryIDForEach(completion: { (categoryID) in
            
            dataManager.getCategoryData(categoryID, completion: { (categorydata) in
                
                if (categorydata.visible){
                    
                    self.refreshControl.endRefreshing();
                    
                    //print("category - \(categorydata.title)");
                    
                    self.renderCategory(categorydata);
                    
                }
                
            });
            
        });
        
    }
    
    private func renderCategory(_ categorydata: categoryData){
        
        let categorySectionViewFrame = CGRect(x: horizontalPadding, y: nextY, width: categorySectionWidth, height: categorySectionHeight);
        let categorySectionView = UIView(frame: categorySectionViewFrame);
        
        //categorySectionView.backgroundColor = .systemRed;
        
        //
        
        let categorySectionLabel = UILabel();
        
        categorySectionLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        categorySectionView.addSubview(categorySectionLabel);
        
        categorySectionLabel.leadingAnchor.constraint(equalTo: categorySectionView.leadingAnchor, constant: horizontalPadding).isActive = true;
        categorySectionLabel.topAnchor.constraint(equalTo: categorySectionView.topAnchor).isActive = true;
        categorySectionLabel.bottomAnchor.constraint(equalTo: categorySectionView.bottomAnchor).isActive = true;
        
        categorySectionLabel.text = categorydata.title;
        categorySectionLabel.textColor = InverseBackgroundColor;
        categorySectionLabel.font = UIFont(name: SFProDisplay_Semibold, size: categorySectionHeight * 0.7);
        
        //
        
        let categorySectionSwitch = NotificationUISwitch();
        
        categorySectionSwitch.translatesAutoresizingMaskIntoConstraints = false;
        
        categorySectionView.addSubview(categorySectionSwitch);
        
        categorySectionSwitch.trailingAnchor.constraint(equalTo: categorySectionView.trailingAnchor, constant: -horizontalPadding).isActive = true;
        categorySectionSwitch.topAnchor.constraint(equalTo: categorySectionView.topAnchor).isActive = true;
        categorySectionSwitch.bottomAnchor.constraint(equalTo: categorySectionView.bottomAnchor).isActive = true;
        
        categorySectionSwitch.categoryID = categorydata.categoryID;
        categorySectionSwitch.isOn = dataManager.isUserSubscribedToCategory(categorydata.categoryID);
        
        categorySectionSwitch.addTarget(self, action: #selector(self.updateSwitchState), for: .valueChanged);
        
        //
        
        categorySectionView.tag = 1;
        
        mainScrollView.addSubview(categorySectionView);
        nextY += categorySectionView.frame.height + verticalPadding;
        
        mainScrollView.contentSize = CGSize(width: mainScrollView.frame.width, height: nextY);
        
    }
    
}
