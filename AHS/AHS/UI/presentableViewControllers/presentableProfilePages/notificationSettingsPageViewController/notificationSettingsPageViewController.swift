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
    
    internal let defaultNextY : CGFloat = 20;
    internal var nextY : CGFloat = 0;
    
    internal var categorySectionWidth : CGFloat = 0;
    internal var categorySectionHeight : CGFloat = 0;
    
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
        
        self.loadCategories();
    }
    
    @objc internal func updateSwitchState(_ notificationSwitch: NotificationUISwitch){
        dataManager.setUserSubscriptionToCategory(notificationSwitch.categoryID, notificationSwitch.isOn);
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
