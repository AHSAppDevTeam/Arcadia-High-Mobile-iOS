//
//  schedulePageViewController.swift
//  AHS
//
//  Created by Richard Wei on 8/29/21.
//

import Foundation
import UIKit
import JTAppleCalendar

class schedulePageViewController : presentableViewController{
    
    //
    
    internal let dismissButton : UIButton = UIButton();
    
    internal let mainScrollView : UIButtonScrollView = UIButtonScrollView();
    internal let refreshControl : UIRefreshControl = UIRefreshControl();
    
    internal let horizontalPadding : CGFloat = 10;
    internal let verticalPadding : CGFloat = 10;
    
    internal let monthLabel : UILabel = UILabel();
    internal let calendarView : JTACMonthView = JTACMonthView();
    
    internal var nextY : CGFloat = 0;
    internal var defaultNextY : CGFloat = 0;
    
    //
    
    override func viewDidLoad() {
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
        
        renderStaticContent();
        
    }
    
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
        
        dismissTitleLabel.text = "Schedule";
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
    
    //
    
    internal func renderStaticContent(){
        
        nextY += verticalPadding;
        
        //
        
        let monthLabelWidth = mainScrollView.frame.width - 2*horizontalPadding;
        let monthLabelFrame = CGRect(x: horizontalPadding, y: nextY, width: monthLabelWidth, height: monthLabelWidth * 0.1);
        monthLabel.frame = monthLabelFrame;
        
        monthLabel.text = timeManager.getMonthString() + " " + timeManager.getYearString();
        monthLabel.textAlignment = .center;
        monthLabel.textColor = InverseBackgroundColor;
        monthLabel.font = UIFont(name: SFProDisplay_Semibold, size: monthLabel.frame.height * 0.7);
        
        mainScrollView.addSubview(monthLabel);
        nextY += monthLabel.frame.height + (verticalPadding / 2);
        
        //
        
        let calendarViewWidth = mainScrollView.frame.width;
        let calendarViewFrame = CGRect(x: 0, y: nextY, width: calendarViewWidth, height: calendarViewWidth * 0.8);
        //let calendarView = JTAppleCalendarView(frame: calendarViewFrame);
        calendarView.frame = calendarViewFrame;
        
        calendarView.calendarDelegate = self;
        calendarView.calendarDataSource = self;
        calendarView.register(ScheduleCalendarDayCell.self, forCellWithReuseIdentifier: ScheduleCalendarDayCell.identifier);
        
        calendarView.minimumInteritemSpacing = 1;
        calendarView.minimumLineSpacing = 1;
        
        calendarView.backgroundColor = BackgroundColor;
        
        calendarView.scrollDirection = .horizontal;
        calendarView.isPagingEnabled = true;
        calendarView.showsHorizontalScrollIndicator = false;
        calendarView.showsVerticalScrollIndicator = false;
        
        calendarView.selectDates([Date()]);
        
        mainScrollView.addSubview(calendarView);
        nextY += calendarView.frame.height + verticalPadding;
        
        //
        
        defaultNextY = nextY;
        
    }
    
    internal func renderContent(){
        
    }
    
}
