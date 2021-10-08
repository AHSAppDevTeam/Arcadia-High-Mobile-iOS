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
    
    internal let mainScrollView : UIButtonScrollView = UIButtonScrollView();
    internal let refreshControl : UIRefreshControl = UIRefreshControl();
    
    internal let horizontalPadding : CGFloat = 10;
    internal let verticalPadding : CGFloat = 10;
    
    internal let calendarView : JTACMonthView = JTACMonthView();
    
    internal var nextY : CGFloat = 0;
    internal var defaultNextY : CGFloat = 0;
    
    //
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.setupPanGesture();
        
        self.view.backgroundColor = BackgroundColor;
        
        //
        
        mainScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height);
        
        mainScrollView.alwaysBounceVertical = true;
        
        self.view.addSubview(mainScrollView);
        
        //
        
        mainScrollView.addSubview(refreshControl);
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged);
        
        //
        
        renderStaticContent();
        
    }
    
    internal func renderStaticContent(){
        
        nextY += verticalPadding;
        
        //
        
        let monthLabelWidth = mainScrollView.frame.width - 2*horizontalPadding;
        let monthLabelFrame = CGRect(x: horizontalPadding, y: nextY, width: monthLabelWidth, height: monthLabelWidth * 0.1);
        let monthLabel = UILabel(frame: monthLabelFrame);
        
        monthLabel.text = timeManager.getMonthString();
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
        
        calendarView.minimumInteritemSpacing = 0.1;
        calendarView.minimumLineSpacing = 0.1;
        
        calendarView.backgroundColor = BackgroundColor;
        
        calendarView.scrollDirection = .horizontal;
        calendarView.isPagingEnabled = true;
        calendarView.showsHorizontalScrollIndicator = false;
        calendarView.showsVerticalScrollIndicator = false;
        
        mainScrollView.addSubview(calendarView);
        nextY += calendarView.frame.height + verticalPadding;
        
        //
        
        defaultNextY = nextY;
        
    }
    
    internal func renderContent(){
        
    }
    
}
