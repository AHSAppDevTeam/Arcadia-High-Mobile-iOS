//
//  notificationPageViewController.swift
//  AHS
//
//  Created by Richard Wei on 7/9/21.
//

import Foundation
import UIKit
import AMPopTip

class notificationPageViewController : presentableViewController{
    
    //
    
    internal let topBarView : UIView = UIView();
    
    internal let refreshControl : UIRefreshControl = UIRefreshControl();
    internal let mainScrollView : UIButtonScrollView = UIButtonScrollView();
    
    internal let topContentView : UIView = UIView();
    
    //internal var nextY : CGFloat = 0;
    
    internal let horizontalPadding : CGFloat = 10;
    internal let verticalPadding : CGFloat = 5;
    
    internal let sortByPopTip : PopTip = PopTip();
    
    internal var cellHeight : CGFloat = 0;
    
    //
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        setupPanGesture();
        
        self.view.backgroundColor = BackgroundColor;
        
        //
        
        renderTopBar();
        
        //
        
        mainScrollView.frame = CGRect(x: 0, y: topBarView.frame.maxY, width: self.view.frame.width, height: self.view.frame.height - topBarView.frame.maxY);
        mainScrollView.alwaysBounceVertical = true;
        mainScrollView.delegate = self;
        self.view.addSubview(mainScrollView);
        
        //
        
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged);
        mainScrollView.addSubview(refreshControl);
        
        //
        
        renderTopContent();
        
        loadNotificationList();
    }
    
    internal func renderTopBar(){
        
        let topBarViewWidth = self.view.frame.width - 2*horizontalPadding;
        topBarView.frame = CGRect(x: horizontalPadding, y: AppUtility.safeAreaInset.top, width: topBarViewWidth, height: topBarViewWidth * 0.11);
        
        //
        
        let topBarButtonSize = topBarView.frame.height - 2*verticalPadding;
        let topBarButtonInset = topBarButtonSize / 8;
        let topBarButtonEdgeInsets = UIEdgeInsets(top: topBarButtonInset, left: topBarButtonInset, bottom: topBarButtonInset, right: topBarButtonInset);
        //
        
        let topBarBackButtonFrame = CGRect(x: 0, y: verticalPadding, width: topBarButtonSize, height: topBarButtonSize);
        let topBarBackButton = UIButton(frame: topBarBackButtonFrame);
        
        topBarBackButton.setImage(UIImage(systemName: "chevron.left"), for: .normal);
        
        topBarBackButton.imageView?.contentMode = .scaleAspectFit;
        topBarBackButton.contentVerticalAlignment = .fill;
        topBarBackButton.contentHorizontalAlignment = .fill;
        topBarBackButton.imageEdgeInsets = topBarButtonEdgeInsets;
        topBarBackButton.tintColor = BackgroundGrayColor;
        
        topBarBackButton.addTarget(self, action: #selector(self.exit), for: .touchUpInside);
        
        topBarView.addSubview(topBarBackButton);
        
        //

        let topBarTitleButtonFrame = CGRect(x: topBarBackButton.frame.width, y: verticalPadding, width: topBarView.frame.width - topBarBackButton.frame.width, height: topBarView.frame.height - 2*verticalPadding);
        let topBarTitleButton = UIButton(frame: topBarTitleButtonFrame);
        
        topBarTitleButton.setTitle("Notifications", for: .normal);
        topBarTitleButton.setTitleColor(UIColor.init(hex: "#c74534"), for: .normal);
        topBarTitleButton.contentHorizontalAlignment = .left;
        topBarTitleButton.titleLabel?.textAlignment = .left;
        topBarTitleButton.titleLabel?.font = UIFont(name: SFProDisplay_Bold, size: topBarTitleButton.frame.height * 0.8);
        
        topBarTitleButton.addTarget(self, action: #selector(self.exit), for: .touchUpInside);
        
        topBarView.addSubview(topBarTitleButton);
        
        //

        self.view.addSubview(topBarView);
        
    }
    
    internal func renderTopContent(){
        
        let topContentViewWidth = mainScrollView.frame.width;
        let topContentViewHeight = topContentViewWidth * 0.05;
        //topContentView.frame = CGRect(x: 0, y: 0, width: topContentViewWidth, height: topContentViewWidth * 0.05);
        
        topContentView.translatesAutoresizingMaskIntoConstraints = false;
        
        mainScrollView.addSubview(topContentView);
        
        topContentView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor).isActive = true;
        topContentView.topAnchor.constraint(equalTo: mainScrollView.topAnchor).isActive = true;
        topContentView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor).isActive = true;
        topContentView.widthAnchor.constraint(equalToConstant: topContentViewWidth).isActive = true;
        topContentView.heightAnchor.constraint(equalToConstant: topContentViewHeight).isActive = true;
        topContentView.bottomAnchor.constraint(lessThanOrEqualTo: mainScrollView.bottomAnchor).isActive = true;
        
        //
        
        let sortButtonHeight = topContentViewHeight;
    
        let sortButtonLabelText = "Sort By";
        let sortButtonLabelFont = UIFont(name: SFProDisplay_Medium, size: sortButtonHeight * 0.8)!;
        let sortButtonLabelWidth = sortButtonLabelText.width(withConstrainedHeight: sortButtonHeight, font: sortButtonLabelFont);
        
        let sortButtonImageViewPadding = sortButtonHeight * 0.15;
        let sortButtonImageViewSize = sortButtonHeight - 2*sortButtonImageViewPadding;
        
        let sortButtonWidth = sortButtonLabelWidth + sortButtonImageViewSize + sortButtonImageViewPadding;
        
        let sortButtonFrame = CGRect(x: horizontalPadding, y: 0, width: sortButtonWidth, height: sortButtonHeight);
        let sortButton = UIButton(frame: sortButtonFrame);
    
        ///
        
        let sortButtonImageViewFrame = CGRect(x: sortButtonLabelWidth + sortButtonImageViewPadding, y: sortButtonImageViewPadding, width: sortButtonImageViewSize, height: sortButtonImageViewSize);
        let sortButtonImageView = UIImageView(frame: sortButtonImageViewFrame);
        
        sortButtonImageView.image = UIImage(systemName: "chevron.down");
        sortButtonImageView.contentMode = .scaleAspectFit;
        sortButtonImageView.tintColor = BackgroundGrayColor;
        
        sortButton.addSubview(sortButtonImageView);
        
        ///
        
        let sortButtonLabelFrame = CGRect(x: 0, y: 0, width: sortButtonLabelWidth, height: sortButtonHeight);
        let sortButtonLabel = UILabel(frame: sortButtonLabelFrame);
        
        sortButtonLabel.text = sortButtonLabelText;
        sortButtonLabel.font = sortButtonLabelFont;
        sortButtonLabel.textAlignment = .left;
        sortButtonLabel.textColor = BackgroundGrayColor;
        
        sortButton.addSubview(sortButtonLabel);
        
        ///
        
        sortButton.addTarget(self, action: #selector(self.sortBy), for: .touchUpInside);
        
        topContentView.addSubview(sortButton);
        
        //
        
        let clearAllButtonLabelHeight = topContentViewHeight * 0.8;
        let clearAllButtonLabelText = "Clear All";
        let clearAllButtonLabelFont = UIFont(name: SFProDisplay_Medium, size: clearAllButtonLabelHeight)!;
        let clearAllButtonLabelWidth = clearAllButtonLabelText.width(withConstrainedHeight: clearAllButtonLabelHeight, font: clearAllButtonLabelFont) + 2*horizontalPadding;
        
        let clearAllButtonFrame = CGRect(x: topContentViewWidth - (clearAllButtonLabelWidth + horizontalPadding), y: 0, width: clearAllButtonLabelWidth, height: topContentViewHeight);
        let clearAllButton = UIButton(frame: clearAllButtonFrame);
        
        clearAllButton.layer.cornerRadius = clearAllButton.frame.height / 4;
        clearAllButton.clipsToBounds = true;
        
        let clearAllButtonGradientLayer = CAGradientLayer();
        clearAllButtonGradientLayer.frame = clearAllButton.bounds;
        clearAllButtonGradientLayer.colors = [UIColor.init(hex: "#c84c2f").cgColor, UIColor.init(hex: "#d06f35").cgColor];
        clearAllButtonGradientLayer.locations = [0.0, 1.0];
        clearAllButton.layer.insertSublayer(clearAllButtonGradientLayer, at: 0);
        
        clearAllButton.setTitle(clearAllButtonLabelText, for: .normal);
        clearAllButton.setTitleColor(.white, for: .normal);
        clearAllButton.titleLabel?.font = clearAllButtonLabelFont;
        clearAllButton.titleLabel?.textAlignment = .center;
        
        clearAllButton.addTarget(self, action: #selector(self.clearAll), for: .touchUpInside);
        topContentView.addSubview(clearAllButton);
        
    }
    
    internal func loadNotificationList(){
        self.refreshControl.beginRefreshing();
        dataManager.getNotificationList(completion: { (notificationIDList) in
            dataManager.loadNotificationList(notificationIDList, completion: { () in
                
                self.renderContent(notificationIDList);
                self.refreshControl.endRefreshing();
                
            });
        });
    }
    
    internal func renderContent(_ notificationIDList: [String]){
        
        for subview in mainScrollView.subviews{
            if subview.tag == 1{
                subview.removeFromSuperview();
            }
        }
        
        let contentVerticalPadding = 2*verticalPadding;
        
        //print("list size - \(notificationList.count)")
        
        var previousViewBottomAnchor : NSLayoutYAxisAnchor = topContentView.bottomAnchor;
        
        let notificationList : [notificationData] = sortNotifications(filterNotifications(notificationIDList));
        
        var unreadNotificationCount : Int = 0;
        
        for notificationdata in notificationList{
            
            let notificationViewWidth = mainScrollView.frame.width - 2*horizontalPadding;
            
            let isNotificationRead = dataManager.isNotificationRead(notificationdata.notificationID);
            
            let notificationView = NotificationButton();
            
            notificationView.translatesAutoresizingMaskIntoConstraints = false;
            
            self.mainScrollView.addSubview(notificationView);
            
            notificationView.leadingAnchor.constraint(equalTo: self.mainScrollView.leadingAnchor, constant: self.horizontalPadding).isActive = true;
            notificationView.topAnchor.constraint(equalTo: previousViewBottomAnchor, constant: contentVerticalPadding).isActive = true;
            notificationView.trailingAnchor.constraint(equalTo: self.mainScrollView.trailingAnchor, constant: -self.horizontalPadding).isActive = true;
            notificationView.widthAnchor.constraint(equalToConstant: notificationViewWidth).isActive = true;
            //notificationView.heightAnchor.constraint(equalToConstant: 200).isActive = true;
            
            notificationView.tag = 1;
            
            notificationView.backgroundColor = BackgroundSecondaryGrayColor;
            notificationView.layer.cornerRadius = notificationViewWidth / 25;
            notificationView.clipsToBounds = true;
            
            self.renderNotification(notificationView, notificationViewWidth, notificationdata, isNotificationRead);
            
            notificationView.notificationID = notificationdata.notificationID;
            
            notificationView.addTarget(self, action: #selector(self.readNotification), for: .touchUpInside);
            
            previousViewBottomAnchor = notificationView.bottomAnchor;
            
            unreadNotificationCount += isNotificationRead ? 0 : 1;
            
        }
        
        previousViewBottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor, constant: contentVerticalPadding).isActive = true;
        
        AppUtility.setAppNotificationNumber(unreadNotificationCount);
        //mainScrollView.contentSize = CGSize(width: mainScrollView.frame.width, height: nextY);
    }
    
    internal func renderNotification(_ notificationView: UIView, _ notificationViewWidth: CGFloat, _ notificationdata: notificationData, _ isNotificationRead: Bool? = nil){
        
        //let topViewFrame = CGRect(x: 0, y: 0, width: notificationView.frame.width, height: notificationView.frame.height * 0.28);
        
        let isRead : Bool = isNotificationRead == nil ? dataManager.isNotificationRead(notificationdata.notificationID) : isNotificationRead!;
        
        //
        
        let topView = UIView();
        
        let topViewWidth = notificationViewWidth;
        let topViewHeight = notificationViewWidth * 0.06;
        
        topView.translatesAutoresizingMaskIntoConstraints = false;
        
        notificationView.addSubview(topView);
        
        topView.leadingAnchor.constraint(equalTo: notificationView.leadingAnchor).isActive = true;
        topView.topAnchor.constraint(equalTo: notificationView.topAnchor).isActive = true;
        topView.trailingAnchor.constraint(equalTo: notificationView.trailingAnchor).isActive = true;
        topView.widthAnchor.constraint(equalToConstant: topViewWidth).isActive = true;
        topView.heightAnchor.constraint(equalToConstant: topViewHeight).isActive = true;
        
        topView.isUserInteractionEnabled = false;
        
        topView.tag = 1;
        
        //
        
        let categoryLabel = UILabel();
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        topView.addSubview(categoryLabel);
        
        categoryLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: horizontalPadding).isActive = true;
        categoryLabel.topAnchor.constraint(equalTo: topView.topAnchor).isActive = true;
        categoryLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true;
        
        categoryLabel.textAlignment = .left;
        categoryLabel.textColor = InverseBackgroundColor;
        categoryLabel.font = UIFont(name: SFProDisplay_Semibold, size: topViewHeight * 0.7);
        categoryLabel.numberOfLines = 1;
        categoryLabel.text = notificationdata.categoryID;
        
        //
        
        let timestampLabel = UILabel();
        
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        topView.addSubview(timestampLabel);
        
        timestampLabel.leadingAnchor.constraint(equalTo: categoryLabel.trailingAnchor).isActive = true;
        timestampLabel.topAnchor.constraint(equalTo: categoryLabel.topAnchor).isActive = true;
        timestampLabel.bottomAnchor.constraint(equalTo: categoryLabel.bottomAnchor).isActive = true;
        timestampLabel.trailingAnchor.constraint(lessThanOrEqualTo: topView.trailingAnchor, constant: horizontalPadding).isActive = true;
        
        timestampLabel.textAlignment = .left;
        timestampLabel.textColor = InverseBackgroundGrayColor;
        timestampLabel.font = UIFont(name: SFProDisplay_Regular, size: topViewHeight * 0.5);
        timestampLabel.numberOfLines = 1;
        timestampLabel.text = timestampLabelTextPrefix + timeManager.epochToDiffString(notificationdata.notifTimestamp);
        
        ///
        
        notificationView.addSubview(topView);
        
        //
        
        //let bottomViewFrame = CGRect(x: 0, y: topView.frame.height, width: notificationView.frame.width, height: notificationView.frame.height - topView.frame.height);
        let bottomView = UIView();
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false;
        
        notificationView.addSubview(bottomView);
        
        bottomView.leadingAnchor.constraint(equalTo: notificationView.leadingAnchor).isActive = true;
        bottomView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true;
        bottomView.trailingAnchor.constraint(equalTo: notificationView.trailingAnchor).isActive = true;
        bottomView.widthAnchor.constraint(equalToConstant: notificationViewWidth).isActive = true;
        bottomView.bottomAnchor.constraint(equalTo: notificationView.bottomAnchor).isActive = true;
        
        bottomView.tag = 1;
        
        bottomView.isUserInteractionEnabled = false;
        
        ///
        
        //let categoryColorViewHeight = bottomView.frame.height;
        //let categoryColorViewFrame = CGRect(x: horizontalPadding, y: 0, width: categoryColorViewHeight * 0.065, height: categoryColorViewHeight);
        let categoryColorView = UIView();
        
        categoryColorView.translatesAutoresizingMaskIntoConstraints = false;
        
        bottomView.addSubview(categoryColorView);
        
        categoryColorView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: horizontalPadding).isActive = true;
        categoryColorView.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true;
        categoryColorView.widthAnchor.constraint(equalToConstant: notificationViewWidth * 0.009).isActive = true;
        categoryColorView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor).isActive = true;
        
        categoryColorView.backgroundColor = BackgroundGrayColor;
        
        ///
        
        //let notificationLabelHeight = (bottomView.frame.height - 3*verticalPadding) / 2;
        //let notificationLabelWidth = bottomView.frame.width - categoryColorView.frame.maxX - 2*horizontalPadding;
        
        ///
        
        //let notificationTitleLabelFrame = CGRect(x: categoryColorView.frame.maxX + horizontalPadding, y: verticalPadding, width: notificationLabelWidth, height: notificationLabelHeight);
        let notificationTitleLabel = UILabel();
        
        notificationTitleLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        bottomView.addSubview(notificationTitleLabel);
        
        notificationTitleLabel.leadingAnchor.constraint(equalTo: categoryColorView.trailingAnchor, constant: horizontalPadding).isActive = true;
        notificationTitleLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: verticalPadding).isActive = true;
        notificationTitleLabel.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -horizontalPadding).isActive = true;
        
        notificationTitleLabel.textAlignment = .left;
        notificationTitleLabel.textColor = isRead ? BackgroundGrayColor : InverseBackgroundColor;
        notificationTitleLabel.font = UIFont(name: SFProDisplay_Semibold, size: notificationViewWidth * 0.06);
        notificationTitleLabel.numberOfLines = 0;
        notificationTitleLabel.text = notificationdata.title;
        
        ///
        
        //let notificationBlurbLabelFrame = CGRect(x: categoryColorView.frame.maxX + horizontalPadding, y: notificationTitleLabel.frame.maxY + verticalPadding, width: notificationLabelWidth, height: notificationLabelHeight);
        let notificationBlurbLabel = UILabel();
        
        notificationBlurbLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        bottomView.addSubview(notificationBlurbLabel);
        
        notificationBlurbLabel.leadingAnchor.constraint(equalTo: categoryColorView.trailingAnchor, constant: horizontalPadding).isActive = true;
        notificationBlurbLabel.topAnchor.constraint(equalTo: notificationTitleLabel.bottomAnchor, constant: verticalPadding).isActive = true;
        notificationBlurbLabel.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -horizontalPadding).isActive = true;
        notificationBlurbLabel.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -verticalPadding).isActive = true;
        
        notificationBlurbLabel.textAlignment = .left;
        notificationBlurbLabel.textColor = isRead ? BackgroundGrayColor : InverseBackgroundColor;
        notificationBlurbLabel.font = UIFont(name: SFProDisplay_Regular, size: notificationViewWidth * 0.04);
        notificationBlurbLabel.numberOfLines = 0;
        notificationBlurbLabel.text = notificationdata.blurb;
    
        ///
        
        notificationView.addSubview(bottomView);
        
        //
        
        dataManager.getCategoryData(notificationdata.categoryID, completion: { (categorydata) in
            
            categoryLabel.text = categorydata.title;
            categoryLabel.textColor = isRead ? BackgroundGrayColor : categorydata.color;
            
            categoryColorView.backgroundColor = isRead ? BackgroundGrayColor : categorydata.color;
            
        });
        
    }
    
}
